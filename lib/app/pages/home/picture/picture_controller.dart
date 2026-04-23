import 'package:novatalk/app/utils/api_svc.dart';
import 'package:novatalk/app/widgets/common_widget.dart';
import 'package:novatalk/generated/locales.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../../../configs/constans.dart';
import '../../../entities/api_response.dart';
import '../../../entities/create_style_bean.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/common_utils.dart';

class PictureController extends GetxController {
  final scrollController = ScrollController();
  final styleList = <CreateStyleBean>[].obs;
  final prompt = ''.obs;
  final initPrompt = ''.obs;
  final count = 1.obs;
  final ratio = '1:1'.obs;
  final generating = false.obs;
  int price = 20;
  CreateStyleBean? selectedStyle;

  final TextEditingController promptTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    ApiSvc.getCreationStyleOptions().then((value) {
      styleList.value = value;
      selectedStyle = styleList.firstWhere((v) => v.styleType == 0);
    });
    getPresetPrompt().then((v) {
      initPrompt.value = v;
    });
  }

  Future<String> getPresetPrompt() async {
    final prompt = await ApiSvc.getPresetPrompt();
    return prompt?.prompt ?? "";
  }

  Future<void> aiWrite() async {
    SmartDialog.showLoading();
    final prompt = await getPresetPrompt();
    SmartDialog.dismiss();
    promptTextController.text = prompt;
  }

  void clearPrompt() {
    promptTextController.clear();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void selectStyle(CreateStyleBean style) {
    selectedStyle = style;
    styleList.refresh();
  }

  Future<void> create() async {
    if (selectedStyle == null) {
      return;
    }
    SmartDialog.showLoading(clickMaskDismiss: true);
    final result = await ApiSvc.genAiPhoto(
      styleId: selectedStyle!.id!,
      imgCount: count.value,
      describeImg: promptTextController.text.isVoid
          ? initPrompt.value
          : promptTextController.text,
      imageRatio: ratio.value,
    );
    SmartDialog.dismiss();
    if (result == null || result.success == false) {
      if (result?.code == insufficientBalance) {
        pushGem(ConsumeFrom.home);
        return;
      }
      SmartDialog.showToast(result?.message ?? LocaleKeys.generateFailed.tr);
      return;
    }
    generating.value=true;
    final taskId = "${result.data}";
    if (taskId.isVoid == true) return;
   final success = await loopSelectGen(taskId);
    generating.value=false;
    if(success){
      Get.toNamed(Routes.CREATIONS);
    }
  }

  Future<bool> loopSelectGen(String id) async {
    try {
      final result = await ApiSvc.getGenImg(id);
      if (!result) {
        await Future.delayed(5.seconds);
        return loopSelectGen(id);
      }
      return true;
    } catch (e) {
      SmartDialog.showToast(e.toString());
      return false;
    }
  }
}
