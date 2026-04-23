import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DotIndicator extends Decoration {
  final Color color;

  final double radius;
  final Offset? kOffset;
  final Gradient? gradient;

  const DotIndicator({
    this.color = const Color(0xFF000000),
    this.radius = 3,
    this.kOffset,
    this.gradient,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _DotPainter(
      color: color,
      radius: radius,
      kOffset: kOffset,
      gradient: gradient,
    );
  }
}

class _DotPainter extends BoxPainter {
  final Color? color;
  final double? radius;
  final Offset? kOffset;
  final Gradient? gradient;

  const _DotPainter({this.color, this.radius, this.kOffset, this.gradient});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Rect rect = Rect.fromLTWH(
      cfg.size!.width - (kOffset?.dx ?? 3.w) + offset.dx,
      kOffset?.dy ?? 15.h,
      18.w,
      5.w,
    );
    final Paint paint = Paint()
      ..shader = gradient?.createShader(rect)
      ..isAntiAlias = true;
    if (color != null) {
      paint.color = color!;
    }
    // final RRect rrect = RRect.fromRectAndRadius(
    //   rect,
    //   Radius.circular(radius ),
    // );
    canvas.drawOval(rect, paint);
  }
}

class DiagonalClipper extends CustomClipper<Path> {
  Path Function(Size size) pathBuilder;

  DiagonalClipper({required this.pathBuilder});

  @override
  Path getClip(Size size) {
    return pathBuilder.call(size);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class GradientBorderWithTriangle extends Decoration {
  final Gradient gradient;
  final double topBorderWidth;
  final double sideBorderWidth;
  final double bottomBorderWidth;
  final double triangleWidth;
  final double triangleHeight;
  final Color triangleColor;
  final BorderRadius borderRadius;
  final Gradient? backgroundGradient;

  const GradientBorderWithTriangle({
    required this.gradient,
    this.topBorderWidth = 1.0,
    this.sideBorderWidth = 1.0,
    this.bottomBorderWidth = 3.0,
    this.triangleWidth = 9.0,
    this.triangleHeight = 4.5,
    this.triangleColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(5.5)),
    this.backgroundGradient,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _GradientBorderWithTrianglePainter(
      gradient: gradient,
      topBorderWidth: topBorderWidth,
      sideBorderWidth: sideBorderWidth,
      bottomBorderWidth: bottomBorderWidth,
      triangleWidth: triangleWidth,
      triangleHeight: triangleHeight,
      triangleColor: triangleColor,
      borderRadius: borderRadius,
      backgroundGradient: backgroundGradient,
    );
  }
}

class _GradientBorderWithTrianglePainter extends BoxPainter {
  final Gradient gradient;
  final double topBorderWidth;
  final double sideBorderWidth;
  final double bottomBorderWidth;
  final double triangleWidth;
  final double triangleHeight;
  final Color triangleColor;
  final BorderRadius borderRadius;
  final Gradient? backgroundGradient;

  const _GradientBorderWithTrianglePainter({
    required this.gradient,
    required this.topBorderWidth,
    required this.sideBorderWidth,
    required this.bottomBorderWidth,
    required this.triangleWidth,
    required this.triangleHeight,
    required this.triangleColor,
    required this.borderRadius,
    this.backgroundGradient,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    offset = offset + Offset(-10, 8);
    final Size size = cfg.size! + Offset(20, -15);
    final Rect rect = offset & size;

    // 如果有背景渐变，先绘制背景
    if (backgroundGradient != null) {
      final RRect backgroundRRect = borderRadius.toRRect(rect);
      final Paint backgroundPaint = Paint()
        ..shader = backgroundGradient!.createShader(rect)
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
      canvas.drawRRect(backgroundRRect, backgroundPaint);
    }

    // 创建渐变画笔
    final Paint gradientPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    // 绘制顶部边框（带圆角）
    final Path topPath = Path();
    final RRect topRRect = borderRadius.toRRect(rect);

    gradientPaint.strokeWidth = topBorderWidth;
    // 从左上角圆角开始
    topPath.moveTo(rect.left, rect.top + topRRect.tlRadiusY);
    topPath.arcToPoint(
      Offset(rect.left + topRRect.tlRadiusX, rect.top),
      radius: Radius.circular(topRRect.tlRadiusX),
      clockwise: true,
    );
    topPath.lineTo(rect.right - topRRect.trRadiusX, rect.top);
    topPath.arcToPoint(
      Offset(rect.right, rect.top + topRRect.trRadiusY),
      radius: Radius.circular(topRRect.trRadiusX),
      clockwise: true,
    );
    canvas.drawPath(topPath, gradientPaint);

    // 绘制左侧边框（带圆角）
    final Path leftPath = Path();
    gradientPaint.strokeWidth = sideBorderWidth;
    leftPath.moveTo(rect.left, rect.top + topRRect.tlRadiusY);
    leftPath.lineTo(rect.left, rect.bottom - topRRect.blRadiusY);
    leftPath.arcToPoint(
      Offset(rect.left + topRRect.blRadiusX, rect.bottom),
      radius: Radius.circular(topRRect.blRadiusX),
      clockwise: false,
    );
    canvas.drawPath(leftPath, gradientPaint);

    // 绘制右侧边框（带圆角）
    final Path rightPath = Path();
    gradientPaint.strokeWidth = sideBorderWidth;
    rightPath.moveTo(rect.right, rect.top + topRRect.trRadiusY);
    rightPath.lineTo(rect.right, rect.bottom - topRRect.brRadiusY);
    rightPath.arcToPoint(
      Offset(rect.right - topRRect.brRadiusX, rect.bottom),
      radius: Radius.circular(topRRect.brRadiusX),
      clockwise: true,
    );
    canvas.drawPath(rightPath, gradientPaint);

    // 绘制底部边框（更厚，带圆角）

    final Path bottomPath = Path();
    gradientPaint.strokeWidth = bottomBorderWidth;
    bottomPath.moveTo(rect.left + topRRect.blRadiusX, rect.bottom);
    bottomPath.lineTo(rect.right - topRRect.brRadiusX, rect.bottom);
    canvas.drawPath(bottomPath, gradientPaint);

    // 绘制底部中间的实心三角形
    final Paint trianglePaint = Paint()
      ..color = triangleColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final Path trianglePath = Path();
    final double centerX = rect.left + size.width / 2;
    final double bottomY = rect.bottom;

    // 三角形顶点（指向上）
    trianglePath.moveTo(centerX, bottomY - triangleHeight);
    // 左下角
    trianglePath.lineTo(centerX - triangleWidth / 2, bottomY);
    // 右下角
    trianglePath.lineTo(centerX + triangleWidth / 2, bottomY);
    trianglePath.close();

    canvas.drawPath(trianglePath, trianglePaint);
  }
}

class ImageDecoration extends Decoration {
  final BoxFit fit;
  final Alignment alignment;
  final double? width;
  final double? height;
  final ColorFilter? colorFilter;
  final ui.Image? image;
  final Offset? offset;

  const ImageDecoration({
    required this.image,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.width,
    this.height,
    this.colorFilter,
    this.offset,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _ImagePainter(
      fit: fit,
      alignment: alignment,
      width: width,
      height: height,
      colorFilter: colorFilter,
      image: image,
      offset: offset,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ImageDecoration &&
        other.image == image &&
        other.fit == fit &&
        other.alignment == alignment &&
        other.width == width &&
        other.height == height &&
        other.colorFilter == colorFilter;
  }

  @override
  int get hashCode {
    return Object.hash(image, fit, alignment, width, height, colorFilter);
  }
}

class _ImagePainter extends BoxPainter {
  final BoxFit fit;
  final Alignment alignment;
  final double? width;
  final double? height;
  final ColorFilter? colorFilter;
  final ui.Image? image;
  final Offset? offset;

  _ImagePainter({
    required this.fit,
    required this.alignment,
    this.offset,
    this.width,
    this.height,
    this.colorFilter,
    this.image,
  }) : super();

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    if (image == null) {
      return;
    }
    final Size containerSize = cfg.size ?? Size.zero;

    final Size targetSize = Size(
      width ?? containerSize.width,
      height ?? containerSize.height,
    );
    if (this.offset != null) {
      offset = offset + this.offset!;
    }
    final Rect containerRect = offset & containerSize;

    final Size imageSize = Size(
      image!.width.toDouble(),
      image!.height.toDouble(),
    );

    final FittedSizes fittedSizes = applyBoxFit(fit, imageSize, targetSize);
    final Size outputSize = fittedSizes.destination;

    final Rect sourceRect = Rect.fromLTWH(
      0,
      0,
      imageSize.width,
      imageSize.height,
    );

    final Rect destinationRect = alignment.inscribe(outputSize, containerRect);

    final Paint paint = Paint()
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.high;

    if (colorFilter != null) {
      paint.colorFilter = colorFilter;
    }

    canvas.drawImageRect(image!, sourceRect, destinationRect, paint);
  }
}

class RectDecoration extends Decoration {
  final Alignment alignment;
  final double? width;
  final double? height;
  final Color backgroundColor;
  final Offset? offset;
  final BorderRadius? borderRadius;

  const RectDecoration({
    required this.backgroundColor,
    this.alignment = Alignment.center,
    this.width,
    this.height,
    this.offset,
    this.borderRadius,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _RectPainter(
      alignment: alignment,
      width: width,
      height: height,
      backgroundColor: backgroundColor,
      offset: offset,
      borderRadius: borderRadius,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RectDecoration &&
        other.backgroundColor == backgroundColor &&
        other.alignment == alignment &&
        other.width == width &&
        other.height == height &&
        other.offset == offset &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode {
    return Object.hash(backgroundColor, alignment, width, height, offset, borderRadius);
  }
}

class _RectPainter extends BoxPainter {
  final Alignment alignment;
  final double? width;
  final double? height;
  final Color backgroundColor;
  final Offset? offset;
  final BorderRadius? borderRadius;

  _RectPainter({
    required this.alignment,
    required this.backgroundColor,
    this.width,
    this.height,
    this.offset,
    this.borderRadius,
  }) : super();

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Size containerSize = cfg.size ?? Size.zero;

    final Size targetSize = Size(
      width ?? containerSize.width,
      height ?? containerSize.height,
    );
    
    if (this.offset != null) {
      offset = offset + this.offset!;
    }
    
    final Rect containerRect = offset & containerSize;
    final Rect destinationRect = alignment.inscribe(targetSize, containerRect);

    final Paint paint = Paint()
      ..color = backgroundColor
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    if (borderRadius != null) {
      final RRect rrect = borderRadius!.toRRect(destinationRect);
      canvas.drawRRect(rrect, paint);
    } else {
      canvas.drawRect(destinationRect, paint);
    }
  }
}
