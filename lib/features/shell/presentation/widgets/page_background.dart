import 'package:flutter/material.dart';

/// The canvas behind every page: plain card stock in the theme's surface
/// colour. No orbs, particles or parallax — the cover's credential card is
/// the only thing on the site that moves on its own.
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
    return ColoredBox(
      color: overlay == null ? surface : Color.alphaBlend(overlay!, surface),
      child: RepaintBoundary(child: child),
    );
  }
}
