import 'package:novatalk/app/utils/common_utils.dart';
import 'package:novatalk/app/widgets/common_widget.dart';
import 'package:novatalk/app/widgets/release_text_edit_focus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:novatalk/generated/assets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../generated/locales.g.dart';
import '../../../configs/app_theme.dart';
import '../../../widgets/custom_Indicator.dart';
import '../undr_page.dart';
import '../undr_video.dart';
import 'ai_photo_controller.dart';

class AiPhotoPage extends GetView<AiPhotoController> {
  const AiPhotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AiPhotoController());
    return ReleaseTextEditFocus(
      child: buildDefaultBg(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SafeArea(
              //   child: ShaderMask(
              //     shaderCallback: (Rect bounds) {
              //       return LinearGradient(
              //         colors: [Color(0xffFAF6DB), Color(0xffDFA157)],
              //         begin: Alignment.topCenter,
              //         end: Alignment.bottomCenter,
              //       ).createShader(bounds);
              //     },
              //     child: LocaleKeys.artwork.tv(
              //       style: TextStyle(
              //         fontSize: 25.sp,
              //         fontStyle: FontStyle.italic,
              //         fontWeight: FontWeight.w900,
              //       ),
              //     ),
              //   ).marginOnly(left: 16.w, top: 10.h, bottom: 15.h),
              // ),
              SizedBox(
                height: 40.h,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -8.h,
                      child: DefaultTabController(
                        length: 2,
                        child: Builder(
                          builder: (context) {
                            return buildHomeTitleTabBar(
                              tabs: [
                                TapBox(
                                  child: Tab(text: LocaleKeys.image.tr),
                                  onTap: () {
                                    DefaultTabController.of(context).animateTo(0);
                                    controller.createImg.value = true;
                                  },
                                ),
                                TapBox(
                                  child: Tab(text: LocaleKeys.iToVideo.tr),
                                  onTap: () {
                                    DefaultTabController.of(context).animateTo(1);
                                    controller.createImg.value = false;
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(
                  () => IndexedStack(
                    index: controller.createImg.value ? 0 : 1,
                    children: [
                      UndressPage(tag: AiPhotoController.tag),
                      const UndrVideoPage(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTapBar({String title = '', onTap, bool isSelect = false}) {
    return TapBox(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: isSelect ? "#906BF7".hex() : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          title.tr,
          style: TextStyle(
            fontSize: 14.sp,
            color: isSelect ? Colors.white : "#666666".hex(),
            fontWeight: isSelect ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
