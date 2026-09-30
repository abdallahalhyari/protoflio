import 'package:flutter/material.dart';
import 'package:profile/theme/tokens.dart';

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
    return AnimatedContainer(
      key: containerKey,
      duration: AppMotion.xs,
      curve: Curves.easeOut,
      transform: Matrix4.identity()
        ..scaleByDouble(
          hover && !reduceMotion ? 1.05 : 1.0,
          hover && !reduceMotion ? 1.05 : 1.0,
          1.0,
          1.0,
        ),
      transformAlignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(isPill ? AppRadius.pill : AppRadius.sm),
        boxShadow: [
          BoxShadow(
            color: base.withValues(alpha: hover ? 0.55 : 0.28),
            blurRadius: hover ? 18 : 10,
            spreadRadius: hover ? 2 : 0,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: !enabled
              ? [
                  base.withValues(alpha: AppAlpha.border),
                  base.withValues(alpha: AppAlpha.fill),
                ]
              : hover
                  ? [
                      Color.lerp(base, scheme.onPrimary, 0.15)!,
                      base,
                    ]
                  : [
                      Color.lerp(base, scheme.onPrimary, 0.08)!,
                      Color.lerp(base, scheme.shadow, 0.12)!,
                    ],
        ),
        border: Border.all(
          color: isFocused
              ? scheme.onPrimary
              : hover
                  ? Color.lerp(base, scheme.onPrimary, 0.40)!
                  : scheme.onPrimary.withValues(alpha: 0.22),
          width: isFocused ? 2 : (hover ? 1.5 : 1),
        ),
      ),
      child: child,
    );
  }
}
