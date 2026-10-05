import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';

class DarkGridPainter extends CustomPainter {
  const DarkGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.045)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    const step = 32.0;
    final points = <Offset>[];
    for (double x = 16; x < size.width; x += step) {
      for (double y = 16; y < size.height; y += step) {
        points.add(Offset(x, y));
      }
    }
    canvas.drawPoints(ui.PointMode.points, points, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LightGridPainter extends CustomPainter {
  const LightGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = AppColors.ink400.withValues(alpha: 0.20)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    const step = 28.0;
    final points = <Offset>[];
    for (double x = 14; x < size.width; x += step) {
      for (double y = 14; y < size.height; y += step) {
        points.add(Offset(x, y));
      }
    }
    canvas.drawPoints(ui.PointMode.points, points, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
