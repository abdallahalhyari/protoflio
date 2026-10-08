import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:profile/shared/utils/hover_reset_offset_controller.dart';
import 'package:profile/core/theme/tokens.dart';

/// Snappy entrance micro-motion that smoothly fades and slides its child into
/// place over 260ms without blocking or delaying page rendering.
///
/// Starts at opacity 0.35 and 12px offset so the layout is instantly visible
/// on frame 1 and quickly snaps to rest with Curves.easeOutCubic.
class SnappyEntrance extends StatefulWidget {
  final Widget child;
  final int delayMs;
  final double yOffset;

  const SnappyEntrance({
    super.key,
    required this.child,
    this.delayMs = 0,
    this.yOffset = 12.0,
  });

  @override
  State<SnappyEntrance> createState() => _SnappyEntranceState();
}

class _SnappyEntranceState extends State<SnappyEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<double> _slide;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.heroEntry,
    );
    // Use M3 emphasizedDecel — the entrance decelerates smoothly into
    // the resting frame instead of clipping to a stop.
    _opacity = Tween<double>(begin: 0.35, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AppMotion.emphasizedDecel),
    );
    _slide = Tween<double>(begin: widget.yOffset, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: AppMotion.emphasizedDecel),
    );

    // Skip the ticker cost entirely when the platform reports reduced
    // motion — build() already returns the child directly in that case.
    if (PlatformDispatcher.instance.accessibilityFeatures.disableAnimations) {
      _controller.value = 1.0;
      return;
    }

    if (widget.delayMs > 0) {
      _delayTimer = Timer(Duration(milliseconds: widget.delayMs), () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return widget.child;
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slide.value),
            child: FadeTransition(
              opacity: _opacity,
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// Subtle cursor parallax motion that applies a gentle 3D tilt and translation
/// to its child based on mouse position.
///
/// Uses ValueNotifier to prevent full-tree widget rebuilds during high-frequency
/// pointer move events, preserving smooth 120 FPS performance.
class HeroParallax extends StatefulWidget {
  final Widget child;
  final double maxTilt;
  final double maxOffset;

  const HeroParallax({
    super.key,
    required this.child,
    this.maxTilt = 0.04, // ~2.3 degrees subtle float
    this.maxOffset = 6.0, // 6px translation
  });

  @override
  State<HeroParallax> createState() => _HeroParallaxState();
}

class _HeroParallaxState extends State<HeroParallax>
    with SingleTickerProviderStateMixin {
  late final _hover = HoverResetOffsetController(
    vsync: this,
    duration: AppMotion.cardHover,
    curve: AppMotion.emphasizedDecel,
  );

  @override
  void dispose() {
    _hover.dispose();
    super.dispose();
  }

  void _onHover(PointerEvent event, Size size) {
    if (kIsWeb && MediaQuery.disableAnimationsOf(context)) return;
    if (size.width == 0 || size.height == 0) return;

    final nx = ((event.localPosition.dx / size.width) - 0.5) * 2.0;
    final ny = ((event.localPosition.dy / size.height) - 0.5) * 2.0;
    _hover.set(Offset(nx.clamp(-1.0, 1.0), ny.clamp(-1.0, 1.0)));
  }

  void _onExit(PointerEvent _) => _hover.animateToZero();

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return widget.child;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        return MouseRegion(
          onHover: (e) => _onHover(e, size),
          onExit: _onExit,
          child: RepaintBoundary(
            child: ValueListenableBuilder<Offset>(
              valueListenable: _hover.offset,
              builder: (context, norm, child) {
                final tx = norm.dx * widget.maxOffset;
                final ty = norm.dy * widget.maxOffset;
                final rotX = -norm.dy * widget.maxTilt;
                final rotY = norm.dx * widget.maxTilt;

                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..translateByDouble(tx, ty, 0.0, 1.0)
                    ..setEntry(3, 2, 0.001) // subtle perspective
                    ..rotateX(rotX)
                    ..rotateY(rotY),
                  child: child,
                );
              },
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

/// One beat of the cover's entrance, played from a shared [animation].
///
/// The cover runs a single scripted sequence: each element takes a slice
/// ([begin]..[end], 0–1) of one controller. With [mask] the child rises
/// out of its own box (a line of type surfacing); otherwise it fades up.
class HeroStep extends StatelessWidget {
  final Animation<double> animation;
  final double begin;
  final double end;
  final bool mask;
  final double rise;
  final Widget child;

  const HeroStep({
    super.key,
    required this.animation,
    required this.begin,
    required this.end,
    required this.child,
    this.mask = false,
    this.rise = 0.25,
  });

  @override
  Widget build(BuildContext context) {
    if (AppMedia.reduceMotion(context)) return child;
    final t = CurvedAnimation(
      parent: animation,
      curve: Interval(begin, end, curve: AppMotion.emphasizedDecel),
    );
    final moving = AnimatedBuilder(
      animation: t,
      child: child,
      builder: (context, child) {
        final v = t.value;
        final lifted = FractionalTranslation(
          translation: Offset(0, mask ? 1 - v : (1 - v) * rise),
          child: child,
        );
        return mask ? lifted : Opacity(opacity: v, child: lifted);
      },
    );
    return mask ? ClipRect(child: moving) : moving;
  }
}
