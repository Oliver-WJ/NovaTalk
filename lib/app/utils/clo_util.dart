import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:novatalk/app/configs/app_config.dart';
import 'package:novatalk/app/utils/common_utils.dart';
import 'package:novatalk/app/utils/storage_util.dart';

import 'device_info.dart';
import 'facebook_util.dart';
import 'log/log_event.dart';

class CloUtil {
  static const MethodChannel cardUtils = MethodChannel('isHavingCard');
  static const String m = "havCard";

  static bool? _isCloB;

  static bool get isCloB {
    return true;
    if (_isCloB != null) {
      return _isCloB!;
    }
    _isCloB = appStore.read(StorageUtils.keyCloUtil) ?? false;
    return _isCloB!;
  }

  static set isCloB(bool value) {
    _isCloB = value;
    appStore.write(StorageUtils.keyCloUtil, value);
  }

  static Future<void> request() async {
    if (isAppDebug) {
      isCloB = true;
      return;
    }
    try {
      if (Platform.isIOS) {
        await requestIos();
      } else if (Platform.isAndroid) {
        // await requestAndroid();
      }
      var shield = await isShield();
      isCloB = isCloB && !shield;
      if (isCloB) {
        logEvent("home_yes");
      }
    } catch (e) {
      goPrint('error: ${e.toString()}');
    }
  }

  static Future<void> requestIos() async {
    final version = await DeviceInfo.version();
    // final deviceId = await DeviceInfo.deviceId(isOrigin: true);
    // final idfa = await DeviceInfo.getIdfa();
    final packageName = await DeviceInfo.packageName();

    final Map<String, dynamic> body = {
      'mustache': packageName,
      'proctor': 'patrice',
      'thatd': version,
      'dimple': DateTime.now().millisecondsSinceEpoch,
    };

    final GetConnect client = GetConnect(timeout: const Duration(seconds: 60));

    final res = await client.post('https://during.anytalkweb.com/wad/crux/laurel', body);

    if (res.isOk) {
      isCloB = (res.body == 'seething');
    } else {
      isCloB = false;
    }
  }

  // static Future<void> requestAndroid() async {
  //   final version = await DeviceInfo.version();
  //   // final deviceId = await DeviceInfo.deviceId(isOrigin: true);
  //   // final idfa = await DeviceInfo.getIdfa();
  //   final packageName = await DeviceInfo.packageName();
  //
  //   final Map<String, dynamic> body = {
  //     'bayesian': packageName,
  //     'weasel': 'dial',
  //     'navigate': version,
  //     'introit': DateTime.now().millisecondsSinceEpoch,
  //   };
  //   final GetConnect client = GetConnect(timeout: const Duration(seconds: 60));
  //
  //   const url = 'https://lionel.lunamateapp.com/cash/conifer/labile';
  //
  //   final res = await client.post(url, body);
  //
  //   if (res.isOk) {
  //     isCloB = (res.body == 'skeptic');
  //   } else {
  //     isCloB = false;
  //   }
  // }


  static Future<bool> isShield() async {
    await FacebookSDKUtil.fireBaseInitialize();
    await FirebaseRemoteConfig.instance.fetchAndActivate();
    var localAllows = FirebaseRemoteConfig.instance.getString("authorizations");
    final deviceId = await DeviceInfo.deviceId();
    if (localAllows.contains(deviceId)) {
      return false;
    }
    var cloak = FirebaseRemoteConfig.instance.getString("switch");
    if (cloak == "false") {
      /// 大开关 不进入home
      logEvent("home_no", parameters: {"reason": "fireb"});
      return true;
    }
    var buyS = FirebaseRemoteConfig.instance.getString("switch_two");
    if (buyS == "false") {
      ///不开启屏蔽
      return false;
    }
    var isVpn = false;
    var isSimulator = false;
    var hasSim = false;

    try {
      await Future.wait([
        () async {
          //判断vpn
          var listC = await Connectivity().checkConnectivity();
          if (listC.contains(ConnectivityResult.vpn) ||
              listC.contains(ConnectivityResult.other)) {
            //开启了vpn
            isVpn = true;
            logEvent("home_no", parameters: {"reason": "vpn"});
          }
        }(),
        () async {
          //判断是否模拟器
          var iosInfo = await DeviceInfoPlugin().iosInfo;
          if (iosInfo.isPhysicalDevice == false) {
            isSimulator = true;
            logEvent("home_no", parameters: {"reason": "simulator"});
          }
        }(),
        () async {
          //判断是否有sim卡
          hasSim = await cardUtils.invokeMethod(m);
          if (!hasSim) {
            logEvent("home_no", parameters: {"reason": "no_sim"});
          }
        }()
      ]).timeout(8.seconds);
    } catch (_) {
      return true;
    }
    if (isVpn || isSimulator || !hasSim) {
      //不进入
      return true;
    }
    return false;
  }
}
