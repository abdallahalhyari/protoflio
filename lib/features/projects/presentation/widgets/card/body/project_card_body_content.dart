import 'package:flutter/material.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/projects/domain/entities/project.dart';
import 'package:profile/features/projects/presentation/utils/project_copy.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/utils/bidi.dart';

import 'package:profile/features/projects/presentation/widgets/card/body/project_card_cta.dart';
import 'package:profile/features/projects/presentation/widgets/card/body/project_card_tech_chip.dart';
import 'package:profile/features/projects/presentation/widgets/card/body/project_card_outcome_line.dart';

class CardBodyContent extends StatelessWidget {
  const CardBodyContent({
    super.key,
    required this.project,
    required this.scheme,
    required this.isDesktop,
    required this.isHovered,
    required this.isDark,
    required this.pinFoot,
    required this.selectedTech,
    required this.onSelectTech,
    required this.onOpenStudy,
    required this.onFocusChange,
  });

  final Project project;
  final ColorScheme scheme;
  final bool isDesktop;
  final bool isHovered;
  final bool isDark;
  final bool pinFoot;
  final String? selectedTech;
  final ValueChanged<String>? onSelectTech;
  final VoidCallback onOpenStudy;
  final ValueChanged<bool> onFocusChange;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final outcome = localizedProjectOutcome(loc, project);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedDefaultTextStyle(
                duration: AppMotion.snap,
                style: TextStyle(
                  fontFamily: AppTypography.displayFont,
                  color: isHovered
                      ? (isDark
                          ? scheme.primary
                          : AppColors.toAccessibleLightText(scheme.primary))
                      : (context.onSurface),
                  fontSize: isDesktop ? 22 : 18,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
                child: Text(
                  project.name,
                  maxLines: isDesktop ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                ltrContent(context, localizedProjectTagline(loc, project)),
                style: TextStyle(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.7)
                      : AppColors.slate600,
                  fontSize: isDesktop ? 13 : 12,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          if (outcome != null) ...[
            const SizedBox(height: AppSpacing.sm),
            if (pinFoot)
              Flexible(
                child: ClipRect(
                  child: CardOutcomeLine(
                    text: outcome,
                    scheme: scheme,
                    isDark: isDark,
                  ),
                ),
              )
            else
              CardOutcomeLine(
                text: outcome,
                scheme: scheme,
                isDark: isDark,
              ),
          ],
          if (pinFoot) const Spacer(),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              for (final tag in project.stack.take(isDesktop ? 4 : 3))
                CardTechTagChip(
                  tag: tag,
                  isSelected: selectedTech == tag,
                  scheme: scheme,
                  isDark: isDark,
                  onTap: onSelectTech != null
                      ? () {
                          SoundService.instance.playSelection();
                          onSelectTech!(tag);
                        }
                      : null,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ReadCaseStudyCta(
            projectName: project.name,
            scheme: scheme,
            isHovered: isHovered,
            isDesktop: isDesktop,
            isDark: isDark,
            onTap: onOpenStudy,
            onFocusChange: onFocusChange,
          ),
        ],
      ),
    );
  }
}
