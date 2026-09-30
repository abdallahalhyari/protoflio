import 'package:flutter/material.dart';
import 'package:profile/theme/tokens.dart';

class HoverScale extends StatefulWidget {
  final Widget child;
  const HoverScale({super.key, required this.child});

  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.3 : 1.0,
        duration: AppMotion.snap,
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
