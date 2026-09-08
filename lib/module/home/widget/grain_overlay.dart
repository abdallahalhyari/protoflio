import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Full-canvas film-grain texture that sits above content but ignores
/// hit-tests. Roughly 1500 sub-pixel dots at low alpha for tactile
/// depth without banding.
///
/// The dot positions are seeded and cached at class load so every paint
/// is deterministic and cheap; RepaintBoundary keeps this out of the
/// main layer's redraw path.
class GrainOverlay extends StatelessWidget {
  final double opacity;
  const GrainOverlay({super.key, this.opacity = 0.05});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _GrainPainter(opacity: opacity),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _GrainPainter extends CustomPainter {
  final double opacity;
  const _GrainPainter({required this.opacity});

  static final List<Offset> _cached = _seed();
  static List<Offset> _seed() {
    final r = math.Random(42);
    return List.generate(1500, (_) => Offset(r.nextDouble(), r.nextDouble()));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: opacity);
    for (final p in _cached) {
      canvas.drawCircle(
        Offset(p.dx * size.width, p.dy * size.height),
        0.6,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GrainPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}
