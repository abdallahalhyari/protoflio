import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:profile/features/shell/home_controller.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/features/intro/widget/intro_constellation_painter.dart';

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
/// - Driven by a single ticker with time-based motion (same speed at any
///   refresh rate); the painter only draws, it never moves particles.
/// - Runs only while the cover is the section in view.
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
  State<IntroConstellation> createState() => IntroConstellationState();
}

class IntroConstellationState extends State<IntroConstellation>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker(_onTick);
  final ValueNotifier<Offset?> _mousePos = ValueNotifier<Offset?>(null);

  /// Bumped once per tick; repaints the constellation without a rebuild.
  final ValueNotifier<int> _frame = ValueNotifier<int>(0);
  List<Particle>? _particles;
  Size _bounds = Size.zero;
  Duration _lastTick = Duration.zero;
  double _time = 0;

  ValueListenable<int>? _pageIndex;
  bool _reduceMotion = false;

  @visibleForTesting
  List<Offset> get particlePositions =>
      [for (final p in _particles ?? const <Particle>[]) Offset(p.x, p.y)];

  @visibleForTesting
  bool get isAnimating => _ticker.isActive;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = AppMedia.reduceMotion(context);
    final pageIndex = HomeController.maybeOf(context)?.pageIndex;
    if (!identical(pageIndex, _pageIndex)) {
      _pageIndex?.removeListener(_syncRunning);
      _pageIndex = pageIndex?..addListener(_syncRunning);
    }
    _syncRunning();
  }

  /// Animate only while the cover is the section in view. Desktop already
  /// mutes off-screen pages' tickers; the mobile column keeps the cover
  /// mounted after it scrolls away, where it rendered 60 frames a second
  /// for the rest of the visit.
  void _syncRunning() {
    final inView = (_pageIndex?.value ?? 0) == 0;
    final run = inView && !_reduceMotion;
    if (run && !_ticker.isActive) {
      _lastTick = Duration.zero; // a restarted ticker counts from zero
      _ticker.start();
    } else if (!run && _ticker.isActive) {
      _ticker.stop();
    }
  }

  /// Time-based motion: the same speed at 60, 90 or 120 Hz, and no leap
  /// after a dropped frame or a paused stretch.
  void _onTick(Duration elapsed) {
    final dt = ((elapsed - _lastTick).inMicroseconds / 1e6).clamp(0.0, 0.05);
    _lastTick = elapsed;
    _time += dt;
    final particles = _particles;
    if (particles == null) return;
    for (final p in particles) {
      p.update(_bounds, dt, _mousePos.value);
    }
    _frame.value++;
  }

  @override
  void dispose() {
    _pageIndex?.removeListener(_syncRunning);
    _ticker.dispose();
    _mousePos.dispose();
    _frame.dispose();
    super.dispose();
  }

  void _layoutParticles(Size size, bool isWide) {
    if (size.width <= 0 || size.height <= 0) return;
    final previous = _bounds;
    _bounds = size;
    final particles = _particles;
    // Mobile browsers resize the viewport height as the URL bar shows and
    // hides; keep the constellation and fold particles into the new bounds
    // instead of respawning it mid-scroll.
    if (particles != null && previous.width == size.width) {
      for (final p in particles) {
        p.y = p.y.clamp(0.0, size.height);
      }
      return;
    }
    final count = isWide ? 38 : 18;
    final rng = math.Random(42);

    _particles = List.generate(count, (index) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final speed = 12.0 + rng.nextDouble() * 18.0;
      final angle = rng.nextDouble() * 2 * math.pi;
      final radius = 1.6 + rng.nextDouble() * 2.2;
      final colorIndex = index % 4;

      return Particle(
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

    if (_particles == null || _bounds != size) {
      _layoutParticles(size, isWide);
    }

    final painter = RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge([_frame, _mousePos]),
        builder: (context, _) {
          return CustomPaint(
            size: size,
            painter: ConstellationPainter(
              particles: _particles ?? const [],
              mousePos: _mousePos.value,
              isDark: widget.isDark,
              primary: primary,
              // One pulse cycle every 10s, as before.
              time: _time * 2 * math.pi / 10,
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
