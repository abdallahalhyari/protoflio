import 'dart:async';

import 'package:flutter/material.dart';

import '../../../theme/tokens.dart';

class StaggeredSlideUp extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final double yOffset;

  const StaggeredSlideUp({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.yOffset = 40.0,
  });

  @override
  State<StaggeredSlideUp> createState() => _StaggeredSlideUpState();
}

class _StaggeredSlideUpState extends State<StaggeredSlideUp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;
  Timer? _delayedStart;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.lg, // smooth ~800ms
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _slide = Tween<Offset>(begin: Offset(0, widget.yOffset), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _startAnimation();
  }

  void _startAnimation() {
    final startDelay = widget.delay;
    if (startDelay > Duration.zero) {
      _delayedStart = Timer(startDelay, () {
        if (mounted) {
          _controller.forward();
        }
      });
      return;
    }

    if (mounted) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _delayedStart?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return widget.child;
    }
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _slide.value,
          child: Opacity(
            opacity: _opacity.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
