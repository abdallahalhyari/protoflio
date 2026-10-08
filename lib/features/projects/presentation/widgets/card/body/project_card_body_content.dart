import 'package:flutter/material.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/projects/domain/entities/project.dart';
import 'package:profile/features/projects/presentation/utils/project_copy.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/utils/bidi.dart';
import 'package:profile/shared/widgets/labeled_line.dart';

import 'package:profile/features/projects/presentation/widgets/card/body/project_card_cta.dart';
import 'package:profile/features/projects/presentation/widgets/card/body/project_card_tech_chip.dart';
import 'package:profile/features/projects/presentation/widgets/card/body/project_card_figure_line.dart';
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
    final figure = localizedProjectFigure(loc, project);
    final caseCopy = localizedProjectCase(loc, project);
    final caseStudySlug = CaseStudyRouter.slugForCompany(project.company);
    // Only the fixed-height desktop grid needs clamps; cards that size to
    // content show every line instead of cutting the impact mid-sentence.
    final clampLines = pinFoot ? 3 : null;
    final clampOverflow = pinFoot ? TextOverflow.ellipsis : null;

    final titleBlock = Column(
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (caseCopy != null) ...[
          LabeledLine(
              label: loc.projectLblProblem,
              text: caseCopy.problem,
              maxLines: clampLines),
          LabeledLine(
              label: loc.projectLblSystem,
              text: caseCopy.system,
              maxLines: clampLines),
          LabeledLine(
              label: loc.projectLblRole,
              text: caseCopy.role,
              maxLines: clampLines),
        ] else
          Text(
            ltrContent(context, localizedProjectTagline(loc, project)),
            style: TextStyle(
              color: context.mutedText,
              fontSize: AppTypography.body,
              height: 1.4,
            ),
            maxLines: clampLines,
            overflow: clampOverflow,
          ),
      ],
    );

    final middle = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleBlock,
        if (outcome != null) ...[
          const SizedBox(height: AppSpacing.md),
          CardFigureLine(
            value: figure?.value,
            label: figure?.label ?? outcome,
            scheme: scheme,
            isDark: isDark,
            maxLines: pinFoot ? 3 : null,
          ),
        ],
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (pinFoot)
            // Fixed-height grid: the copy takes whatever room the tags and
            // the call to action leave, clipped rather than overflowing.
            Expanded(
              child: ClipRect(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: middle,
                ),
              ),
            )
          else
            middle,
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
