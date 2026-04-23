import 'package:novatalk/app/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:novatalk/app/configs/app_theme.dart';
import 'package:novatalk/generated/locales.g.dart';

import '../../../../generated/assets.dart';
import '../../../configs/constans.dart';
import '../../../routes/app_pages.dart';

class VipRoleLock extends StatelessWidget {
  final Function? onBackPressed;

  const VipRoleLock({super.key, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior:  Clip.none,
      alignment:  Alignment.bottomCenter,
      children: [
        Container(
          width:  double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 35.h,
          ),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20.w),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              10.verticalSpace,
              Container(
                decoration:  BoxDecoration(
                  boxShadow:  [
                    BoxShadow(
                      color: Color(0xffE9E654).withOpacity(0.5),
                      blurRadius: 12.w,
                      offset: Offset(0, 5.w),
                    ),
                  ],
                ),
                child: Text(
                  LocaleKeys.accessVip.tr,
                  style: tTheme.headlineMedium,
                ),
              ),
              Assets.imagesPhGem3.iv(width: 207.h, height: 207.h),
              Text(
                LocaleKeys.premiumHits.tr,
                textAlign:  TextAlign.center,
                style: tTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 25.h),

            ],
          ),
        ),
        Positioned(
          bottom: -10.h,
          child: buildTheme3Btn(
            titleWidget: Text(
              LocaleKeys.unlockNow.tr,
              style: tTheme.bodyLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Get.toNamed(Routes.VIP, arguments: VipFrom.viprole);
            },
          ),
        ),
      ],
    );
  }
}
