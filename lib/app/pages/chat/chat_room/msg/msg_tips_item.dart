import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:novatalk/app/configs/app_theme.dart';

import '../../../../../generated/locales.g.dart';
import '../../../../widgets/blur_background.dart';

class MsgTipsItem extends StatelessWidget {
  final String? text;

  const MsgTipsItem({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SBlurBackground(
        blur: 60,
        backgroundColor: Color(0xff212121).withValues(alpha: 0.5),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.w)),
          child: Text(
            text ?? LocaleKeys.generatedResp.tr,
            style: tTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
        ),
      ),
    );
  }
}
