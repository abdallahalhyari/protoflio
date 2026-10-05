import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:profile/core/theme/tokens.dart';

/// Security-print linework behind the card's text: a band of phase-shifted
/// sine strokes (the guilloche you find on banknotes and ID cards) and a
/// rosette on the trailing edge. Static, so it paints once.
class GuillochePainter extends CustomPainter {
  const GuillochePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    // Wave band across the lower half.
    const lines = 18;
    final baseY = size.height * 0.74;
    final amp = size.height * 0.05;
    for (var k = 0; k < lines; k++) {
      final path = Path();
      final phase = k * math.pi / lines;
      final drift = (k - lines / 2) * size.height * 0.006;
      for (var x = 0.0; x <= size.width; x += 3) {
        final t = x / size.width;
        final y = baseY +
            drift +
            amp * math.sin(t * math.pi * 5 + phase) * math.sin(t * math.pi);
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, stroke);
    }

    // Rosette: a hypotrochoid centred off the trailing edge.
    final centre = Offset(size.width * 0.86, size.height * 0.34);
    final r = size.height * 0.26;
    final rosette = Path();
    const steps = 720;
    for (var i = 0; i <= steps; i++) {
      final a = i / steps * math.pi * 2;
      final rr = r * (0.72 + 0.28 * math.cos(a * 9));
      final p = centre + Offset(math.cos(a) * rr, math.sin(a) * rr);
      if (i == 0) {
        rosette.moveTo(p.dx, p.dy);
      } else {
        rosette.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(rosette, stroke);
    canvas.drawCircle(centre, r * 0.44, stroke);
  }

  @override
  bool shouldRepaint(GuillochePainter oldDelegate) =>
      oldDelegate.color != color;
}

/// The ISO 7816 contact plate: a gold rounded rectangle split into eight
/// pads around a centre die.
class ChipPainter extends CustomPainter {
  const ChipPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final plate = RRect.fromRectAndRadius(
      rect,
      Radius.circular(size.shortestSide * 0.16),
    );
    canvas.drawRRect(
      plate,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.goldSoft, AppColors.gold, AppColors.goldDeep],
          stops: [0, 0.55, 1],
        ).createShader(rect),
    );

    final line = Paint()
      ..color = AppColors.goldDeep.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.035;
    final w = size.width, h = size.height;
    final die = Rect.fromCenter(
      center: rect.center,
      width: w * 0.30,
      height: h * 0.42,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(die, Radius.circular(h * 0.06)),
      line,
    );
    // Horizontal pad seams, broken by the die.
    for (final y in [h * 0.34, h * 0.66]) {
      canvas.drawLine(Offset(0, y), Offset(die.left, y), line);
      canvas.drawLine(Offset(die.right, y), Offset(w, y), line);
    }
    // Vertical seams from the die to the plate edge.
    canvas.drawLine(Offset(w / 2, 0), Offset(w / 2, die.top), line);
    canvas.drawLine(Offset(w / 2, die.bottom), Offset(w / 2, h), line);
    canvas.drawRRect(plate, line);
  }

  @override
  bool shouldRepaint(ChipPainter oldDelegate) => false;
}

/// The contactless symbol: three arcs. [pulse] (0..1) runs a wave
/// outwards through them while the chip is being read.
class ContactlessPainter extends CustomPainter {
  ContactlessPainter({required this.color, required this.pulse})
      : super(repaint: pulse);

  final Color color;
  final Animation<double> pulse;

  @override
  void paint(Canvas canvas, Size size) {
    final origin = Offset(0, size.height / 2);
    final t = pulse.value;
    for (var i = 0; i < 3; i++) {
      final radius = size.width * (0.38 + i * 0.3);
      // Each arc brightens as the wave front passes it.
      final front = (t * 4 - i).clamp(0.0, 2.0);
      final glow = front <= 1 ? front : 2 - front;
      final paint = Paint()
        ..color = Color.lerp(
          color.withValues(alpha: 0.55),
          color,
          t == 0 ? 0 : glow,
        )!
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = size.width * 0.09;
      canvas.drawArc(
        Rect.fromCircle(center: origin, radius: radius),
        -math.pi / 4,
        math.pi / 2,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ContactlessPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.pulse != pulse;
}
