// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:novatalk/app/utils/log/svr_log_event.dart';
//
// import '../../configs/constans.dart';
// import '../log/log_event.dart';
//
// class AdAnalytics {
//
//   // 广告收入统计
//   void trackAdRevenue({
//     PlacementType? placement,
//     required AdType type,
//     required double value,
//     required String currency,
//     required String adid,
//   }) {
//     logEvent('ad_income', parameters: {"value": value.toString(), "currency": currency});
//     SvrLogEvent().logAdEvent(
//       adId: adid,
//       placement: placement?.name ?? '',
//       adType: type.name,
//       value: value,
//       currency: currency,
//     );
//   }
//
//   // 激励广告奖励统计
//   void trackRewardEarned(RewardItem reward, {PlacementType? placement}) {
//     // logEvent('ad_reward_${placement?.name}', parameters: {"parameters": reward.amount.toString()});
//   }
//
//   // 广告开始展示统计
//   void trackAdShow(AdType type, {PlacementType? placement, required String adid}) {
//     logEvent('ad_onshow', parameters: {"value": placement?.name ?? '', "code": adid});
//     SvrLogEvent().logAdEvent(adId: adid, placement: placement?.name ?? '', adType: type.name);
//   }
//
//   // 广告已经展示统计
//   void trackAdOpened(AdType type, {PlacementType? placement, required String adid}) {
//     logEvent('ad_factshow', parameters: {"value": placement?.name ?? '', "code": adid});
//   }
//
//   // 广告展示失败统计
//   void trackAdShowFailed(AdType type, AdError error, {PlacementType? placement, required String adid}) {
//     logEvent('failtoshow', parameters: {
//       "value": placement?.name ?? '',
//       "code": "${error.code}",
//       "msg": error.message,
//       "type": type.name,
//       "adid": adid,
//     });
//   }
//
//   // 广告关闭统计
//   void trackAdClosed(AdType type, {PlacementType? placement}) {
//   }
//
//   // 广告加载请求统计
//   void trackAdLoadRequest(AdType type, {PlacementType? placement}) {
//     logEvent('adreq', parameters: {"value": placement?.name ?? ''});
//   }
//
//   // 广告加载成功统计
//   void trackAdLoadSuccess(AdType type, {PlacementType? placement, required String adid}) {
//     logEvent('adreq_succ', parameters: {"value": placement?.name ?? '', "code": adid});
//   }
//
//   // 广告加载失败统计
//   void trackAdLoadFailed(AdType type, AdError error, {PlacementType? placement, required String adid}) {
//     logEvent('failadreq', parameters: {
//       "value": placement?.name ?? '',
//       "code": "${error.code}",
//       "msg": error.message,
//       "type": type.name,
//       "ad": adid,
//     });
//   }
// }
