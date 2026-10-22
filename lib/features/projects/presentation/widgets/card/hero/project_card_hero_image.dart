import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/projects/domain/entities/project.dart';
import 'package:profile/shared/widgets/retrying_asset_image.dart';

import 'package:profile/features/projects/presentation/widgets/card/hero/project_card_spotlight.dart';

class CardHeroImage extends StatelessWidget {
  const CardHeroImage({
    super.key,
    required this.project,
    required this.scheme,
    required this.isDesktop,
    required this.hovered,
    required this.isDark,
    required this.mousePos,
    required this.caseStudySlug,
  });

  final Project project;
  final ColorScheme scheme;
  final bool isDesktop;
  final bool hovered;
  final bool isDark;
  final ValueNotifier<Offset> mousePos;
  final String? caseStudySlug;

  @override
  Widget build(BuildContext context) {
    final heroTag =
        'project_hero_${caseStudySlug ?? project.name.toLowerCase().replaceAll(' ', '_')}';

    return SizedBox(
      height: isDesktop ? 165 : 130,
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            ValueListenableBuilder<Offset>(
              valueListenable: mousePos,
              builder: (context, pos, child) {
                // True 3D parallax tilt: map local pos to a rotation matrix
                // Card width is ~400, height ~200.
                final rotateX = hovered ? (pos.dy / 200 - 0.5) * -0.1 : 0.0;
                final rotateY = hovered ? (pos.dx / 400 - 0.5) * 0.1 : 0.0;

                final matrix = Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateX(rotateX)
                  ..rotateY(rotateY);

                return Transform(
                  transform: matrix,
                  alignment: FractionalOffset.center,
                  child: child,
                );
              },
              child: AnimatedScale(
                scale: hovered ? 1.15 : 1.0,
                duration: AppMotion.ambient,
                curve: AppMotion.emphasizedDecel,
                child: Hero(
                  tag: heroTag,
                  child: RetryingAssetImage(
                    project.heroImagePath!,
                    fit: BoxFit.cover,
                    cacheWidth: 800,
                    gaplessPlayback: true,
                    // The card names the project in text below; the hero art
                    // is decorative branding, so keep it off the a11y tree.
                    excludeFromSemantics: true,
                  ),
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: hovered ? 1.0 : 0.8,
              duration: AppMotion.cardHover,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.90),
                      Colors.black.withValues(alpha: 0.10),
                    ],
                  ),
                ),
                child: const SizedBox.expand(),
              ),
            ),
            if (hovered)
              CardSpotlightOverlay(
                mousePos: mousePos,
                primary: scheme.primary,
                isDark: isDark,
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 1,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : AppColors.ink200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
