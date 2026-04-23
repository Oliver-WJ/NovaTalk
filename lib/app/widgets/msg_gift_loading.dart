import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:novatalk/app/configs/app_theme.dart';

import '../../generated/locales.g.dart';

class MsgGiftLoading extends StatelessWidget {
  const MsgGiftLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: buildDefaultBg(
          child: Column(
            children: [
              Text(
                LocaleKeys.yourGift.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ).marginSymmetric(vertical: 23.h),
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      20.verticalSpace,
                      Lottie.asset(
                        'assets/anima/loading.json',
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        LocaleKeys.giveMomentHits.tr,
                        style: tTheme.bodyLarge!.copyWith(color: Colors.black),
                        textAlign: TextAlign.center,
                      ).marginSymmetric(horizontal: 40.w),
                      Divider(height: 24, color: Colors.grey.withValues(alpha: 0.4), thickness: 1,),
                      Text(
                        LocaleKeys.secondsHits.tr,
                        style: const TextStyle(
                          color: Color(0xFF808080),
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ).marginSymmetric(horizontal: 40.w),
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
}
