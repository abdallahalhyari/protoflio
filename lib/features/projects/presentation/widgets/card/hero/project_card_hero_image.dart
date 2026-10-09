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
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.20),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: _domainAccent(project.domain, scheme),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _domainShortTag(project.domain),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: AppTypography.label - 2,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.md,
              bottom: AppSpacing.md,
              right: AppSpacing.md,
              child: Align(
                alignment: AlignmentDirectional.bottomStart,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4.5),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.72),
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.40),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.business_center_rounded,
                          size: 13,
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
              ),
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

  Color _domainAccent(String domain, ColorScheme scheme) {
    switch (domain) {
      case 'Healthcare & Smart Cards':
        return AppColors.teal;
      case 'Enterprise HIS & LMS':
        return scheme.primary;
      case 'Fleet & Telematics':
        return AppColors.tealLight;
      case 'M-Commerce & Streaming':
        return AppColors.gold;
      default:
        return scheme.primary;
    }
  }

  String _domainShortTag(String domain) {
    switch (domain) {
      case 'Healthcare & Smart Cards':
        return 'NFC / HEALTH';
      case 'Enterprise HIS & LMS':
        return 'HIS / LMS';
      case 'Fleet & Telematics':
        return 'TELEMATICS';
      case 'M-Commerce & Streaming':
        return 'STREAMING';
      default:
        return domain.toUpperCase();
    }
  }
}
