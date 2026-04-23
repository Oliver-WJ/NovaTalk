import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:novatalk/app/configs/app_config.dart';
import 'package:novatalk/app/configs/app_theme.dart';
import 'package:novatalk/app/entities/role_entity.dart';
import 'package:novatalk/app/utils/api_svc.dart';
import 'package:novatalk/app/utils/app_user.dart';
import 'package:novatalk/app/utils/device_info.dart';
import 'package:novatalk/app/utils/storage_util.dart';
import 'package:novatalk/generated/locales.g.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../configs/constans.dart';
import '../routes/app_pages.dart';

(int, int) decimalToFraction(double value) {
  String s = value.toString();
  int digits = s.split('.')[1].length;

  int denominator = BigInt.from(10).pow(digits).toInt();
  int numerator = (value * denominator).round();

  int gcd(int a, int b) {
    while (b != 0) {
      int t = b;
      b = a % b;
      a = t;
    }
    return a;
  }

  int g = gcd(numerator, denominator);

  return (numerator ~/ g, denominator ~/ g);
}

String numberPart(String skuId) {
  return skuId.replaceAll(RegExp(r'[^0-9]'), '');
}

String numFixed(dynamic numF, {int position = 2}) {
  double num;
  if (numF is double) {
    num = numF;
  } else {
    num = double.parse(numF.toString());
  }
  var numString = Decimal.parse(num.toString()).toString();
  if ((numString.length - numString.lastIndexOf(".") - 1) < position) {
    return (num.toStringAsFixed(
      position,
    ).substring(0, numString.lastIndexOf(".") + position + 1).toString());
  } else {
    return (numString
        .substring(0, (numString.lastIndexOf(".") + position + 1))
        .toString());
  }
}

String formatTimestamp(int timestampInMilliseconds) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
    timestampInMilliseconds,
  );
  String year = dateTime.year.toString();
  String month = dateTime.month.toString().padLeft(2, '0'); // 保证两位数格式
  String day = dateTime.day.toString().padLeft(2, '0'); // 保证两位数格式

  return '$year-$month-$day';
}

double get statusBarHeight => MediaQuery.of(Get.context!).padding.top;

double get appbarHeight => (statusBarHeight + kToolbarHeight);

void goPrint(Object? object) {
  assert(() {
    print(object);
    return true;
  }());
}

mixin MxPageData<T> {
  static const int defaultPage = 1;
  int page = defaultPage;
  int pageSize = 15;
  final pageData = <T>[].obs;
  final isLoading = false.obs;

  Future onLoadMore() async {
    page++;
    try {
      isLoading.value = true;
      var data = await loadData();
      pageData.addAll(data);
    } catch (e) {
      page--;
      goPrint(e);
    }
    isLoading.value = false;
  }

  Future onRefresh() async {
    page = defaultPage;
    isLoading.value = true;
    pageData.assignAll(await loadData());
    isLoading.value = false;
    pageData.refresh();
  }

  Future<List<T>> loadData();

  void dispose() {
    pageData.close();
  }
}

T? $<T>({String? tag}) {
  try {
    return Get.find<T>(tag: tag);
  } catch (_) {}
  return null;
}

void toEmail() async {
  final version = await DeviceInfo.version();
  final device = await DeviceInfo.deviceId();
  final uid = AppUser.inst.user?.id;

  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: AppConfig.supportEmail, // 收件人
    query:
        "subject=Feedback&body=version: $version\ndevice: $device\nuid: $uid\nPlease input your problem:\n", // 设置默认主题和正文内容
  );

  launchUrl(emailUri);
  // launchUrl(Uri.parse("https://google.com"));
}

void toPrivacy() {
  launchUrl(Uri.parse(AppConfig.privacy));
}

void toTerms() {
  launchUrl(Uri.parse(AppConfig.terms));
}

///随机数
int randomNumber({int min = 0, int max = 100}) {
  final random = Random();
  return min + random.nextInt(max - min + 1);
}

String formatTime(int seconds) {
  int hours = seconds ~/ 3600;
  int minutes = (seconds % 3600) ~/ 60;
  int secs = seconds % 60;

  if (hours > 0) {
    return '$hours:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}s';
  } else if (minutes > 0) {
    return '$minutes:${secs.toString().padLeft(2, '0')}s';
  } else {
    return '${secs}s';
  }
}

mixin SubPacker {
  final subscriptions = <StreamSubscription>[];

  void cancelSubs() {
    for (var value in subscriptions) {
      value.cancel();
    }
    subscriptions.clear();
  }

  void addSub(StreamSubscription? sub) {
    if (null != sub) {
      subscriptions.add(sub);
    }
  }
}

Future<void> pushVip(VipFrom from) async {
  Get.toNamed(Routes.VIP, arguments: from);
}

Future<void> pushGem(ConsumeFrom from) async {
  Get.toNamed(Routes.GEM, arguments: from);
}

Future<T?>? pushPhone<T>({
  required int sessionId,
  required RoleRecords role,
  required bool showVideo,
  CallState callState = CallState.calling,
}) async {
  // 检查 Mic 权限 和 语音权限
  if (!await checkPermissions()) {
    showNoPermissionDialog();
    return null;
  }

  return Get.toNamed(
    Routes.CALL,
    arguments: {
      'sessionId': sessionId,
      'role': role,
      'callState': callState,
      'showVideo': showVideo,
    },
  );
}

/// 检查麦克风和语音识别权限，返回是否已授予所有权限
Future<bool> checkPermissions() async {
  try {
    // 先检查当前权限状态
    PermissionStatus micStatus = await Permission.microphone.status;
    PermissionStatus speechStatus = await Permission.speech.status;

    // 如果权限已经授予，直接返回 true
    if (micStatus.isGranted && speechStatus.isGranted) {
      return true;
    }

    // 如果权限被永久拒绝，直接返回 false
    if (micStatus.isPermanentlyDenied || speechStatus.isPermanentlyDenied) {
      goPrint('Permissions isPermanentlyDenied');
      return false;
    }

    // 请求权限
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.speech,
    ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);

    return allGranted;
  } catch (e) {
    return false;
  }
}

Future<void> showNoPermissionDialog() async {
  showTheme1Sheet(
    message: LocaleKeys.micphoneTips.tr,
    onConfirm: () async {
      await openAppSettings();
    },
  );
}

Future<T?>? offPhone<T>({
  required RoleRecords role,
  required bool showVideo,
  CallState callState = CallState.calling,
}) async {
  // 检查 Mic 权限 和 语音权限
  if (!await checkPermissions()) {
    showNoPermissionDialog();
    return null;
  }
  var seesion = await ApiSvc.addSession(role.id ?? ''); // 查会话
  final sessionId = seesion?.id;
  if (sessionId == null) {
    SmartDialog.showToast('sessionId is null');
    return null;
  }

  return Get.offNamed(
    Routes.CALL,
    arguments: {
      'sessionId': sessionId,
      'role': role,
      'callState': callState,
      'showVideo': showVideo,
    },
  );
}

Future<void> openStoreReview() async {
  if (Platform.isIOS) {
    const String id = AppConfig.appStoreId;
    final Uri url = Uri.parse(
      'https://apps.apple.com/app/id$id?action=write-review',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  } else if (Platform.isAndroid) {
    String pName = await DeviceInfo.packageName();
    final Uri url = Uri.parse(
      'https://play.google.com/store/apps/details?id=$pName',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}

class IntervalDo {
  DateTime? lastDate;
  Timer? lastTimer;

  //call---delay---call---delay
  void run({required Function() fun, int milliseconds = 0}) {
    DateTime now = DateTime.now();
    if (null == lastDate ||
        now.difference(lastDate ?? now).inMilliseconds > milliseconds) {
      lastDate = now;
      fun();
    }
  }

  //---delay----delay....---call  在delay milliseconds时连续的调用会被丢弃并重置delay的时间，delay后才会call
  void drop({required Function() fun, int milliseconds = 200}) {
    cancel();
    lastTimer = Timer(Duration(milliseconds: milliseconds), () {
      cancel();
      fun.call();
    });
  }

  void cancel() {
    lastTimer?.cancel();
    lastTimer = null;
  }
}

class Loader<T> {
  final state = LoadingState.idle.obs;
  T? data;

  void idle() {
    state.value = LoadingState.idle;
  }

  void loading() {
    state.value = LoadingState.loading;
  }

  void success([T? data]) {
    state.value = LoadingState.success;
    this.data = data;
  }

  void empty() {
    state.value = LoadingState.empty;
  }

  void error() {
    state.value = LoadingState.error;
  }

  bool get isIdle => state.value == LoadingState.idle;

  bool get isLoading => state.value == LoadingState.loading;

  bool get isSuccess => state.value == LoadingState.success;

  bool get isEmpty => state.value == LoadingState.empty;

  bool get isError => state.value == LoadingState.error;

  void close() {
    state.close();
  }
}

String formatTimeZoneOffset(Duration offset) {
  final hours = offset.inHours;
  final minutes = (offset.inMinutes % 60).abs();
  final sign = hours >= 0 ? '+' : '-';
  return '$sign${hours.abs().toString().padLeft(2, '0')}:'
      '${minutes.toString().padLeft(2, '0')}';
}

String formatVideoDuration(int seconds) {
  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final secs = seconds % 60;

  if (hours > 0) {
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  } else {
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

extension ExCompleter<T> on Completer<T> {
  void completeIfNotCompleted(T value) {
    if (!isCompleted) {
      complete(value);
    }
  }
}

extension ListKx<T> on List<T>? {
  T? get randomOrNull {
    if (this == null || this!.isEmpty) {
      return null;
    } else {
      return this![randomNumber(max: this!.length - 1)];
    }
  }

  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

extension ExImageStream on ImageStream {
  Future<ImageInfo> waitingResolve() {
    final Completer<ImageInfo> completer = Completer();
    late final ImageStreamListener listener;
    listener = ImageStreamListener((ImageInfo info, bool synchronousCall) {
      removeListener(listener);
      completer.completeIfNotCompleted(info);
    });
    addListener(listener);
    return completer.future;
  }
}

class EdgeInsetsEx {
  static EdgeInsets atWill({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? horizontal,
    double? vertical,
  }) {
    left ??= horizontal ?? 0;
    right ??= horizontal ?? 0;
    top ??= vertical ?? 0;
    bottom ??= vertical ?? 0;
    return EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
  }
}
