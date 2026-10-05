import 'dart:async';

import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';

/// Reusable cascading entrance animation: slide-up + fade-in driven
/// by a visibility trigger. Wraps any widget and accepts a [delayMs]
/// offset for staggered sequencing.
///
/// Respects [AppMedia.reduceMotion] — immediately paints at full
/// opacity with no translation when the user prefers reduced motion.
class StaggeredEntrance extends StatefulWidget {
  final Widget child;
  final bool isVisible;
  final int delayMs;
  final double slideOffset;

  const StaggeredEntrance({
    super.key,
    required this.child,
    required this.isVisible,
    this.delayMs = 0,
    this.slideOffset = 24.0,
  });

  @override
  State<StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<StaggeredEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;
  late final Animation<double> _tilt;
  bool _hasTriggered = false;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.entry,
    );
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _slide = Tween<Offset>(
      begin: Offset(0, widget.slideOffset),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppMotion.emphasizedDecel,
    ));
    _scale = Tween<double>(begin: 0.96, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: AppMotion.emphasizedDecel,
    ));
    _tilt = Tween<double>(begin: 0.05, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: AppMotion.emphasizedDecel,
    ));

    if (widget.isVisible) {
      _trigger();
    }
  }

  @override
  void didUpdateWidget(StaggeredEntrance oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !_hasTriggered) {
      _trigger();
    }
  }

  void _trigger() {
    _hasTriggered = true;
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
    // Skip animation entirely for reduced-motion users.
    if (AppMedia.reduceMotion(context)) {
      return widget.child;
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.bottomCenter,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..translateByDouble(_slide.value.dx, _slide.value.dy, 0.0, 1.0)
              ..scaleByDouble(_scale.value, _scale.value, 1.0, 1.0)
              ..rotateX(_tilt.value),
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
