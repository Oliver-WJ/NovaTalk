import 'dart:convert';

import 'package:hive/hive.dart';

part 'ad_log_model.g.dart';

@HiveType(typeId: 0)
class AdLogModel extends HiveObject {
  @HiveField(0)
   String id;

  @HiveField(1)
   String eventType;

  @HiveField(2)
   String data;

  @HiveField(3)
   bool isSuccess;

  @HiveField(4)
   int createTime;

  @HiveField(5)
   int? uploadTime;

  @HiveField(6)
   bool isUploaded;

  AdLogModel({
    required this.id,
    required this.eventType,
    required this.data,
    this.isSuccess = false,
    required this.createTime,
    this.uploadTime,
    this.isUploaded = false,
  });

  String toJson () {
    return jsonEncode({
      "id": id,
      "eventType": eventType,
      "data": data,
      "isSuccess": isSuccess,
      "createTime": createTime,
      "uploadTime": uploadTime,
      "isUploaded": isUploaded,
    });
  }
}
