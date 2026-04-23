import 'dart:io';
import 'package:novatalk/app/pages/undr/ctls/purchase_controller.dart';
import 'package:novatalk/app/pages/undr/ctls/undress_page_controller.dart';
import 'package:novatalk/app/utils/api_svc.dart';
import 'package:novatalk/app/utils/app_user.dart';
import 'package:novatalk/app/widgets/common_widget.dart';
import 'package:novatalk/generated/locales.g.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../../configs/app_config.dart';
import '../../../entities/und_result_bean.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/log/log_event.dart';
import '../../../utils/select_image_util.dart';


class UndrVideoPageController extends GetxController with MxUndressMedia {
  //用户选择的图片
  final userSelectedImage = RxnString();
  final showPrompt = false.obs;
  final undressAnother = false.obs;
  final finishGenerate = false.obs;
  final undressing = false.obs;

  final undressHistory = {}.obs;

  var customPromptController = TextEditingController();

  final videoController = Rx<VideoPlayerController?>(null);
  final videoLoading = true.obs;
  String lastGenVideoUrl = "";

  var customPromptFocusNode = FocusNode();

  var scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();

    initVideoController();
    isGeneraImg = false;
    customPromptFocusNode.addListener(() {
      if (customPromptFocusNode.hasFocus) {
        Future.delayed(
            200.milliseconds, () async => await scrollController.scrollToBottom());
      }
    });
  }

  Future<void> initVideoController({String? url}) async {
    lastGenVideoUrl = url ?? AppConfig.undressBeforeVideo;
    videoLoading.value = true;
    var file = await DefaultCacheManager().getSingleFile(lastGenVideoUrl);
    await videoControllerDispose();
    VideoPlayerController videoController;
    videoController = VideoPlayerController.file(file);
    this.videoController.value = videoController;
    await videoController.initialize();
    videoController.play();
    videoController.setLooping(true);
    videoController.addListener(() {
      videoLoading.value = videoController.value.position.inMilliseconds < 100;
    });
  }

  videoControllerDispose() async {
    await videoController.value?.dispose();
    videoController.value = null;
  }

  @override
  void onClose() {
    super.onClose();
    customPromptFocusNode.dispose();
    videoControllerDispose();
  }

  //选择照片
  Future<void> selectImage() async {
    // AnalyticsUtils().logEvent(AnalyticsUtils.cunupload);
    SmartDialog.showLoading();
    String? result = await SelectImageUtil.selectImage(crop: false);
    SmartDialog.dismiss();
    if (result != null) {
      userSelectedImage.value = result;
      //上传图片后展示选择模式
      showPrompt.value = true;
      finishGenerate.value = false;
    } else {}
  }

  void undressVideo() {
    // AnalyticsUtils().logEvent(AnalyticsUtils.cundrchar);
    if (finishGenerate.value) {
      userSelectedImage.value = undressHistory['lnk'];
      undressAnother.value = true;
      return;
    }
    if (showPrompt.value) {
      startUndressVideo();
      return;
    }

    showPrompt.value = true;
    // userSelectedImage.value = args.coverUrl;
  }

  Future<void> startUndressVideo() async {
    SmartDialog.showLoading();
    var customPrompt = customPromptController.text;
    if (customPrompt.isEmpty) {
      SmartDialog.showToast(LocaleKeys.promptHits.tr);
      SmartDialog.dismiss();
      return;
    }
    final enText =
        await ApiSvc.translateText(customPrompt,sl:  Get.deviceLocale?.languageCode ?? 'en');
    if (enText == null || enText.isEmpty) {
      SmartDialog.showToast(LocaleKeys.promptHits.tr);
      SmartDialog.dismiss();
      return;
    }
    await AppUser.inst.refreshUser();
    SmartDialog.dismiss();
    var undressCount = AppUser.inst.createVideo;
    if (undressCount <= 0) {
      Get.toNamed(Routes.PURCHASE, arguments: PurchaseArgs(isPayPhotoNum: false));
      return;
    }
    undressing.value = true;
    try {
      var imgFile = File(userSelectedImage.value!);
      if (!await imgFile.exists()) {
        SmartDialog.showToast(LocaleKeys.laterTry.tr);
        undressing.value = false;
        return;
      }
      var formData = {
        'file': await dio.MultipartFile.fromFile(
          await compressImageAndConvert(imgFile) ?? "",
          filename: 'img_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
        'style': enText,
        'fileMd5': await md5File(imgFile),
      };
      UndResultBean? result = await undressOperation(formData);
      if (result != null) {
        String? uid = result.data?.uid;
        if (uid?.contains('http')==true) {
          genSuccess(uid!);
          return;
        }
        var url = await waitingGenerateFinish(result.data!);
        if (url.isVoid) {
          SmartDialog.showToast(LocaleKeys.genFailed);
          undressing.value = false;
          return;
        }
        await genSuccess(url!);
        //刷新余额
        AppUser.inst.refreshUser();
      } else {
        SmartDialog.showToast(LocaleKeys.genFailed);
      }
    } catch (_) {
      SmartDialog.showToast(LocaleKeys.genFailed);
    }
    undressing.value = false;
  }

  Future<void> genSuccess(String url) async {
    await initVideoController(url: url);
    customPromptController.text = '';
    undressing.value = false;
    finishGenerate.value = true;
    undressAnother.value = true;
    showPrompt.value = false;
    logEvent('un_gen_suc');
  }

  void resetState() {
    userSelectedImage.value = null;
    showPrompt.value = false;
    undressAnother.value = false;
    initVideoController();
  }
}
