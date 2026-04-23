import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:novatalk/app/widgets/common_widget.dart';

import '../../widgets/water_ripple_effect.dart';

class PhoneBtn extends StatelessWidget {
  const PhoneBtn({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    this.iconColor,
    this.animationColor,
    required this.onTap,
    this.isLinearGradientBg = false,
  });

  final Widget icon;
  final String title;
  final Color color;
  final Color? iconColor;
  final bool isLinearGradientBg;
  final Color? animationColor;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 140.w,
                height: 56.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(28.w),
                  color: color,
                ),
                child: Center(child: icon),
              ),
              if (animationColor != null)
                WaterRippleEffect(
                  width: 140.w,
                  height: 56.w,
                  color: animationColor!,
                  borderWidth: 1.0,
                  rippleSpacing: 300, // ripple interval in milliseconds
                  scaleMultiplier: 0.5, // adjust the scale multiplier to reduce the size change
                ),
            ],
          ),
          SizedBox(height: 10.w),
          Text(
            title,
            maxLines: 1,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
