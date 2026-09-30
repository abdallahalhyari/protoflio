import 'package:flutter/material.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/features/projects/domain/entities/project.dart';
import 'package:profile/shared/widget/retrying_asset_image.dart';

import 'package:profile/features/projects/presentation/widgets/card/hero/project_card_spotlight.dart';
import 'package:profile/features/projects/presentation/widgets/card/hero/project_card_metric_badge.dart';
import 'package:profile/features/projects/presentation/widgets/card/hero/project_card_quick_links.dart';

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
    return SizedBox(
      height: isDesktop ? 175 : 155,
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedScale(
              scale: hovered ? 1.08 : 1.0,
              duration: AppMotion.lg,
              curve: AppMotion.emphasizedDecel,
              child: RetryingAssetImage(
                project.heroImagePath!,
                fit: BoxFit.cover,
                gaplessPlayback: true,
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
              child: Text(
                project.company.toUpperCase(),
                style: const TextStyle(
                  fontFamily: AppTypography.monoFont,
                  color: Colors.white,
                  fontSize: AppTypography.micro,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            if (project.url != null ||
                project.linkedinUrl != null ||
                caseStudySlug != null)
              Positioned(
                top: AppSpacing.sm,
                right: AppSpacing.sm,
                child: CompanyQuickLinks(
                  project: project,
                  scheme: scheme,
                  caseStudySlug: caseStudySlug,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
