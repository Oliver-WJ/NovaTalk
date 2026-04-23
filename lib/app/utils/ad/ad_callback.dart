// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// import '../../configs/constans.dart';
// import 'ad_analytics.dart';
//
// class AdCallback {
//   final void Function(AdType type, {PlacementType? placement})? onAdShow;
//   final void Function(AdType type, {PlacementType? placement})? onAdOpened;
//   final void Function(AdType type, {PlacementType? placement})? onAdClosed;
//   final void Function(AdType type, AdError error, {PlacementType? placement})? onAdFailedToShow;
//   final void Function(AdType type, AdError error, {PlacementType? placement})? onAdFailedToLoad;
//   final void Function(AdType type, double value, String currency, {PlacementType? placement})? onAdRevenue;
//   final void Function(RewardItem reward, {PlacementType? placement})? onUserEarnedReward;
//
//   const AdCallback({
//     this.onAdShow,
//     this.onAdOpened,
//     this.onAdClosed,
//     this.onAdFailedToShow,
//     this.onAdFailedToLoad,
//     this.onAdRevenue,
//     this.onUserEarnedReward,
//   });
// }
//
// mixin AdEventHandler {
//   AdCallback? _callback;
//   final _analytics = AdAnalytics();
//
//   void setAdEventCallback(AdCallback callback) {
//     _callback = callback;
//   }
//
//   void handleAdShow(AdType type, {PlacementType? placement, required String adid}) {
//     _callback?.onAdShow?.call(type, placement: placement);
//     _analytics.trackAdShow(type, adid: adid, placement: placement);
//   }
//
//   void handleAdOpened(AdType type, {PlacementType? placement, required String adid}) {
//     _callback?.onAdOpened?.call(type, placement: placement);
//     _analytics.trackAdOpened(type, placement: placement, adid: adid);
//   }
//
//   void handleAdClosed(AdType type, {PlacementType? placement}) {
//     _callback?.onAdClosed?.call(type, placement: placement);
//     _analytics.trackAdClosed(type, placement: placement);
//   }
//
//   void handleAdFailedToShow(AdType type, AdError error, {PlacementType? placement, String? adid}) {
//     _callback?.onAdFailedToShow?.call(type, error, placement: placement);
//     _analytics.trackAdShowFailed(type, error, placement: placement, adid: adid ?? '');
//   }
//
//   void handleAdRevenue({
//     PlacementType? placement,
//     required AdType type,
//     required double value,
//     required String currency,
//     required String adId,
//   }) {
//     _callback?.onAdRevenue?.call(type, value, currency, placement: placement);
//     _analytics.trackAdRevenue(type: type, value: value, currency: currency, placement: placement, adid: adId);
//   }
//
//   void handleUserEarnedReward(RewardItem reward, {PlacementType? placement}) {
//     _callback?.onUserEarnedReward?.call(reward, placement: placement);
//     _analytics.trackRewardEarned(reward, placement: placement);
//   }
//
//   void handleAdFailedToLoad(AdType type, AdError error, {PlacementType? placement, String? adid}) {
//     _callback?.onAdFailedToLoad?.call(type, error, placement: placement);
//     _analytics.trackAdLoadFailed(type, error, placement: placement, adid: adid ?? '');
//   }
//
//   void handleAdLoadRequest(AdType type, {PlacementType? placement}) {
//     _analytics.trackAdLoadRequest(type, placement: placement);
//   }
//
//   void handleAdLoadSuccess(AdType type, {PlacementType? placement, required String adid}) {
//     _analytics.trackAdLoadSuccess(type, placement: placement, adid: adid);
//   }
// }
