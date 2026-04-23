// import 'dart:async';
//
// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:novatalk/app/configs/app_config.dart';
// import 'package:novatalk/app/widgets/common_widget.dart';
//
// import '../../configs/constans.dart';
// import 'ad_cache_config.dart';
// import 'ad_callback.dart';
// import 'ad_config.dart';
// import 'ad_loader.dart';
//
// class ADNative with AdEventHandler {
//   NativeAd? _nativeAd;
//   bool _isLoadingAd = false;
//   DateTime? _nativeAdLoadTime;
//   Timer? _refreshTimer;
//   LoadAdError? _lastLoadError;
//   final adNativeLoaded = false.obs;
//
//   /// 检查广告是否已过期
//   bool get isAdExpired {
//     return AdCacheConfig().isAdExpired(AdType.native, _nativeAdLoadTime);
//   }
//
//   /// 检查广告是否可用
//   bool get isAdAvailable {
//     return _nativeAd != null && !isAdExpired;
//   }
//
//   /// 设置广告刷新定时器
//   void _setupRefreshTimer() {
//     _refreshTimer?.cancel();
//     if (_nativeAdLoadTime != null) {
//       const refreshTime = Duration(minutes: 40);
//       final now = DateTime.now();
//       final timeSinceLoad = now.difference(_nativeAdLoadTime!);
//       if (timeSinceLoad < refreshTime) {
//         final timeUntilRefresh = refreshTime - timeSinceLoad;
//         _refreshTimer = Timer(timeUntilRefresh, () {
//           if (!_isLoadingAd) {
//             loadAd(placement: PlacementType.homelist);
//           }
//         });
//       } else {
//         loadAd(placement: PlacementType.homelist);
//       }
//     }
//   }
//
//   /// 加载原生广告
//   Future<void> loadAd({required PlacementType placement}) async {
//     if (isAdAvailable) {
//       return;
//     }
//
//     if (_isLoadingAd) {
//       return;
//     }
//
//     try {
//       _isLoadingAd = true;
//       handleAdLoadRequest(AdType.native, placement: placement);
//
//       final completer = Completer();
//       String nativeAdId = AppConfig.nativeDefaultAdId;
//       if (!kReleaseMode) {
//         nativeAdId = AppConfig.nativeTestAdId;
//       }
//       try {
//         final adId = FirebaseRemoteConfig.instance.getString("adId");
//         if (!adId.isVoid) {
//           nativeAdId = adId;
//         }
//       } catch (_) {}
//       AdLoadResult result = await AdLoader().loadAd(placement, [
//         AdData(type: 'native', id: nativeAdId, level: 1, source: "admob"),
//       ]);
//       _lastLoadError = result.error;
//
//       if (result.ad != null) {
//         _nativeAd = result.ad as NativeAd;
//         _nativeAdLoadTime = DateTime.now();
//         handleAdLoadSuccess(
//           AdType.native,
//           placement: placement,
//           adid: _nativeAd!.adUnitId,
//         );
//         _setupRefreshTimer();
//         completer.complete(true);
//         adNativeLoaded.value = true;
//       } else {
//         handleAdFailedToLoad(
//           AdType.native,
//           _lastLoadError ?? AdError(5, '', 'timeout'),
//           placement: placement,
//         );
//         completer.complete();
//       }
//
//       return await completer.future;
//     } catch (_) {
//     } finally {
//       _isLoadingAd = false;
//     }
//   }
//
//   /// 获取当前加载的原生广告
//   NativeAd? get nativeAd {
//     if (_nativeAd != null) {
//       handleAdShow(
//         AdType.native,
//         placement: PlacementType.homelist,
//         adid: _nativeAd!.adUnitId,
//       );
//     }
//     return _nativeAd;
//   }
//
//   /// 释放广告资源
//   Future<void> dispose() async {
//     _refreshTimer?.cancel();
//     await _nativeAd?.dispose();
//     _nativeAd = null;
//     _isLoadingAd = false;
//   }
// }
