import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:novatalk/app/configs/app_config.dart';
import 'package:novatalk/app/entities/api_response.dart';
import 'package:novatalk/app/entities/und_history_bean.dart';
import 'package:novatalk/app/entities/und_style_bean.dart';
import 'package:novatalk/app/entities/und_video_result_bean.dart';
import 'package:novatalk/generated/locales.g.dart';
import 'package:flutter/scheduler.dart';
import 'package:image/image.dart' as img;
import 'package:crypto/crypto.dart' as crypto;
import 'package:novatalk/app/pages/undr/ctls/purchase_controller.dart';
import 'package:novatalk/app/utils/api_svc.dart';
import 'package:novatalk/app/utils/app_user.dart';
import 'package:novatalk/app/widgets/common_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:path_provider/path_provider.dart';
import '../../../deploy/app_deploy.dart';
import '../../../entities/und_img_result_bean.dart';
import '../../../entities/und_result_bean.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/cryptography.dart';
import '../../../utils/log/log_event.dart';
import '../../../utils/select_image_util.dart';

class UndressPageArgs {
  //角色ID
  final String? characterId;
  final String? coverUrl;
  final bool? homeReuse;

  UndressPageArgs({this.characterId, this.coverUrl, this.homeReuse = false});

  bool isUnderdressRole() => !characterId.isVoid;

  bool get isHomeReuse => homeReuse == true;
}

class UndressPageController extends GetxController with MxUndressMedia {
  /// 显示风格
  final showStyle = false.obs;

  ///已经生产过
  final finishGenerate = false.obs;

  /// 角色已经生成undress 开始生产其他的
  final undressAnother = false.obs;

  ///生产中
  final undressing = false.obs;

  final undressHistory = Rx<UndHistoryBean?>(null);

  //用户选择的图片
  final userSelectedImage = RxnString();

  //选中的风格
  var undressSelectedIndex = 0.obs;

  //风格
  final templateConfigList = <UndStyleBean>[].obs;

  late UndressPageArgs args = Get.arguments as UndressPageArgs;

  final customPromptController = TextEditingController();
  final customPrompt = "".obs;
  late bool isUnderdressRole;

  @override
  onInit() {
    super.onInit();
    getUndressStyle();
    getHistory();
    isUnderdressRole = args.isUnderdressRole();
    isGeneraImg = true;
  }

  //获取配置信息
  Future<void> getUndressStyle() async {
    if (args.homeReuse == false) {
      SmartDialog.showLoading();
    }
    var result = await ApiSvc.getUndStyles();
    if (args.homeReuse == false) {
      SmartDialog.dismiss();
    }
    templateConfigList.value = result;
  }

  //选择模式
  void selectUndressMode(int index) {
    undressSelectedIndex.value = index;
    resetCustomPrompt();
  }

  void resetCustomPrompt() {
    customPromptController.text = "";
    customPrompt.value = "";
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
      showStyle.value = true;
      finishGenerate.value = false;
      isUnderdressRole = false;
    } else {}
  }

  //操作当前角色
  void undressCharacter() {
    // AnalyticsUtils().logEvent(AnalyticsUtils.cundrchar);
    if (finishGenerate.value) {
      /// 这已经生成过了 直接那结果
      userSelectedImage.value = (undressHistory.value?.url).val;
      undressAnother.value = true;
      return;
    }
    if (showStyle.value) {
      startUndress(character: isUnderdressRole);
      return;
    }

    showStyle.value = true;
    userSelectedImage.value = args.coverUrl;
  }

  //检查用户信息，开始脱衣操作
  Future<void> startUndress({bool character = false}) async {
    if (templateConfigList.isEmpty) {
      SmartDialog.showToast(LocaleKeys.occurredTips);
      return;
    }
    //获取最新的余额信息
    SmartDialog.showLoading();
    await AppUser.inst.refreshUser();
    SmartDialog.dismiss();
    // 检查余额
    if (AppUser.inst.createImg < 1) {
      Get.toNamed(
        Routes.PURCHASE,
        arguments: PurchaseArgs(isPayPhotoNum: true),
      );
      return;
    }
    startUndressRequest(undressRole: character);
  }

  //请求后端脱衣接口
  Future<void> startUndressRequest({bool undressRole = false}) async {
    undressing.value = true;
    var style = customPrompt.value.isVoid
        ? templateConfigList[undressSelectedIndex.value].style
        : customPrompt.value;
    Map<String, dynamic>? formData;
    if (undressRole) {
      formData = {'style': style, 'characterId': args.characterId};
    } else {
      var imgFile = File(userSelectedImage.value!);
      if (!await imgFile.exists()) {
        SmartDialog.showToast(LocaleKeys.occurredTips.tr);
        return;
      }
      SmartDialog.showLoading();
      try {
        formData = {
          'file': await dio.MultipartFile.fromFile(
            await compressImageAndConvert(imgFile) ?? "",
            filename: 'img_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
          'style': style,
        };
      } catch (_) {}
      SmartDialog.dismiss();
    }
    if (formData == null) {
      SmartDialog.showToast(LocaleKeys.generate1.tr);
      undressing.value = false;
      return;
    }
    UndResultBean? result = await undressOperation(formData);
    if (result != null) {
      var uid = result.data?.uid;
      if (uid?.contains('http') == true) {
        userSelectedImage.value = uid;
      } else {
        userSelectedImage.value = await waitingGenerateFinish(result.data!);
      }
      if (userSelectedImage.value.isVoid) {
        SmartDialog.showToast(LocaleKeys.generate2.tr);
        undressing.value = false;
        return;
      }
      DefaultCacheManager().getSingleFile(userSelectedImage.value!);
      //刷新余额
      AppUser.inst.refreshUser();
      finishGenerate.value = true;
      undressAnother.value = true;
      showStyle.value = false;
      if (undressRole) {
        if (undressHistory.value == null) {
          undressHistory.value = UndHistoryBean();
        }
        undressHistory.value!.url = userSelectedImage.value;
      }
      logEvent('un_gen_suc');
    } else {
      SmartDialog.showToast(LocaleKeys.generate2.tr);
    }
    undressing.value = false;
  }

  @override
  void onClose() {
    super.onClose();
    customPromptController.dispose();
  }

  void setCustomPrompt() {
    undressSelectedIndex.value = customPromptController.text.isVoid ? 0 : -1;
    customPrompt.value = customPromptController.text;
  }

  Future<void> getHistory() async {
    var result = await ApiSvc.getUndressHistory(roleId: args.characterId);
    if (result?.isNotEmpty == true) {
      finishGenerate.value = true;
      undressHistory.value = result![0];
    }
  }

  void resetState() {
    userSelectedImage.value = null;
    showStyle.value = false;
    undressAnother.value = false;
  }
}

mixin MxUndressMedia {
  static const int maxRetry = 6;
  bool _isGeneraImg = false;

  set isGeneraImg(bool value) {
    _isGeneraImg = value;
  }

  bool get isGeneraImg => _isGeneraImg;

  Future<UndResultBean?> undressOperation(Map<String, dynamic> formData) async {
    return await ApiSvc.undressOperation(
      formData: formData,
      url: isGeneraImg ? AppDeploy.undressImg : AppDeploy.undressVideo,
    );
  }

  static int fibonacci(int n) {
    if (n <= 1) return n;
    int a = 0;
    int b = 1;
    for (int i = 2; i <= n; i++) {
      int temp = a + b;
      a = b;
      b = temp;
    }
    return b;
  }

  Future<String?> waitingGenerateFinish(
    UndResultData result, {
    int currentRetry = 1,
    bool first = true,
  }) async {
    Future<String?> retry() async {
      if (currentRetry <= maxRetry) {
        return await waitingGenerateFinish(
          result,
          first: false,
          currentRetry: currentRetry + 1,
        );
      }
      return null;
    }

    if (first) {
      int estimateTime = result.estimatedTime ?? 10;
      await Future.delayed(estimateTime.seconds);
    } else {
      var waitTime = fibonacci(currentRetry);
      await Future.delayed(waitTime.seconds);
    }
    String? url;
    try {
      var resp = await ApiSvc.getUndressResult(
        result.uid!,
        url: isGeneraImg
            ? AppDeploy.getUndressResult
            : AppDeploy.getUndressVideoResult,
      );
      if (resp == null) {
        return retry();
      }
      if (isGeneraImg) {
        var undImgResult = ApiResponse.fromJson(resp,decodeJson: UndImgResultBean.fromJson);
        var data = undImgResult.data;
        if (data?.status == 2) {
          url = (data?.results)?.first;
        }
      } else {
        var undVideoResult = ApiResponse.fromJson(resp,decodeJson: UndVideoResultBean.fromJson);
        var data = undVideoResult.data;
        url=data?.item?.resultPath;
      }
    } catch (_) {}
    if (!url.isVoid) {
      return url!;
    }
    return retry();
  }

  Future<String?> compressImage(File imageFile) async {
    final tempDir = await getTemporaryDirectory();
    CompressObject compressObject = CompressObject(
      imageFile: imageFile,
      //image
      quality: 85,
      //first compress quality, default 80
      step: 9,
      //compress quality step, The bigger the fast, Smaller is more accurate, default 6
      mode: CompressMode.LARGE2SMALL,
      path: tempDir.path, //default AUTO
    );
    return Luban.compressImage(compressObject);
  }

  Future<String?> compressImageAndConvert(File imgFile) async {
    String? imgPath;
    try {
      imgPath = await compressImage(imgFile);
    } catch (e) {
      print(e);
    }
    if (imgPath.isVoid) {
      imgPath = imgFile.path;
    }
    final ext = imgPath!.toLowerCase().trim();
    if (!ext.endsWith(".jpg") && !ext.endsWith(".jpeg")) {
      convertToJpg(File(imgPath));
    }
    return imgPath;
  }

  Future<File> convertToJpg(File file) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);
    final jpg = img.encodeJpg(image!);
    final newFile = File(file.path.replaceAll('.png', '.jpg'));
    return await newFile.writeAsBytes(jpg);
  }

  /// 对文件进行 md5 计算
  Future<String> md5File(File file) async {
    try {
      final bytes = await file.readAsBytes();
      return crypto.md5.convert(bytes).toString();
    } catch (_) {}
    return "";
  }
}

extension ScrollControllerExt on ScrollController {
  /// 滚动到底部
  Future scrollToBottom({Function()? onScrollToBottom}) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      while (position.pixels != position.maxScrollExtent) {
        jumpTo(position.maxScrollExtent);
        await SchedulerBinding.instance.endOfFrame;
      }
      onScrollToBottom?.call();
    });
  }

  /// 滚动到顶部
  void scrollToTop({Function? callback}) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      while (position.pixels != position.minScrollExtent) {
        jumpTo(position.minScrollExtent);
        await SchedulerBinding.instance.endOfFrame;
      }
      callback?.call();
    });
  }
}
