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

/// Holographic laminate over the card face. The sheen band and the
/// iridescent patch over the rosette both follow [tilt] (-1..1 on each
/// axis), so the foil shifts as the card turns under the light.
class HoloFoilPainter extends CustomPainter {
  const HoloFoilPainter({required this.tilt});

  final Offset tilt;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Sheen band sweeping across with the tilt.
    final c = 0.5 + tilt.dx * 0.45 + tilt.dy * 0.2;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0),
            AppColors.tealLight.withValues(alpha: 0.16),
            Colors.white.withValues(alpha: 0.42),
            AppColors.goldSoft.withValues(alpha: 0.2),
            Colors.white.withValues(alpha: 0),
          ],
          stops: [
            (c - 0.32).clamp(0.0, 1.0),
            (c - 0.12).clamp(0.0, 1.0),
            c.clamp(0.0, 1.0),
            (c + 0.12).clamp(0.0, 1.0),
            (c + 0.32).clamp(0.0, 1.0),
          ],
        ).createShader(rect),
    );

    // Iridescent hologram patch over the rosette.
    final centre = Offset(size.width * 0.86, size.height * 0.34);
    final r = size.height * 0.2;
    final patch = Rect.fromCircle(center: centre, radius: r);
    canvas.drawCircle(
      centre,
      r,
      Paint()
        ..shader = SweepGradient(
          transform: GradientRotation((tilt.dx - tilt.dy) * math.pi),
          colors: [
            AppColors.tealLight.withValues(alpha: 0.5),
            AppColors.goldSoft.withValues(alpha: 0.55),
            AppColors.signalLight.withValues(alpha: 0.35),
            Colors.white.withValues(alpha: 0.5),
            AppColors.tealLight.withValues(alpha: 0.5),
          ],
        ).createShader(patch),
    );
  }

  @override
  bool shouldRepaint(HoloFoilPainter oldDelegate) => oldDelegate.tilt != tilt;
}

/// A wall of hex byte pairs, the raw traffic between reader and card.
/// Laid out once per size; rows are single text runs so painting stays
/// cheap. Deterministic, so it doesn't reshuffle between frames.
class HexFieldPainter extends CustomPainter {
  HexFieldPainter({required this.color});

  final Color color;

  static const double _rowHeight = 22;
  static const String _digits = '0123456789ABCDEF';

  final List<TextPainter> _rows = [];
  Size? _laidOutFor;

  void _layout(Size size) {
    for (final r in _rows) {
      r.dispose();
    }
    _rows.clear();
    final rng = math.Random(7816);
    final style = TextStyle(
      fontFamily: AppTypography.monoFont,
      fontSize: AppTypography.label,
      color: color,
      letterSpacing: 1.5,
    );
    final pairs = (size.width / 26).ceil() + 1;
    final rows = (size.height / _rowHeight).ceil() + 1;
    for (var y = 0; y < rows; y++) {
      final b = StringBuffer();
      for (var x = 0; x < pairs; x++) {
        b
          ..write(_digits[rng.nextInt(16)])
          ..write(_digits[rng.nextInt(16)])
          ..write(' ');
      }
      _rows.add(
        TextPainter(
          text: TextSpan(text: b.toString(), style: style),
          textDirection: TextDirection.ltr,
          maxLines: 1,
        )..layout(),
      );
    }
    _laidOutFor = size;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_laidOutFor != size) _layout(size);
    for (var i = 0; i < _rows.length; i++) {
      // Alternate rows shift half a pair, like interleaved trace output.
      _rows[i].paint(canvas, Offset(i.isOdd ? -13 : 0, i * _rowHeight));
    }
  }

  @override
  bool shouldRepaint(HexFieldPainter oldDelegate) => oldDelegate.color != color;
}

/// Opens the next page from the reader: a disc of [color] growing from
/// [centre] until it covers the stage.
class IrisPainter extends CustomPainter {
  IrisPainter({
    required this.progress,
    required this.centre,
    required this.color,
  }) : super(repaint: progress);

  final Animation<double> progress;
  final Offset centre;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress.value;
    if (t <= 0) return;
    final reach = [
      Offset.zero,
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ].map((p) => (p - centre).distance).reduce(math.max);
    canvas.drawCircle(centre, reach * t, Paint()..color = color);
  }

  @override
  bool shouldRepaint(IrisPainter oldDelegate) =>
      oldDelegate.centre != centre || oldDelegate.color != color;
}
