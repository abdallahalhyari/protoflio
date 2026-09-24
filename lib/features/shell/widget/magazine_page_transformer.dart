import 'package:flutter/material.dart';

import 'package:profile/theme/tokens.dart';

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
        if (!offscreen && position > 0.0) {
          // Page is scrolling away (moving up) — scales down into the
          // background.
          final turnProgress = AppMotion.emphasizedDecel.transform(position);
          dy = turnProgress * 40.0;
          scale = 1.0 - (turnProgress * 0.08);
        } else if (!offscreen && position < 0.0) {
          // Incoming page from below, with a soft shadow on its top edge.
          final emergeProgress = AppMotion.emphasizedDecel.transform(-position);
          dy = emergeProgress * 20.0;
          shade = emergeProgress * 0.35;
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
              alignment: Alignment.center,
              transform: Matrix4.translationValues(0.0, dy, 0.0)
                ..scaleByDouble(scale, scale, 1.0, 1.0),
              child: CustomPaint(
                foregroundPainter: _TopShadePainter(shade),
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

class _TopShadePainter extends CustomPainter {
  _TopShadePainter(this.alpha);

  final double alpha;

  static const double _height = 80;

  @override
  void paint(Canvas canvas, Size size) {
    if (alpha <= 0.0) return;
    final rect = Rect.fromLTWH(0, 0, size.width, _height);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.shadowDeep.withValues(alpha: alpha),
            Colors.transparent,
          ],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_TopShadePainter oldDelegate) =>
      oldDelegate.alpha != alpha;
}
