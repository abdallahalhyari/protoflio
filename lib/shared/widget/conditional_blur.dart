import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:profile/theme/tokens.dart';

/// Wraps `child` in a `BackdropFilter(ImageFilter.blur)` clipped by
/// `borderRadius`, unless the user has requested reduced motion (see
/// [AppMedia.reduceBlur]) — in which case the child renders without the
/// shader pass. Callers stack this over an opaque tinted surface so the
/// fallback still looks intentional.
class ConditionalBlur extends StatelessWidget {
  const ConditionalBlur({
    super.key,
    required this.child,
    this.sigma = 12,
    this.borderRadius,
  });

  final Widget child;
  final double sigma;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    // BackdropFilters on Web (CanvasKit) are extremely expensive when placed
    // over scrolling areas, causing huge frame drops. We bypass it on Web.
    final skip = AppMedia.reduceBlur(context) || kIsWeb;
    Widget content = child;
    if (!skip) {
      content = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: content,
      );
    }
    if (borderRadius != null) {
      content = ClipRRect(borderRadius: borderRadius!, child: content);
    } else if (!skip) {
      content = ClipRect(child: content);
    }
    return content;
  }
}
