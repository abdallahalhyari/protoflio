import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';

class PrimaryButtonGradientShell extends StatelessWidget {
  const PrimaryButtonGradientShell({
    super.key,
    required this.containerKey,
    required this.base,
    required this.scheme,
    required this.hover,
    required this.enabled,
    required this.isFocused,
    required this.isPill,
    required this.reduceMotion,
    required this.child,
  });

  final Key containerKey;
  final Color base;
  final ColorScheme scheme;
  final bool hover;
  final bool enabled;
  final bool isFocused;
  final bool isPill;
  final bool reduceMotion;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Flat fill: hover deepens the colour a step, focus draws a ring.
    // No gradient, glow or hover scale.
    final fill = !enabled
        ? base.withValues(alpha: AppAlpha.border)
        : hover
            ? Color.lerp(base, Colors.black, 0.14)!
            : base;
    return AnimatedContainer(
      key: containerKey,
      duration: AppMotion.xs,
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: fill,
        borderRadius:
            BorderRadius.circular(isPill ? AppRadius.pill : AppRadius.sm),
        border: Border.all(
          color: isFocused ? scheme.onSurface : fill,
          width: 2,
        ),
      ),
      child: child,
    );
  }
}
