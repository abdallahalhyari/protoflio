import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Full-bleed photo background with an optional color overlay.
///
/// Applies a slow Ken Burns effect (subtle scale + pan) that repeats
/// forever so a static section still feels alive. The animation
/// short-circuits when `MediaQueryData.disableAnimations` is on, in
/// which case the background renders as a plain still image.
class PageBackground extends StatefulWidget {
  final String asset;
  final Widget child;
  final Color? overlay;

  const PageBackground({
    super.key,
    required this.asset,
    required this.child,
    this.overlay,
  });

  @override
  State<PageBackground> createState() => _PageBackgroundState();
}

class _PageBackgroundState extends State<PageBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 30),
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started && !MediaQuery.of(context).disableAnimations) {
      _c.repeat(reverse: true);
      _started = true;
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, child) {
              // Scale 1.05 -> 1.12; pan a few percent on both axes on a
              // sine so the motion doesn't feel mechanical.
              final t = _c.value;
              final scale = 1.05 + 0.07 * t;
              final dx = math.sin(t * math.pi) * 0.03;
              final dy = math.cos(t * math.pi * 0.5) * 0.02;
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..scaleByDouble(scale, scale, scale, 1)
                  ..translateByDouble(dx * 40, dy * 40, 0, 1),
                child: child,
              );
            },
            child: Image.asset(widget.asset, fit: BoxFit.cover),
          ),
        ),
        if (widget.overlay != null)
          Positioned.fill(child: ColoredBox(color: widget.overlay!)),
        Positioned.fill(child: widget.child),
      ],
    );
  }
}
