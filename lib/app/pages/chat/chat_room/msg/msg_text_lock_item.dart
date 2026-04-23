import 'dart:ui';

import 'package:novatalk/app/configs/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:novatalk/app/utils/app_user.dart';
import 'package:novatalk/app/utils/clo_util.dart';
import 'package:novatalk/app/widgets/common_widget.dart';

import '../../../../../generated/assets.dart';
import '../../../../../generated/locales.g.dart';
import '../../../../configs/app_theme.dart';
import '../../../../configs/constans.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/log/log_event.dart';

class MsgTextLockItem extends StatelessWidget {
  const MsgTextLockItem({super.key, this.onTap});

  final void Function()? onTap;

  void _unLockTextGems() async {
    logEvent('c_news_locktext');
    if (!AppUser.inst.isVip.value) {
      Get.toNamed(Routes.VIP, arguments: VipFrom.locktext);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.w),
      child: GestureDetector(
        onTap: _unLockTextGems,
        child: Stack(
          alignment:  Alignment.center,
          children: [
            Container(
              height: 112.w,
              width: 300.w,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.w),
                  bottomRight: Radius.circular(16.w),
                  topRight: Radius.circular(16.w),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      LocaleKeys.askHelp.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ClipPath(
                    clipper: ShapeBorderClipper(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16.w),
                          bottomRight: Radius.circular(16.w),
                          topRight: Radius.circular(16.w),
                        ),
                      ),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        alignment: Alignment.center,
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xff212121).withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLabel(),
                  6.verticalSpace,
                  Text(
                    LocaleKeys.tapPrev.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  6.verticalSpace,
                  buildTheme3Btn(
                    vertical: 3.h,
                    title: LocaleKeys.unlockNow.tr,
                  ).marginSymmetric(horizontal: 15.w),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel() {
    if (!CloUtil.isCloB) {
      return SizedBox(width: 22.w, height: 22.w);
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
         Radius.circular(16.r)
        ),
        color: Color(0xff262008).withValues(alpha: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.imagesPhMgLock.iv(width: 16.w),
          4.horizontalSpace,
          Text(
            LocaleKeys.unlockGain.trParams({'s': AppConfig.kNS}),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xffF6E961),
            ),
          ),
        ],
      ),
    );
  }
}
