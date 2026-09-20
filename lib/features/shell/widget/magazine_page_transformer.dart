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
          position = (controller.page ?? controller.initialPage.toDouble()) - index;
        }

        // Pages fully outside the viewport (1 or more screens away):
        // Retain them in Offstage + TickerMode(enabled: false) so widgets,
        // elements, and state are preserved without paying GPU raster or CPU tick cost.
        if (position >= 1.0 || position <= -1.0) {
          return Offstage(
            offstage: true,
            child: TickerMode(
              enabled: false,
              child: staticChild!,
            ),
          );
        }

        // When page is active and resting
        if (position.abs() < 0.001) {
          return staticChild!;
        }

        // Page is scrolling away (moving up)
        // It fades out and scales down into the background
        if (position > 0.0 && position < 1.0) {
          final double turnProgress =
              AppMotion.emphasizedDecel.transform(position);
          final double scale = 1.0 - (turnProgress * 0.08);
          final double opacity = (1.0 - turnProgress).clamp(0.0, 1.0);

          Widget transformed = Transform.translate(
            offset: Offset(0.0, turnProgress * 40.0),
            child: Transform.scale(
              scale: scale,
              child: staticChild!,
            ),
          );

          // Only invoke Opacity (which allocates a full-screen saveLayer texture)
          // when opacity is noticeably fractional.
          if (opacity < 0.99) {
            transformed = Opacity(
              opacity: opacity,
              child: transformed,
            );
          }

          return transformed;
        }

        // Incoming page from below
        if (position < 0.0 && position > -1.0) {
          final double emergeProgress =
              AppMotion.emphasizedDecel.transform(-position);

          return Transform.translate(
            offset: Offset(0, emergeProgress * 20.0),
            child: Stack(
              children: [
                staticChild!,
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 80,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.shadowDeep
                                .withValues(alpha: emergeProgress * 0.35),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return staticChild!;
      },
      child: RepaintBoundary(child: child),
    );
  }
}
