import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:profile/core/theme/tokens.dart';

class CursorParticle {
  Offset position;
  Offset velocity;
  double life = 1.0;
  final double maxLife;
  final double size;

  CursorParticle({
    required this.position,
    required this.velocity,
    required this.maxLife,
    required this.size,
  });
}

class CustomCursor extends StatefulWidget {
  final Widget child;

  const CustomCursor({super.key, required this.child});

  @override
  State<CustomCursor> createState() => _CustomCursorState();
}

class _CustomCursorState extends State<CustomCursor>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<Offset> _mousePos = ValueNotifier(Offset.zero);
  final List<CursorParticle> _particles = [];
  final ValueNotifier<int> _frame = ValueNotifier(0);
  late final Ticker _ticker;
  final _random = math.Random();
  Offset _lastPos = Offset.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
  }

  void _onTick(Duration elapsed) {
    if (_particles.isEmpty) {
      if (_ticker.isTicking) _ticker.stop();
      return;
    }

    for (int i = _particles.length - 1; i >= 0; i--) {
      final p = _particles[i];
      p.position += p.velocity;
      p.life -= 0.02; // fade speed
      if (p.life <= 0) {
        _particles.removeAt(i);
      }
    }
    _frame.value++;
  }

  void _spawnParticles(Offset pos, Offset delta) {
    final speed = delta.distance.clamp(0.0, 50.0);
    final numParticles = (speed / 5).ceil().clamp(1, 5);

    for (int i = 0; i < numParticles; i++) {
      _particles.add(
        CursorParticle(
          position: pos,
          velocity: Offset(
            -delta.dx * 0.05 + (_random.nextDouble() - 0.5) * 2,
            -delta.dy * 0.05 +
                (_random.nextDouble() - 0.5) * 2 +
                0.5, // slight gravity
          ),
          maxLife: 1.0,
          size: _random.nextDouble() * 4 + 2,
        ),
      );
    }

    if (_particles.length > 60) {
      _particles.removeRange(0, _particles.length - 60);
    }

    if (!_ticker.isTicking) {
      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _mousePos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    final isTouch =
        platform == TargetPlatform.iOS || platform == TargetPlatform.android;

    if (MediaQuery.sizeOf(context).width < AppBreakpoints.tablet || isTouch) {
      return widget.child;
    }

    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;

    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onHover: (e) {
        final next = e.position;
        if ((next - _mousePos.value).distanceSquared < 4) return;

        final delta = next - _lastPos;
        _lastPos = next;
        _mousePos.value = next;

        _spawnParticles(next, delta);
      },
      child: Stack(
        children: [
          RepaintBoundary(
            child: widget.child,
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _frame,
                builder: (context, _) {
                  if (_particles.isEmpty) return const SizedBox.shrink();
                  return CustomPaint(
                    painter:
                        _ParticlePainter(_particles, scheme.primary, isDark),
                  );
                },
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: ValueListenableBuilder<Offset>(
                  valueListenable: _mousePos,
                  builder: (context, pos, _) {
                    return Stack(
                      children: [
                        // Smooth trailing ring
                        TweenAnimationBuilder<Offset>(
                          tween: Tween(begin: pos, end: pos),
                          duration: AppMotion.xs,
                          curve: Curves.easeOutCubic,
                          builder: (context, animatedPos, ringChild) {
                            return Transform.translate(
                              offset: Offset(
                                  animatedPos.dx - 15, animatedPos.dy - 15),
                              child: ringChild,
                            );
                          },
                          child: RepaintBoundary(
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  CustomPaint(
                                    painter: _InvertPainter(),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: scheme.primary
                                            .withValues(alpha: 0.8),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: scheme.primary
                                              .withValues(alpha: 0.2),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Instant dot
                        Transform.translate(
                          offset: Offset(pos.dx - 2, pos.dy - 2),
                          child: RepaintBoundary(
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: scheme.primary,
                                  boxShadow: [
                                    BoxShadow(
                                      color: scheme.primary,
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    )
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<CursorParticle> particles;
  final Color color;
  final bool isDark;

  _ParticlePainter(this.particles, this.color, this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    if (particles.isEmpty) return;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..blendMode = isDark ? BlendMode.plus : BlendMode.overlay;

    for (final p in particles) {
      paint.color = color.withValues(alpha: p.life * (isDark ? 0.6 : 0.4));
      canvas.drawCircle(p.position, p.size * p.life, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) =>
      true; // Updates continuously on tick
}

class _InvertPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..blendMode = BlendMode.difference;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
