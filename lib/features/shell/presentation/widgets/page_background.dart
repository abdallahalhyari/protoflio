import 'package:flutter/material.dart';

import 'package:profile/core/theme/tokens.dart';

/// The canvas behind every page: an ambient, multi-tone stage that renders
/// a subtle background depth in both light and dark modes.
class PageBackground extends StatelessWidget {
  final Widget child;

  /// Optional flat tint laid over the surface (case studies use it to
  /// separate the reading column from the page).
  final Color? overlay;

  const PageBackground({
    super.key,
    required this.child,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = Theme.of(context).scaffoldBackgroundColor;

    final bgGradient = isDark
        ? const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.stageDarkStart,
              AppColors.stageDarkMid,
              AppColors.stageDarkEnd,
            ],
            stops: [0.0, 0.5, 1.0],
          )
        : const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.stageLightStart,
              AppColors.stageLightMid,
              AppColors.stageLightEnd,
            ],
            stops: [0.0, 0.45, 1.0],
          );

    final Widget backgroundWidget = overlay == null
        ? DecoratedBox(
            decoration: BoxDecoration(gradient: bgGradient),
            child: child,
          )
        : ColoredBox(
            color: Color.alphaBlend(overlay!, surface),
            child: child,
          );

    return RepaintBoundary(child: backgroundWidget);
  }
}
