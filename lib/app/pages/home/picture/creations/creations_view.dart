import 'package:novatalk/app/configs/app_theme.dart';
import 'package:novatalk/app/widgets/common_widget.dart';
import 'package:novatalk/app/widgets/overall_build_widget.dart';
import 'package:novatalk/generated/locales.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import 'creations_controller.dart';

class CreationsView extends GetBuildView<CreationsController> {
  const CreationsView({super.key});

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      body: buildDefaultBg(
        child: Column(
          children: [
            buildHomeAppBar(
              leading: Center(
                child: TapBox(
                  onTap: () {
                    Get.back();
                  },
                  child: buildBackIcon(color: Color(0xff1C1A1D)),
                ),
              ),
              title: LocaleKeys.creations.tv(
                style: TextStyle(
                  color: Color(0xff1C1A1D),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                itemCount: controller.creations.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 7.w,
                  mainAxisSpacing: 7.h,
                ),
                itemBuilder: (context, index) {
                  final item = controller.creations[index];
                  return TapBox(
                    onTap: () {
                      Get.toNamed(
                        Routes.IMAGEP_REVIEW,
                        arguments: item.resultUrl,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: item.resultUrl.iv(height: 172.h),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
