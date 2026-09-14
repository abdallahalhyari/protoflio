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

  void _startAnimation() async {
    if (widget.delay > Duration.zero) {
      await Future.delayed(widget.delay);
    }
    if (mounted) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
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
