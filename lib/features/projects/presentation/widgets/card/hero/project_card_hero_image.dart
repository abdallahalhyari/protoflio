import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/projects/domain/entities/project.dart';
import 'package:profile/shared/widgets/retrying_asset_image.dart';

class CardHeroImage extends StatelessWidget {
  const CardHeroImage({
    super.key,
    required this.project,
    required this.scheme,
    required this.isDesktop,
    required this.isDark,
    required this.caseStudySlug,
  });

  final Project project;
  final ColorScheme scheme;
  final bool isDesktop;
  final bool isDark;
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
            Hero(
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
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.72),
                    Colors.black.withValues(alpha: 0.08),
                  ],
                ),
              ),
              child: const SizedBox.expand(),
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
