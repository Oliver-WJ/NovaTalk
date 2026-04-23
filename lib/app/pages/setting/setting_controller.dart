import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:novatalk/app/utils/api_svc.dart';
import 'package:novatalk/app/utils/app_user.dart';
import 'package:novatalk/app/utils/common_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../generated/locales.g.dart';
import '../../configs/constans.dart';
import '../../routes/app_pages.dart';
import 'package:path/path.dart' as path;

import '../../utils/storage_util.dart';

class SettingController extends GetxController {
  //TODO: Implement SettingController

  final count = 0.obs;

  final chatBgImagePath = "".obs;

  @override
  void onInit() {
    super.onInit();
    chatBgImagePath.value = StorageUtils.chatBgImagePath;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  Future<void> changeNickName(String newNickname) async {
    SmartDialog.showLoading();
    await AppUser.inst.updateUser(newNickname);
    SmartDialog.dismiss();
  }

  Future<void> autoTranslation(bool value) async {
    if (AppUser.inst.isVip.value) {
      SmartDialog.showLoading();
      await ApiSvc.updateEventParams(autoTranslate: value);
      await AppUser.inst.refreshUser();
      SmartDialog.dismiss();
    } else {
      pushVip(VipFrom.trans);
    }
  }

  Future<void> changeChatBackground() async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      Get.context!,
      pickerConfig: const AssetPickerConfig(maxAssets: 1, requestType: RequestType.image),
    );
    if (result != null && result.isNotEmpty) {
      final iamge = result.first;
      final pickedFile = await iamge.file;
      if (pickedFile != null) {
        final directory = await getApplicationDocumentsDirectory();
        final fileName = path.basename(pickedFile.path);
        final cachedImagePath = path.join(directory.path, fileName);
        final File cachedImage = await File(pickedFile.path).copy(cachedImagePath);
        StorageUtils.chatBgImagePath = cachedImage.path;
        chatBgImagePath.value = cachedImage.path;
        SmartDialog.showNotify(
          msg: LocaleKeys.successful.tr,
          notifyType: NotifyType.success,
        );
      }
    }
  }

  void resetChatBackground() {
    StorageUtils.chatBgImagePath = '';
    chatBgImagePath.value = '';
    SmartDialog.showNotify(
      msg: LocaleKeys.completed.tr,
      notifyType: NotifyType.success,
    );
  }
}
