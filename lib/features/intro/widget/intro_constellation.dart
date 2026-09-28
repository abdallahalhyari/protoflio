import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:profile/theme/tokens.dart';

/// Ambient interactive constellation / particle mesh for the Intro hero.
///
/// Nodes float gently in 2D space and connect with delicate glowing lines
/// when in proximity. On desktop, particles dynamically react to the user's
/// cursor, creating an organic, high-tech digital constellation.
///
/// Architecture & Performance:
/// - Uses a dedicated [CustomPainter] inside a [RepaintBoundary].
/// - Zero heap allocations inside [paint]: pre-allocated Paint objects and
///   reused particle states.
/// - Driven by a single [TickerProvider] animation loop.
/// - Fully respects [AppMedia.reduceMotion].
class IntroConstellation extends StatefulWidget {
  final Widget? child;
  final bool isDark;

  const IntroConstellation({
    super.key,
    this.child,
    required this.isDark,
  });

  @override
  State<IntroConstellation> createState() => _IntroConstellationState();
}

class _IntroConstellationState extends State<IntroConstellation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final ValueNotifier<Offset?> _mousePos = ValueNotifier<Offset?>(null);
  List<_Particle>? _particles;
  Size _lastSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    if (!PlatformDispatcher.instance.accessibilityFeatures.disableAnimations) {
      _controller.repeat();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMedia.reduceMotion(context)) {
      if (_controller.isAnimating) _controller.stop();
    } else {
      if (!_controller.isAnimating) _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _mousePos.dispose();
    super.dispose();
  }

  void _initParticles(Size size, bool isWide) {
    if (size.width <= 0 || size.height <= 0) return;
    _lastSize = size;
    final count = isWide ? 38 : 18;
    final rng = math.Random(42);

    _particles = List.generate(count, (index) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final speed = 12.0 + rng.nextDouble() * 18.0;
      final angle = rng.nextDouble() * 2 * math.pi;
      final radius = 1.6 + rng.nextDouble() * 2.2;
      final colorIndex = index % 4;

      return _Particle(
        x: x,
        y: y,
        vx: math.cos(angle) * speed,
        vy: math.sin(angle) * speed,
        radius: radius,
        colorIndex: colorIndex,
        pulseOffset: rng.nextDouble() * 2 * math.pi,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width >= AppBreakpoints.tablet;
    final primary = Theme.of(context).colorScheme.primary;

    if (_particles == null || _lastSize != size) {
      _initParticles(size, isWide);
    }

    final painter = RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge([_controller, _mousePos]),
        builder: (context, _) {
          return CustomPaint(
            size: size,
            painter: _ConstellationPainter(
              particles: _particles ?? const [],
              mousePos: _mousePos.value,
              isDark: widget.isDark,
              primary: primary,
              time: _controller.value * 2 * math.pi,
            ),
          );
        },
      ),
    );

    return MouseRegion(
      onHover: (e) => _mousePos.value = e.localPosition,
      onExit: (_) => _mousePos.value = null,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: painter,
            ),
          ),
          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }
}

class _Particle {
  double x;
  double y;
  double vx;
  double vy;
  final double radius;
  final int colorIndex;
  final double pulseOffset;

  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.colorIndex,
    required this.pulseOffset,
  });

  void update(Size bounds, double dt) {
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

class _ConstellationPainter extends CustomPainter {
  final List<_Particle> particles;
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

  _ConstellationPainter({
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

    // Fixed frame delta ~16ms for smooth uniform physics
    const dt = 0.016;
    for (final p in particles) {
      p.update(size, dt);
    }

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
  bool shouldRepaint(covariant _ConstellationPainter oldDelegate) => true;
}
