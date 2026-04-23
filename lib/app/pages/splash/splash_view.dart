import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:novatalk/app/configs/app_theme.dart';
import 'package:novatalk/app/widgets/common_widget.dart';

import '../../../generated/assets.dart';
import '../../../generated/locales.g.dart';
import 'splash_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize:  MainAxisSize.min,
              children: [
                Assets.imagesPhLogo2.iv(width: 120.w),
                25.verticalSpace,
                LocaleKeys.appLabel.tv(
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Positioned(
          //   bottom: 50.h,
          //   width: Get.width,
          //   child: SafeArea(
          //     child: Center(
          //       child: LocaleKeys.appLabel.tv(
          //         style: TextStyle(
          //           fontSize: 24.sp,
          //           fontWeight: FontWeight.w600,
          //           color: Colors.white,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
