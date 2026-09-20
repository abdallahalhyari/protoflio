import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:profile/theme/tokens.dart';

class BreathingPulse extends StatefulWidget {
  final Widget child;
  final double minScale;
  final double maxScale;
  final Duration duration;

  const BreathingPulse({
    super.key,
    required this.child,
    this.minScale = 0.98,
    this.maxScale = 1.02,
    this.duration = AppMotion.pulse,
  });

  @override
  State<BreathingPulse> createState() => _BreathingPulseState();
}

class _BreathingPulseState extends State<BreathingPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _scale = Tween<double>(begin: widget.minScale, end: widget.maxScale).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    if (!PlatformDispatcher.instance.accessibilityFeatures.disableAnimations) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return widget.child;
    }
    return ScaleTransition(
      scale: _scale,
      child: widget.child,
    );
  }
}
