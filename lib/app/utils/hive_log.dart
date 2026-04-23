import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:queue/queue.dart';

import '../configs/app_config.dart';

void printLog(Object? object) {
  if (!kReleaseMode && !isAppDebug) {
    print(object);
  }
  HiveLog.print(object?.toString());
}

class LogEntity {
  String? log;
  int timestamp;

  LogEntity(this.timestamp, this.log);

  Map<String, Object?> toJson() {
    return {'log': log, 'timestamp': timestamp};
  }

  factory LogEntity.fromJson(Map<String, Object?> json) {
    return LogEntity(json['timestamp'] as int, json['log'] as String);
  }
}

class HiveLog {
  HiveLog._();

  static final HiveLog _inst = HiveLog._();
  final queue = Queue();
  final box = Hive.box<LogEntity>('log-box');

  static void print(String? log) {
    final logEntity = LogEntity(DateTime.timestamp().millisecond, log);
    final key = "${logEntity.timestamp}_${Random().nextInt(9999)}";
    _inst.queue.add(() async => await _inst.box.put(key, logEntity));
  }

  static Future<void> clear() async {
    await _inst.box.clear();
  }

  static Future<List<LogEntity>> getLogs() async {
    return _inst.box.values.toList();
  }
}

class LogPage extends StatelessWidget {
  const LogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () async {
              await HiveLog.clear();
            },
          ),
        ],
      ),

      body: FutureBuilder<List<LogEntity>>(
        future: HiveLog.getLogs(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final logs = snapshot.data!;
            return ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                final date = DateTime.fromMillisecondsSinceEpoch(
                  log.timestamp,
                  isUtc: true,
                );
                return ListTile(
                  title: Text(date.toString()),
                  subtitle: Text(log.log ?? ''),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
