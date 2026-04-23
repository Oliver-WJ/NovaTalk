import 'package:flutter/material.dart';

/// 渐变色边框与渐变背景
class BoundPainter extends CustomPainter {
  final List<Color>? colors;
  final double? width; // 不再需要必填
  final double? height; // 不再需要必填
  final double strokeWidth;
  final double radius;
  final List<Color>? backgroundColors; // 新增背景渐变色参数
  final Gradient? borderGradient; // 边框渐变色参数
  final Gradient? backgroundGradient; // 背景渐变色参数

  const BoundPainter({
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
      final gradient = backgroundGradient ??
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
    final border = borderGradient ??
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
  bool shouldRepaint(covariant BoundPainter oldDelegate) {
    return oldDelegate.colors != colors || oldDelegate.backgroundColors != backgroundColors;
  }
}
