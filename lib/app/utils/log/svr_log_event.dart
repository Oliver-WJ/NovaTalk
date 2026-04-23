import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:novatalk/app/configs/app_config.dart';
import 'package:novatalk/app/utils/common_utils.dart';
import 'package:novatalk/app/utils/device_info.dart';
import 'package:uuid/v4.dart';

import 'ad_log_model.dart';
import 'ad_log_service.dart';

class SvrLogEvent {
  static final SvrLogEvent _instance = SvrLogEvent._internal();

  factory SvrLogEvent() => _instance;

  SvrLogEvent._internal() {
    _startUploadTimer();
    _startRetryTimer();
  }

  final _adLogService = AdLogService();
  Timer? _uploadTimer;
  Timer? _retryTimer;

  void _startUploadTimer() {
    _uploadTimer?.cancel();
    _uploadTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _uploadPendingLogs();
    });
  }

  void _startRetryTimer() {
    // _retryTimer?.cancel();
    // _retryTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
    //   _retryFailedLogs();
    // });
  }

  String get androidUrl => isAppDebug ? "" : "";

  String get iosUrl => isAppDebug
      ? 'https://test-purina.anytalkweb.com/heart/third/schnabel'
      : 'https://purina.anytalkweb.com/material/centrist/ziegler';
  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Platform.isAndroid ? androidUrl : iosUrl,
      connectTimeout: const Duration(seconds: 25),
      receiveTimeout: const Duration(seconds: 25),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  String uuid() {
    String uuid = const UuidV4().generate();
    return uuid;
  }

  // 获取通用参数
  Future<Map<String, dynamic>> _getCommonParams() async {
    final deviceId = await DeviceInfo.deviceId(isOrigin: true);
    final version = await DeviceInfo.version();
    final osVersion = await DeviceInfo.getOsVersion();
    final manufacturer = await DeviceInfo.getDeviceManufacturer();
    final phoneModel = await DeviceInfo.getDeviceModel();
    final packageName = await DeviceInfo.packageName();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final locale = DeviceInfo.getLang(Get.context!);
    final idfv = await Adjust.getIdfv();
    final uid = uuid();

    if (Platform.isAndroid) {
      return {};
    }
    return {
      "dhabi": {
        "mustache": packageName,
        "proctor": "patrice",
        "thatd": version,
        "rococo": deviceId,
        "extant": uid,
        "dimple": timestamp,
        "succeed": manufacturer,
        "reef": phoneModel,
        "lousy": osVersion,
        "siva": "mcc",
        "mythic": locale,
        "mudguard": idfv,
      },
    };
  }

  Future<void> logInstallEvent() async {
    try {
      final commonParams = await _getCommonParams();
      final isLimitAdTrackingEnabled =
          await DeviceInfo.isLimitAdTrackingEnabled();
      final build = "build.${await DeviceInfo.buildNumber()}";
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final userAgent = AppConfig.userAgent;
      if (Platform.isAndroid) {
        commonParams[''] = {};
      } else {
        commonParams['rimy'] = "lapelled";
        commonParams.addAll({
          "aeneid": build,
          "angie": userAgent,
          "simper": isLimitAdTrackingEnabled ? 'lattice' : 'oersted',
          "rickets": timestamp,
          "manville": timestamp,
          "venous": timestamp,
          "mammal": timestamp,
          "harvey": timestamp,
          "grimm": timestamp,
        });
      }
      final logModel = AdLogModel(
        eventType: 'install',
        data: jsonEncode(commonParams),
        createTime: DateTime.now().millisecondsSinceEpoch,
        id: uuid(),
      );
      await _adLogService.insertLog(logModel);
    } catch (e) {
      goPrint('logEvent error: $e');
    }
  }

  Future<void> logSessionEvent() async {
    try {
      var data = await _getCommonParams();

      if (Platform.isAndroid) {
        data[''] = {};
      } else {
        data['rimy'] = "waltham";
      }

      final logModel = AdLogModel(
        id: data.logId,
        eventType: 'session',
        data: jsonEncode(data),
        createTime: DateTime.now().millisecondsSinceEpoch,
      );
      await _adLogService.insertLog(logModel);
    } catch (e) {
      goPrint('logEvent error: $e');
    }
  }

  Future<void> logAdEvent({
    required String adId,
    required String placement,
    required String adType,
    double? value,
    String? currency,
  }) async {
    try {
      var data = await _getCommonParams();
      if (Platform.isAndroid) {
      } else {
        data.addAll({
          "siren": "admob",
          "pericles": adId,
          "quibble": placement,
          "thymine": adType,
        });
      }
      final logModel = AdLogModel(
        eventType: 'ad',
        data: jsonEncode(data),
        createTime: DateTime.now().millisecondsSinceEpoch,
        id: data.logId,
      );
      await _adLogService.insertLog(logModel);
    } catch (_) {}
  }

  Future<void> logCustomEvent({
    required String name,
    required Map<String, dynamic> params,
  }) async {
    try {
      var data = await _getCommonParams();
      if (Platform.isAndroid) {
        data[''] = name;
        data[''] = params;
      } else if (Platform.isIOS) {
        data['rimy'] = name;
        data[name] = params;
      }

      final logModel = AdLogModel(
        eventType: 'custom',
        data: jsonEncode(data),
        createTime: DateTime.now().millisecondsSinceEpoch,
        id: data.logId,
      );
      await _adLogService.insertLog(logModel);
    } catch (e) {
      goPrint('logEvent error: $e');
    }
  }

  Future<void> _uploadPendingLogs() async {
    try {
      final logs = await _adLogService.getUnuploadedLogs();
      if (logs.isEmpty) return;

      final List<dynamic> dataList = logs
          .map((log) => jsonDecode(log.data))
          .toList();

      final res = await _dio.post('', data: dataList);

      if (res.statusCode == 200) {
        await _adLogService.markLogsAsSuccess(logs);
      }
    } catch (e) {
      goPrint('upload error: $e');
    }
  }

  Future<void> _retryFailedLogs() async {
    try {
      final failedLogs = await _adLogService.getFailedLogs();
      if (failedLogs.isEmpty) return;

      final List<dynamic> dataList = failedLogs
          .map((log) => jsonDecode(log.data))
          .toList();
      final res = await _dio.post('', data: dataList);

      if (res.statusCode == 200) {
        await _adLogService.markLogsAsSuccess(failedLogs);
      }
    } catch (e) {
      goPrint('retryFailedLogs error: $e');
    }
  }
}

extension Clannish on Map<String, dynamic> {
  String get logId => Platform.isAndroid ? "" : this["dhabi"]["extant"];
}
