import 'package:get/get.dart';
import 'package:novatalk/app/configs/app_theme.dart';
import 'package:novatalk/app/pages/vip/vip_view.dart';
import 'package:novatalk/app/utils/app_user.dart';
import 'package:novatalk/app/utils/storage_util.dart';
import 'package:novatalk/app/widgets/common_widget.dart';

import '../../generated/locales.g.dart';
import '../configs/constans.dart';
import 'common_utils.dart';

class TransTool {
  static final TransTool _instance = TransTool._internal();

  factory TransTool() => _instance;

  TransTool._internal();

  int _clickCount = 0; // 点击次数
  DateTime? _firstClickTime; // 第一次点击的时间

  bool shouldShowDialog() {
    final now = DateTime.now();

    if (_firstClickTime == null || now.difference(_firstClickTime!).inMinutes > 1) {
      // 超过1分钟，重置计数器
      _firstClickTime = now;
      _clickCount = 1;
      return false;
    }

    _clickCount += 1;

    if (_clickCount >= 3) {
      _clickCount = 0; // 重置计数
      return true;
    }

    return false;
  }

  Future<void> handleTranslationClick() async {
    final hasShownDialog = StorageUtils.hasShownTranslationDialog;

    if (shouldShowDialog() && !hasShownDialog && !AppUser.inst.isVip.value) {
      // 弹出提示弹窗
      showTranslationDialog();

      // 记录弹窗已显示
      StorageUtils.hasShownTranslationDialog = true;
    }
  }

  void showTranslationDialog() {
    showTheme1Sheet(
      message: LocaleKeys.autoTrans,
      onConfirm: () async {
        Get.closeBottomSheet();
        pushVip(VipFrom.trans);
      },
    );
  }
}
