import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/shell/presentation/widgets/desktop_scroll_interceptor.dart';

/// The desktop page turn, in the vocabulary of the cover's card reader.
///
/// Pages don't slide past each other. Both stay where they are while the
/// pager scrolls, and:
///  * the page below is *scanned in*: revealed from its leading edge by a
///    gold reader line that sweeps across the viewport;
///  * the page above *recedes into the stack*: it sinks back, shrinks a
///    little and dims, like a card dropped onto a pile.
/// Turning backwards plays the same physics in reverse. Reduced motion cuts
/// straight to the page.
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
    final reduceMotion = AppMedia.reduceMotion(context);
    if (reduceMotion) return child;

    final double momentumTease = MomentumTeaseProvider.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, staticChild) {
        double position = 0.0;
        double extent = 0.0;
        if (controller.hasClients &&
            controller.positions.length == 1 &&
            controller.position.haveDimensions) {
          position =
              (controller.page ?? controller.initialPage.toDouble()) - index;
          extent = controller.position.viewportDimension;
        }

        // Pages a full screen or more away: keep state, skip raster/ticks.
        final offscreen = position >= 1.0 || position <= -1.0;

        // Cancel the pager's own scroll so the page holds still; the turn
        // is carried by the reveal and the recede instead.
        var dy = offscreen ? 0.0 : position * extent;
        var scale = 1.0;
        var shade = 0.0;
        var reveal = 1.0; // fraction of this page uncovered (scan-in)
        if (!offscreen && position > 0) {
          final e = AppMotion.emphasizedDecel.transform(position);
          scale = 1 - 0.07 * e;
          dy += 24 * e;
          shade = 0.55 * e;
        } else if (!offscreen && position < 0) {
          final p = 1 + position; // 0 → 1 as it arrives
          reveal = AppMotion.emphasized.transform(p.clamp(0.0, 1.0));
          // A little parallax so the page settles into place as it's read.
          dy += (1 - reveal) * 48;
        } else if (!offscreen && position == 0) {
          dy = -momentumTease;
        }

        // Tree shape must stay identical in every phase: swapping root
        // widget types remounts the page and replays its deferred loads.
        return Offstage(
          offstage: offscreen,
          child: TickerMode(
            enabled: !offscreen,
            // Clip and line live inside the transform: they are in the
            // page's own coordinates once it has been held in place.
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.translationValues(0, dy, 0)
                ..scaleByDouble(scale, scale, 1, 1),
              child: CustomPaint(
                foregroundPainter: _TurnPainter(
                  shade: shade,
                  scan: reveal < 1 ? reveal : null,
                ),
                child: ClipRect(
                  clipper: _ScanClipper(reveal),
                  child: staticChild,
                ),
              ),
            ),
          ),
        );
      },
      child: RepaintBoundary(child: child),
    );
  }
}

/// Uncovers the page from the bottom edge up as [reveal] goes 0 → 1.
class _ScanClipper extends CustomClipper<Rect> {
  const _ScanClipper(this.reveal);

  final double reveal;

  @override
  Rect getClip(Size size) {
    if (reveal >= 1) return Offset.zero & size;
    final top = size.height * (1 - reveal);
    return Rect.fromLTRB(0, top, size.width, size.height);
  }

  @override
  bool shouldReclip(_ScanClipper oldClipper) => oldClipper.reveal != reveal;
}

/// Dims a receding page; draws the gold reader line on the edge of a page
/// being scanned in.
class _TurnPainter extends CustomPainter {
  _TurnPainter({required this.shade, required this.scan});

  final double shade;
  final double? scan;

  static final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    if (shade > 0) {
      _paint
        ..shader = null
        ..maskFilter = null
        ..color = AppColors.ink950.withValues(alpha: shade.clamp(0.0, 1.0));
      canvas.drawRect(Offset.zero & size, _paint);
    }
    final s = scan;
    if (s == null || s <= 0) return;
    final y = size.height * (1 - s);
    // Brightest mid-scan, fading in and out at either end of the turn.
    final strength = math.sin(s * math.pi).clamp(0.0, 1.0);
    _paint
      ..shader = null
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14)
      ..color = AppColors.gold.withValues(alpha: 0.55 * strength);
    canvas.drawRect(Rect.fromLTWH(0, y - 6, size.width, 18), _paint);
    _paint
      ..maskFilter = null
      ..color = AppColors.goldSoft.withValues(alpha: 0.95 * strength);
    canvas.drawRect(Rect.fromLTWH(0, y, size.width, 2), _paint);
  }

  @override
  bool shouldRepaint(_TurnPainter oldDelegate) =>
      oldDelegate.shade != shade || oldDelegate.scan != scan;
}
