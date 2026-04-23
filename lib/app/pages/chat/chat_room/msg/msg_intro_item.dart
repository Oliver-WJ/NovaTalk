import 'package:novatalk/app/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../configs/app_theme.dart';
import '../../../../widgets/blur_background.dart';

class MsgIntroItem extends StatelessWidget {
  const MsgIntroItem({
    super.key,
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SBlurBackground(
      blur: 60,
      backgroundColor: Color(0xff212121).withValues(alpha: 0.7),
      padding: const EdgeInsets.all(12),
      borderRadius: const BorderRadiusDirectional.only(
        topEnd: Radius.circular(16),
        bottomStart: Radius.circular(16),
        bottomEnd: Radius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: tTheme.bodyLarge!.copyWith(color: cTheme.scrim, fontWeight: FontWeight.w400)),
          const SizedBox(height: 2),
          Text(text,  style: tTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400,color: Colors.white)),
        ],
      ),
    ).marginOnly(right: 43.w);
  }
}
