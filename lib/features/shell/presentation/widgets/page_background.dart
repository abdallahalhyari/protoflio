import 'package:flutter/material.dart';

/// The canvas behind every page: polycarbonate card stock in the theme's surface
/// colour with a subtle radial ambient mesh glow driven by the active section primary accent.
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
    final surface = Theme.of(context).scaffoldBackgroundColor;
    final primary = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        overlay == null ? surface : Color.alphaBlend(overlay!, surface);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: baseColor,
        gradient: RadialGradient(
          center: const Alignment(0.0, -0.6),
          radius: 1.25,
          colors: [
            primary.withValues(alpha: isDark ? 0.08 : 0.04),
            baseColor,
          ],
          stops: const [0.0, 1.0],
        ),
      ),
      child: RepaintBoundary(child: child),
    );
  }
}
