import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:novatalk/app/configs/app_config.dart';
import 'package:novatalk/app/widgets/common_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/v4.dart';
import 'api_svc.dart';
import 'common_utils.dart';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';

class DeviceInfo {
  DeviceInfo._();

  static const String _kDeviceId = 'deviceId';
  static final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(),
  );

  ///获取设备ID
  static Future<String> deviceId({bool isOrigin = false}) async {
    String? devicesId = "";
    try {
      devicesId = await _secureStorage.read(key: _kDeviceId);
      if (devicesId.isVoid) {
        devicesId = await _getDeviceId();
        await _secureStorage.write(key: _kDeviceId, value: devicesId);
      }
    } catch (e) {
      goPrint('secure error: $e');
      devicesId = await _getDeviceId();
    }
    var platform = AppConfig.platform;

    return isOrigin ? devicesId! : '$platform.$devicesId';
  }

  ///获取手机端用户设备标识
  static Future<String> _getDeviceId() async {
    String getCustomDeviceId() {
      String? deviceNo = const UuidV4().generate();
      return deviceNo;
    }

    if (Platform.isAndroid) {
      const androidIdPlugin = AndroidId();
      final String? androidId = await androidIdPlugin.getId();
      return androidId ?? getCustomDeviceId();
    } else if (Platform.isIOS) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor?.isNotEmpty == true
          ? iosInfo.identifierForVendor!
          : getCustomDeviceId();
    } else {
      return getCustomDeviceId();
    }
  }

  static PackageInfo? _packageInfo;

  static Future<PackageInfo> getPackageInfo() async {
    if (_packageInfo != null) {
      return _packageInfo!;
    }
    _packageInfo = await PackageInfo.fromPlatform();
    return _packageInfo!;
  }

  static Future<String> version() async {
    return (await getPackageInfo()).version;
  }

  static Future<String> buildNumber() async {
    return (await getPackageInfo()).buildNumber;
  }

  static Future<String> packageName() async {
    return (await getPackageInfo()).packageName;
  }

  static Future<String> getIdfa() async {
    try {
      if (!Platform.isIOS) {
        return '';
      }
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;

      if (status == TrackingStatus.notDetermined) {
        await Future.delayed(const Duration(milliseconds: 200));
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
      final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
      goPrint('uid: $uuid');
      ApiSvc.updateEventParams();
      return uuid;
    } catch (e) {
      goPrint('Idfa error: $e');
    }
    return '';
  }

  // 获取idfv
  static Future<String> getIdfv() async {
    if (!Platform.isIOS) {
      return '';
    }
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor ?? '';
  }

  // device_model
  static Future<String> getDeviceModel() async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.model;
    }
    if (Platform.isIOS) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.utsname.machine;
    }
    return '';
  }

  // 手机厂商
  static Future<String> getDeviceManufacturer() async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.manufacturer;
    }
    if (Platform.isIOS) {
      return 'Apple';
    }
    return '';
  }

  // 操作系统版本
  static Future<String> getOsVersion() async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.release;
    }
    if (Platform.isIOS) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.systemVersion;
    }
    return '';
  }

  static Future<bool> isLimitAdTrackingEnabled() async {
    if (Platform.isIOS) {
      final attStatus = await Adjust.getAppTrackingAuthorizationStatus();
      return attStatus == 0 || attStatus == 1; // 0=未决定,1=限制跟踪
    } else if (Platform.isAndroid) {
      final isLimitAdTracking = await Adjust.isEnabled();
      return !isLimitAdTracking; // Android返回的是是否启用跟踪，取反得到是否限制
    }
    return false;
  }

  static String getLang(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    String languageCode = locale.languageCode; // 'zh'
    String countryCode = locale.countryCode ?? ''; // 'CN'
    String localeString = '${languageCode}_$countryCode'; // 'zh_CN'
    return localeString;
  }
}
