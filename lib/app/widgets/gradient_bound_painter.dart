import 'package:flutter/material.dart';

/// 渐变色边框与渐变背景
class GradientBoundPainter extends CustomPainter {
  final List<Color>? colors;
  final double? width; // 不再需要必填
  final double? height; // 不再需要必填
  final double strokeWidth;
  final double radius;
  final List<Color>? backgroundColors; // 新增背景渐变色参数
  final Gradient? borderGradient; // 边框渐变色参数
  final Gradient? backgroundGradient; // 背景渐变色参数

  const GradientBoundPainter({
    this.colors,
    this.width, // 可选参数
    this.height, // 可选参数
    this.strokeWidth = 2.0,
    this.radius = 12.0,
    this.backgroundColors,
    this.borderGradient,
    this.backgroundGradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (strokeWidth <= 0) return;
    // 如果 width 或 height 为空，则使用 size 的宽和高
    final rectWidth = width ?? size.width;
    final rectHeight = height ?? size.height;

    // 使用新的宽高来定义矩形的位置和尺寸
    final rect = Rect.fromLTWH(0, 0, rectWidth, rectHeight);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    final adjustedRect = rect.deflate(strokeWidth / 2); // 向内缩小边框宽度的一半
    final adjustedRRect = RRect.fromRectAndRadius(adjustedRect, Radius.circular(radius));

    // 绘制渐变背景
    if (backgroundColors != null) {
      final gradient =
          backgroundGradient ??
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: backgroundColors!,
          );

      final backgroundPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(rRect, backgroundPaint);
    }

    // 绘制边框
    final border =
        borderGradient ??
        LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: colors ?? [const Color(0xFF53B4CC), const Color(0xFFEBFF4C)],
        );

    final borderPaint = Paint()
      ..shader = border.createShader(adjustedRect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(adjustedRRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant GradientBoundPainter oldDelegate) {
    return oldDelegate.colors != colors ||
        oldDelegate.backgroundColors != backgroundColors;
  }
}
class InnerShadow extends StatelessWidget {
  final Widget child;
  final double blur;
  final Offset offset;
  final Color color;
  final BorderRadius borderRadius;

  const InnerShadow({
    super.key,
    required this.child,
    this.blur = 10,
    this.offset = const Offset(4, 4),
    this.color = Colors.black54,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _InnerShadowPainter(
        blur: blur,
        offset: offset,
        color: color,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

class _InnerShadowPainter extends CustomPainter {
  final double blur;
  final Offset offset;
  final Color color;
  final BorderRadius borderRadius;

  _InnerShadowPainter({
    required this.blur,
    required this.offset,
    required this.color,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final rrect = borderRadius.toRRect(rect);

    // 阴影画笔
    final shadowPaint = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);

    // 关键：用 saveLayer 做裁剪反向阴影
    canvas.saveLayer(rect, Paint());
    canvas.drawRRect(rrect.shift(offset), shadowPaint);

    // 挖空中间区域，形成“内阴影”
    final clearPaint = Paint()
      ..blendMode = BlendMode.clear;

    canvas.drawRRect(rrect, clearPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

