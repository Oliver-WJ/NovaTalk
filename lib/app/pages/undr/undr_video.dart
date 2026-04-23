import 'dart:io';

import 'package:novatalk/app/configs/app_config.dart';
import 'package:novatalk/app/configs/constans.dart';
import 'package:novatalk/app/pages/undr/undr_page.dart';
import 'package:novatalk/app/utils/app_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

import '../../../generated/locales.g.dart';
import '../../configs/app_theme.dart';
import '../../routes/app_pages.dart';
import '../../widgets/common_widget.dart';
import 'ctls/undrvideo_page_controller.dart';

class UndrVideoPage extends GetView<UndrVideoPageController> {
  const UndrVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Obx(
        () => Stack(
          children: [
            SingleChildScrollView(
              controller: controller.scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // if (!controller.showPrompt.value &&
                  //     !controller.undressAnother.value)
                    // Center(
                    //   child: Text(
                    //     LocaleKeys.aiVHits4.trParams({"s":AppConfig.kNS}),
                    //     textAlign: TextAlign.center,
                    //     style: undrTitleTextStyle(),
                    //   ).marginOnly(bottom: 13.h),
                    // ),
                  20.verticalSpace,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: Stack(
                      children: [
                        buildImage(),
                        Positioned(
                          right: 10.w,
                          top: 10.h,
                          child: Obx(
                                () =>
                            controller.showPrompt.value ||
                                controller.undressAnother.value &&
                                    !controller.videoLoading.value
                                ? TapBox(
                              onTap: () {
                                controller.resetState();
                              },
                              child: Container(
                                // padding: EdgeInsets.all(5.r),
                                // decoration: BoxDecoration(
                                //   shape: BoxShape.circle,
                                //   color: Colors.black.withValues(
                                //     alpha: 0.3,
                                //   ),
                                // ),
                                child: buildCloseIcon(),
                              ),
                            )
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ],
                    ),
                  ).marginSymmetric(horizontal: 40.w),
                  20.verticalSpace,
                  if (controller.showPrompt.value) showPrompt(),
                  if (!controller.showPrompt.value &&
                      !controller.undressAnother.value)
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xffFAFAFA),
                        borderRadius: BorderRadius.all(
                          Radius.circular(21.r),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                        child: DefaultTextStyle(
                          style: undrDescribeTextStyle(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(LocaleKeys.aiVHits1.tr),
                              6.verticalSpaceFromWidth,
                              Text(LocaleKeys.aHits2.tr),
                              6.verticalSpaceFromWidth,
                              Text(LocaleKeys.aiVHits3.tr),
                            ],
                          ),
                        ),
                      ),
                    ),
                  (ScreenUtil().bottomBarHeight + 100).verticalSpace,
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: cTheme.surface,
                padding: EdgeInsets.only(
                    top: 10.h,
                    bottom: ScreenUtil().bottomBarHeight/2),
                child: controller.showPrompt.value
                    ?
                Container(
                  color: cTheme.surface,
                  padding: EdgeInsets.only(top: 16.h,),
                  child: buildUndrBtn(
                    vertical: 2.h,
                    titleWidget: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LocaleKeys.generate.tv(
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Obx(
                              () => Text.rich(
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff1C1A1D),
                            ),
                            TextSpan(
                              text: '${LocaleKeys.credits.tr}: ',
                              children: [
                                TextSpan(
                                  text: '${AppUser.inst.createVideo}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                  ' ${LocaleKeys.videoChat.tr.toLowerCase()}',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: LocaleKeys.generate.tr,
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      controller.undressVideo();
                    },
                  ).marginSymmetric(horizontal: 12.w),
                )

                // Column(
                //       children: [
                //         Obx(
                //           () => Text.rich(
                //             style: TextStyle(
                //               fontSize: 12.sp,
                //               fontWeight: FontWeight.w400,
                //               color: Colors.white
                //             ),
                //             TextSpan(
                //               text: '${LocaleKeys.credits.tr}: ',
                //               children: [
                //                 TextSpan(
                //                   text: '${AppUser.inst.createVideo}',
                //                   style: TextStyle(
                //                     fontWeight: FontWeight.w600,
                //                     color: cTheme.primary,
                //                   ),
                //                 ),
                //                 TextSpan(
                //                   text:
                //                       ' ${LocaleKeys.videoChat.tr.toLowerCase()}',
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //         4.verticalSpace,
                //         buildUndrBtn(
                //           title: LocaleKeys.generate.tr,
                //           onTap: () => controller.undressVideo(),
                //         ),
                //       ],
                //     )
                    : Obx(() {
                        Widget widget;
                        if (controller.undressAnother.value) {
                          widget = buildUndrBtn(
                            title: LocaleKeys.create.tr,
                            onTap: () => controller.selectImage(),
                          );
                        } else {
                          widget = buildUndrBtn(
                            bold: true,
                         title: LocaleKeys.uploadImage.tr,
                            onTap: () => controller.selectImage(),
                          );
                        }
                        return widget;
                      }),
              ),
            ),
            if (controller.undressing.value) buildProcessView(),
          ],
        ),
      ),
    );
  }

  Widget buildImage() {
    return AspectRatio(
      aspectRatio: 0.77,
      child: Obx(() {
        var videoCtrl = controller.videoController.value;
        if (!controller.userSelectedImage.value.isVoid &&
            !controller.finishGenerate.value) {
          return Image.file(
            File(controller.userSelectedImage.value!),
            fit: BoxFit.cover,
          );
        }
        if (videoCtrl != null) {
          return TapBox(
            onTap: () async {
              if (videoCtrl.value.isInitialized) {
                Get.toNamed(
                  Routes.VIDEO_REVIEW,
                  arguments: controller.lastGenVideoUrl,
                );
                controller.videoController.value!.play();
              }
            },
            child: Stack(
              children: [
                VideoPlayer(controller.videoController.value!),
                controller.videoLoading.value
                    ? Center(child: CircularProgressIndicator(strokeWidth: 3.w,color: cTheme.scrim,))
                    : const SizedBox.shrink(),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  Widget showPrompt() {
    final border =OutlineInputBorder(
      borderSide: BorderSide(
        color:Colors.black.withValues(alpha: 0.12),
        width: 1.w,
      ),
      borderRadius: BorderRadius.all(Radius.circular(12.r))
    );
    return Builder(
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${LocaleKeys.prompt.tr}:",
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            4.verticalSpace,
            TextField(
              focusNode: controller.customPromptFocusNode,
              controller: controller.customPromptController,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400,color:  Colors.black),
              minLines: 1,
              maxLines: 5,
              maxLength: 500,
              cursorColor: Theme1.cursorColor,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 12.sp, color: Colors.black.withValues(alpha: 0.4)),
                filled: true,
                fillColor: Color(0x1AF3EBFF),
                counterStyle: TextStyle(color: Colors.white),
                hintText: LocaleKeys.videoPromptHits.tr,
                border: border,
                enabledBorder: border,
                focusedBorder: border,
              ),
            ),
          ],
        );
      },
    );
  }
}
