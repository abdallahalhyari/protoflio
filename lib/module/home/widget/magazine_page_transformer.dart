import 'package:flutter/material.dart';

import '../../../theme/tokens.dart';

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

        // Pages fully outside the viewport (1 or more screens away)
        if (position >= 1.0 || position <= -1.0) {
          return const SizedBox.shrink();
        }

        // When page is active and resting
        if (position.abs() < 0.001) {
          return staticChild!;
        }

        // Page is scrolling away (moving up)
        // It fades out and scales down into the background
        if (position > 0.0 && position < 1.0) {
          // Ease progress with M3 decel so the leaving page slows into
          // the background instead of yanking away linearly.
          final double turnProgress =
              AppMotion.emphasizedDecel.transform(position);
          final double scale = 1.0 - (turnProgress * 0.08);
          final double opacity = (1.0 - turnProgress).clamp(0.0, 1.0);

          return Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(0.0, turnProgress * 40.0),
              child: Transform.scale(
                scale: scale,
                child: staticChild!,
              ),
            ),
          );
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
                // Drop shadow cast onto the page below it — tinted with
                // shadowDeep so the transition reads on both light and
                // dark canvases.
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 80,
                  child: IgnorePointer(
                    child: Container(
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
