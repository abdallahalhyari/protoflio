import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';

class Particle {
  double x;
  double y;
  double vx;
  double vy;
  final double radius;
  final int colorIndex;
  final double pulseOffset;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.colorIndex,
    required this.pulseOffset,
  });

  void update(Size bounds, double dt, [Offset? mousePos]) {
    // Gravitational mouse repulsion: particles violently scatter away from cursor
    if (mousePos != null) {
      final mdx = mousePos.dx - x;
      final mdy = mousePos.dy - y;
      final distSq = mdx * mdx + mdy * mdy;
      const repulseRadiusSq = 180.0 * 180.0;
      if (distSq < repulseRadiusSq && distSq > 1.0) {
        // Strong inverse-distance force — violent when close, tapers off
        final dist = math.sqrt(distSq);
        final force = (1.0 - (dist / 180.0)) * 600.0;
        vx -= (mdx / dist) * force * dt;
        vy -= (mdy / dist) * force * dt;
      }
    }

    // Cap velocity so attraction doesn't cause runaway acceleration
    const maxSpeed = 50.0;
    final speed = vx * vx + vy * vy;
    if (speed > maxSpeed * maxSpeed) {
      final scale = maxSpeed / math.sqrt(speed);
      vx *= scale;
      vy *= scale;
    }

    x += vx * dt;
    y += vy * dt;

    if (x < 0) {
      x = 0;
      vx = -vx;
    } else if (x > bounds.width) {
      x = bounds.width;
      vx = -vx;
    }

    if (y < 0) {
      y = 0;
      vy = -vy;
    } else if (y > bounds.height) {
      y = bounds.height;
      vy = -vy;
    }
  }
}

class ConstellationPainter extends CustomPainter {
  final List<Particle> particles;
  final Offset? mousePos;
  final bool isDark;
  final Color primary;
  final double time;

  // Pre-allocated paints to eliminate garbage collection allocations
  final Paint _nodePaint = Paint()..style = PaintingStyle.fill;
  final Paint _linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  static const double _maxConnectDist = 110.0;
  static const double _maxConnectDistSq = _maxConnectDist * _maxConnectDist;
  static const double _maxMouseDist = 140.0;
  static const double _maxMouseDistSq = _maxMouseDist * _maxMouseDist;

  ConstellationPainter({
    required this.particles,
    required this.mousePos,
    required this.isDark,
    required this.primary,
    required this.time,
  });

  Color _resolveColor(int colorIndex) {
    switch (colorIndex) {
      case 0:
        return primary; // Electric Indigo
      case 1:
        return isDark ? AppColors.accentVioletLight : AppColors.accentViolet;
      case 2:
        return isDark ? AppColors.accentSkySoft : AppColors.accentSky;
      case 3:
      default:
        return isDark ? AppColors.accentAmberSoft : AppColors.accentAmberBright;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (particles.isEmpty) return;

    // 1. Draw Inter-particle Constellation Lines
    final pLen = particles.length;
    for (var i = 0; i < pLen; i++) {
      final p1 = particles[i];
      for (var j = i + 1; j < pLen; j++) {
        final p2 = particles[j];
        final dx = p1.x - p2.x;
        final dy = p1.y - p2.y;
        final distSq = dx * dx + dy * dy;

        if (distSq < _maxConnectDistSq) {
          final dist = math.sqrt(distSq);
          final norm = 1.0 - (dist / _maxConnectDist);
          final alpha = norm * (isDark ? 0.22 : 0.12);

          _linePaint.color = primary.withValues(alpha: alpha);
          _linePaint.strokeWidth = 0.8 * norm + 0.4;
          canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), _linePaint);
        }
      }

      // 2. Draw Interactive Mouse Strands
      if (mousePos != null) {
        final mdx = p1.x - mousePos!.dx;
        final mdy = p1.y - mousePos!.dy;
        final mDistSq = mdx * mdx + mdy * mdy;

        if (mDistSq < _maxMouseDistSq) {
          final mDist = math.sqrt(mDistSq);
          final mNorm = 1.0 - (mDist / _maxMouseDist);
          final mAlpha = mNorm * (isDark ? 0.38 : 0.24);

          _linePaint.color =
              AppColors.accentCyanLight.withValues(alpha: mAlpha);
          _linePaint.strokeWidth = 1.2 * mNorm + 0.5;
          canvas.drawLine(Offset(p1.x, p1.y),
              Offset(mousePos!.dx, mousePos!.dy), _linePaint);
        }
      }
    }

    // 3. Draw Nodes with Pulsing Luminous Core
    for (final p in particles) {
      final pulse = 0.85 + 0.25 * math.sin(time + p.pulseOffset);
      final c = _resolveColor(p.colorIndex);
      final nodeAlpha = isDark ? (0.45 * pulse) : (0.55 * pulse);

      _nodePaint.color = c.withValues(alpha: nodeAlpha);
      canvas.drawCircle(Offset(p.x, p.y), p.radius * pulse, _nodePaint);

      // Faint outer glow halo for larger nodes in dark mode
      if (isDark && p.radius > 2.2) {
        _nodePaint.color = c.withValues(alpha: 0.12 * pulse);
        canvas.drawCircle(Offset(p.x, p.y), p.radius * 2.4 * pulse, _nodePaint);
      }
    }

    // 4. Subtle Cursor Highlight Aura
    if (mousePos != null) {
      _nodePaint.color = primary.withValues(alpha: isDark ? 0.25 : 0.15);
      canvas.drawCircle(mousePos!, 3.5, _nodePaint);
      _nodePaint.color = primary.withValues(alpha: isDark ? 0.08 : 0.04);
      canvas.drawCircle(mousePos!, 22.0, _nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant ConstellationPainter oldDelegate) => true;
}
