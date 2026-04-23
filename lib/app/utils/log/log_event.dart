import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:novatalk/app/utils/common_utils.dart';
import 'package:novatalk/app/utils/log/svr_log_event.dart';

Future<void> logEvent(
  String name, {
  Map<String, Object>? parameters,
  List<String>? strategies,
}) async {
  try {
    SvrLogEvent().logCustomEvent(name: name, params: parameters ?? {});
    FirebaseAnalytics.instance.logEvent(name: name, parameters: parameters);
  } catch (e) {
    goPrint('log error: $e');
  }
}
