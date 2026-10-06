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
import 'package:profile/features/projects/presentation/widgets/card/hero/project_card_quick_links.dart';
import 'package:profile/features/case_study/presentation/pages/case_study_router.dart';

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
    final caseStudySlug = CaseStudyRouter.slugForCompany(project.company);
    // Only the fixed-height desktop grid needs clamps; cards that size to
    // content show every line instead of cutting the impact mid-sentence.
    final clampLines = pinFoot ? 2 : null;
    final clampOverflow = pinFoot ? TextOverflow.ellipsis : null;

    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (project.role != null) ...[
          // A full sentence, so sentence case at caption size: set in
          // 8.5px mono capitals inside a grey box it read as noise.
          Text(
            project.role!,
            maxLines: clampLines,
            overflow: clampOverflow,
            style: TextStyle(
              fontSize: AppTypography.label,
              fontWeight: FontWeight.w600,
              height: 1.35,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.62)
                  : AppColors.ink500,
            ),
          ),
          const SizedBox(height: 6),
        ],
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
        const SizedBox(height: 6),
        Text(
          ltrContent(context, localizedProjectTagline(loc, project)),
          style: TextStyle(
            color: isDark
                ? Colors.white.withValues(alpha: 0.75)
                : AppColors.ink600,
            fontSize: isDesktop ? 13 : 12,
            height: 1.4,
          ),
          maxLines: clampLines,
          overflow: clampOverflow,
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleBlock,
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
                maxLines: null,
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
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ReadCaseStudyCta(
                  projectName: project.name,
                  scheme: scheme,
                  isHovered: isHovered,
                  isDesktop: isDesktop,
                  isDark: isDark,
                  onTap: onOpenStudy,
                  onFocusChange: onFocusChange,
                ),
              ),
              if (project.url != null ||
                  project.linkedinUrl != null ||
                  caseStudySlug != null) ...[
                const SizedBox(width: AppSpacing.sm),
                CompanyQuickLinks(
                  project: project,
                  scheme: scheme,
                  caseStudySlug: caseStudySlug,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
