import 'package:flutter/material.dart';

import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/shell/presentation/widgets/desktop_scroll_interceptor.dart';

class MagazinePageTransformer extends StatelessWidget {
  final Widget child;
  final PageController controller;
  final int index;

  const MagazinePageTransformer({
    super.key,
    required this.child,
    required this.controller,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);

    if (reduceMotion) {
      return child;
    }

    // Read the momentum tease value which represents accumulated wheel scroll before a page turn
    final double momentumTease = MomentumTeaseProvider.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, staticChild) {
        double position = 0.0;
        if (controller.hasClients &&
            controller.positions.length == 1 &&
            controller.position.haveDimensions) {
          position =
              (controller.page ?? controller.initialPage.toDouble()) - index;
        }

        // Pages fully outside the viewport (1 or more screens away):
        // Offstage + TickerMode(enabled: false) keeps widgets, elements, and
        // state alive without paying GPU raster or CPU tick cost.
        final offscreen = position >= 1.0 || position <= -1.0;

        double dy = 0.0;
        double scale = 1.0;
        double shade = 0.0;
        double rotateX = 0.0;
        if (!offscreen && position > 0.0) {
          // Page is scrolling away (moving up) — drops back into the viewport
          // like a physical card, stacking underneath the next one.
          final turnProgress = AppMotion.emphasizedDecel.transform(position);
          dy = turnProgress * -80.0; // Smooth parallax shift
          scale = 1.0 - (turnProgress * 0.08); // Subtle depth scale
          rotateX = turnProgress * -0.08; // Gentle 3D perspective pitch tilt
          shade = turnProgress * 0.55; // Ambient vignette as it recedes
        } else if (!offscreen && position < 0.0) {
          // Incoming page sweeping from below with elevated tactile feel
          final emergeProgress = AppMotion.emphasizedDecel.transform(-position);
          dy = emergeProgress * 120.0; // Controlled entry sweep
          scale = 1.0 -
              (emergeProgress *
                  0.03); // Natural card entrance bloom (0.97 -> 1.0)
          rotateX = emergeProgress * 0.04; // Smooth leveling tilt
          shade = emergeProgress * 0.4; // Top edge cast shadow on entry
        } else if (!offscreen && position == 0.0) {
          // Current page: apply elastic momentum tease with micro-pitch
          dy = -momentumTease;
          if (momentumTease != 0.0) {
            rotateX = (momentumTease / 100.0).clamp(-0.03, 0.03) * -1.0;
          }
        }

        // The widget tree shape must stay identical across every phase —
        // swapping root widget types (bare child ↔ Transform ↔ Offstage)
        // makes Flutter unmount and remount the whole page on each turn,
        // replaying deferred-load placeholders and entrance animations
        // and defeating AutomaticKeepAlive.
        return Offstage(
          offstage: offscreen,
          child: TickerMode(
            enabled: !offscreen,
            child: Transform(
              alignment: Alignment.topCenter, // rotate around the top edge
              transform: Matrix4.translationValues(0.0, dy, 0.0)
                ..setEntry(3, 2, 0.0008) // refined 3D perspective
                ..scaleByDouble(scale, scale, 1.0, 1.0)
                ..rotateX(rotateX),
              child: CustomPaint(
                foregroundPainter: _PageDimmerPainter(
                  shade,
                  topShadowOnly: position < 0.0,
                ),
                child: staticChild,
              ),
            ),
          ),
        );
      },
      child: RepaintBoundary(child: child),
    );
  }
}

class _PageDimmerPainter extends CustomPainter {
  _PageDimmerPainter(this.alpha, {this.topShadowOnly = false});

  final double alpha;
  final bool topShadowOnly;

  static final Paint _dimmerPaint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    if (alpha <= 0.0) return;

    if (topShadowOnly) {
      final rect = Rect.fromLTWH(0, 0, size.width, 120);
      _dimmerPaint
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.shadowDeep.withValues(alpha: alpha),
            Colors.transparent,
          ],
        ).createShader(rect)
        ..color = Colors.white;
      canvas.drawRect(rect, _dimmerPaint);
    } else {
      // Full page dim for pages receding into the background
      final rect = Rect.fromLTWH(0, 0, size.width, size.height);
      _dimmerPaint
        ..shader = null
        ..color = Colors.black.withValues(alpha: alpha.clamp(0.0, 1.0));
      canvas.drawRect(rect, _dimmerPaint);
    }
  }

  @override
  bool shouldRepaint(_PageDimmerPainter oldDelegate) =>
      oldDelegate.alpha != alpha || oldDelegate.topShadowOnly != topShadowOnly;
}
