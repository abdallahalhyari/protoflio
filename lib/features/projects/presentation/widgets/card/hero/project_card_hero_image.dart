import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/projects/domain/entities/project.dart';
import 'package:profile/shared/widgets/retrying_asset_image.dart';

import 'package:profile/features/projects/presentation/widgets/card/hero/project_card_spotlight.dart';
import 'package:profile/features/projects/presentation/widgets/card/hero/project_card_metric_badge.dart';

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
      height: isDesktop ? 175 : 155,
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            ValueListenableBuilder<Offset>(
              valueListenable: mousePos,
              builder: (context, pos, child) {
                // Parallax translation: map local pos to a slight offset
                // Card width is ~400, height ~200. Max pan ~8px.
                final rx = hovered ? (pos.dx / 400 - 0.5) * -16 : 0.0;
                final ry = hovered ? (pos.dy / 200 - 0.5) * -16 : 0.0;

                return Transform.translate(
                  offset: Offset(rx, ry),
                  child: child,
                );
              },
              child: AnimatedScale(
                scale: hovered ? 1.10 : 1.0,
                duration: AppMotion.ambient,
                curve: AppMotion.emphasizedDecel,
                child: Hero(
                  tag: heroTag,
                  child: RetryingAssetImage(
                    project.heroImagePath!,
                    fit: BoxFit.cover,
                    cacheWidth: 800,
                    gaplessPlayback: true,
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
            if (project.metricBadge != null)
              CardMetricBadge(
                text: project.metricBadge!,
                primary: scheme.primary,
              ),
            Positioned(
              left: AppSpacing.md,
              bottom: AppSpacing.md,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.60),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.22),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.business_center_rounded,
                      size: 12,
                      color: isDark ? AppColors.goldSoft : AppColors.gold,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      project.company,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: AppTypography.label,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
