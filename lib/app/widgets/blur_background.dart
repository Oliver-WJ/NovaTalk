import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:novatalk/app/widgets/common_widget.dart';

import '../../generated/assets.dart';

class SBlurBackground extends StatelessWidget {
  const SBlurBackground({
    super.key,
    required this.blur,
    this.backgroundColor = Colors.white,
    this.radius = 16.0,
    required this.child,
    this.padding,
    this.borderRadius,
    this.constraints,
  });

  final double blur;
  final Color backgroundColor;
  final double radius;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius ?? BorderRadius.circular(radius),
          ),
          constraints: constraints,
          child: child,
        ),
      ),
    );

  }
}

