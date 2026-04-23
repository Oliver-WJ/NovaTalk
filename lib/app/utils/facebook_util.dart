import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:novatalk/app/utils/common_utils.dart';

class FacebookSDKUtil {
  static const MethodChannel _channel = MethodChannel('FacebookSDKChannel');
  static const String m1 = "initialize";

  // 记录Facebook SDK是否已经初始化
  static bool facebookIsInitialized = false;
  static bool fireBaseIsInitialized = false;
  static String? _appId;
  static String? _token;

  static Future<void> fireBaseInitialize() async {
    if (fireBaseIsInitialized) {
      return;
    }
    try {
      FirebaseApp app = await Firebase.initializeApp();
      goPrint('Firebase init: ${app.name}');
      await FirebaseRemoteConfig.instance.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 2),
          minimumFetchInterval: Duration(seconds: 2),
        ),
      );
      fireBaseIsInitialized = true;
    } catch (e) {
      goPrint('Firebase init error : $e');
    }
  }

  /// 从远程配置获取Facebook SDK配置
  static Future<Map<String, String>?> _getConfig() async {
    try {
      final String facebookAppIdKey =
          "facebookId_${Platform.isAndroid ? "android" : "ios"}";
      final String facebookClientTokenKey =
          "facebookToken_${Platform.isAndroid ? "android" : "ios"}";

      final String facebookId = FirebaseRemoteConfig.instance.getString(
        facebookAppIdKey,
      );
      final String facebookToken = FirebaseRemoteConfig.instance.getString(
        facebookClientTokenKey,
      );
      // 验证配置是否有效
      if (facebookId.isEmpty || facebookToken.isEmpty) {
        return null;
      }
      return {'appId': facebookId, 'token': facebookToken};
    } catch (e) {
      goPrint('Facebook config error: $e');
      return null;
    }
  }

  /// 初始化Facebook SDK（自动获取配置）
  static Future<void> initializeWithRemoteConfig() async {
    final config = await _getConfig();
    if (config != null) {
      await initializeFacebookSDK(
        appId: config['appId']!,
        clientToken: config['token']!,
      );
    }
  }

  /// 初始化Facebook SDK
  /// [appId] Facebook应用ID
  /// [clientToken] Facebook客户端令牌
  static Future<void> initializeFacebookSDK({
    required String appId,
    required String clientToken,
  }) async {
    try {
      // 缓存配置信息
      _appId = appId;
      _token = clientToken;

      final result = await _channel.invokeMethod(m1, {
        'appId': appId,
        'token': clientToken,
      });

      facebookIsInitialized = true;
      goPrint('Facebook initialize success : $result');
    } on PlatformException catch (e) {
      goPrint('Facebook initialize error: ${e.message}');
      facebookIsInitialized = false;
      rethrow;
    }
  }

  /// 网络恢复后重新初始化（如果之前未成功初始化）
  static Future<void> retryIfNeed() async {
    if (!facebookIsInitialized) {
      // 如果有缓存配置，直接使用
      if (_appId != null && _token != null) {
        await initializeFacebookSDK(appId: _appId!, clientToken: _token!);
      } else {
        // 如果没有缓存配置，重新从远程获取
        await initializeWithRemoteConfig();
      }
    }
  }
}
