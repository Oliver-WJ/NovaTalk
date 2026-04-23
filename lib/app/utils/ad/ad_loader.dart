// import 'dart:async';
//
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:novatalk/app/utils/app_user.dart';
// import 'package:novatalk/app/utils/log/svr_log_event.dart';
//
// import '../../configs/constans.dart';
// import '../log/log_event.dart';
// import 'ad_callback.dart';
// import 'ad_config.dart';
// import 'ad_native.dart';
//
// class AdLoader {
//   static final AdLoader _instance = AdLoader._internal();
//   factory AdLoader() => _instance;
//   AdLoader._internal() {
//     _nativeAdUtil.setAdEventCallback(adEventCallback);
//   }
//   static const Duration timeout = Duration(seconds: 30);
//
//   // 原生广告管理
//   final ADNative _nativeAdUtil = ADNative();
//   ADNative get nativeAdUtil => _nativeAdUtil;
//   NativeAd? get nativeAd => _nativeAdUtil.nativeAd;
//   // 广告事件回调
//   AdCallback adEventCallback = const AdCallback();
//
//   // 原生广告
//   Future<void> loadNativeAd({required PlacementType placement}) async {
//     if (AppUser.inst.isVip.value) {
//       return;
//     }
//     return await _nativeAdUtil.loadAd(placement: placement);
//   }
//
//   Future<AdLoadResult> loadAd(
//     PlacementType placement,
//     List<AdData> adList,
//   ) async {
//     LoadAdError? lastError;
//     for (final ad in adList) {
//       final adUnitId = ad.id;
//       if (adUnitId == null || adUnitId.isEmpty) continue;
//
//       final type = _resolveAdType(ad); // 从 AdData 解析类型
//
//       try {
//         final result = await _loadByType(placement, type, adUnitId);
//         if (result.ad != null) {
//           return result;
//         }
//         lastError = result.error;
//       } catch (e) {
//         continue;
//       }
//     }
//     return AdLoadResult(error: lastError);
//   }
//
//   Future<AdLoadResult> _loadByType(
//     PlacementType placement,
//     AdType type,
//     String adUnitId,
//   ) async {
//     return await _loadNativeAd(adUnitId);
//   }
//
//   AdType _resolveAdType(AdData data) {
//     return AdType.native;
//     // switch (data.type?.toLowerCase()) {
//     //   case 'open':
//     //     return AdType.open;
//     //   case 'rewarded':
//     //     return AdType.rewarded;
//     //   case 'interstitial':
//     //     return AdType.interstitial;
//     //   case 'native':
//     //     return AdType.native;
//     //   default:
//     //     return AdType.open;
//     // }
//   }
//
//   Future<AdLoadResult> _loadNativeAd(String adUnitId) async {
//     final completer = Completer<AdLoadResult>();
//     var ad = NativeAd(
//       adUnitId: adUnitId,
//       factoryId: 'googleAdFactory',
//       request: const AdRequest(),
//       listener: NativeAdListener(
//         onAdLoaded: (ad) {
//           completer.complete(AdLoadResult(ad: ad as NativeAd));
//         },
//         onAdFailedToLoad: (ad, error) {
//           ad.dispose();
//           completer.complete(AdLoadResult(error: error));
//         },
//         onAdImpression: (ad) {
//           logEvent(
//             'ad_factshow',
//             parameters: {"value": PlacementType.homelist.name},
//           );
//         },
//         onAdClicked: (ad) {},
//         onAdClosed: (ad) {},
//         onAdOpened: (ad) {},
//         onPaidEvent: (ad, valueMicros, precision, currencyCode) {
//           SvrLogEvent().logAdEvent(
//             adId: ad.adUnitId,
//             placement: PlacementType.homelist.name,
//             adType: AdType.native.name,
//             value: valueMicros,
//             currency: currencyCode,
//           );
//         },
//       ),
//     );
//
//     await ad.load();
//
//     return await completer.future;
//   }
// }
