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
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final maxCopyLines = textScale > 1.15 ? 1 : 2;
    final clampLines = maxCopyLines;
    const clampOverflow = TextOverflow.ellipsis;

    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          project.company.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: AppTypography.monoFont,
            fontSize: AppTypography.label - 1,
            fontWeight: FontWeight.w900,
            color: isHovered
                ? (isDark
                    ? scheme.primary
                    : AppColors.toAccessibleLightText(scheme.primary))
                : context.mutedText,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 5),
        AnimatedDefaultTextStyle(
          duration: AppMotion.snap,
          style: TextStyle(
            fontFamily: AppTypography.displayFont,
            color: isHovered
                ? (isDark
                    ? scheme.primary
                    : AppColors.toAccessibleLightText(scheme.primary))
                : (context.onSurface),
            fontSize: isDesktop ? 26 : 22,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            height: 1.1,
          ),
          child: Text(
            project.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
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
            if (project.stack.length > (isDesktop ? 4 : 3))
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 3.5),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : AppColors.ink100,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : AppColors.ink200,
                  ),
                ),
                child: Text(
                  '+${project.stack.length - (isDesktop ? 4 : 3)}',
                  style: TextStyle(
                    color: context.mutedText,
                    fontSize: AppTypography.label - 2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        if (caseCopy != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.03)
                  : AppColors.ink100.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadius.xs),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : AppColors.ink200,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
              ],
            ),
          ),
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
          const SizedBox(height: 10),
          CardFigureLine(
            value: figure?.value,
            label: figure?.label ?? outcome,
            scheme: scheme,
            isDark: isDark,
            maxLines: pinFoot ? 2 : null,
          ),
        ],
      ],
    );

    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: pinFoot ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (pinFoot)
          Expanded(
            child: ClipRect(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: middle,
              ),
            ),
          )
        else
          ClipRect(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: middle,
            ),
          ),
        const SizedBox(height: AppSpacing.sm),
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
    );

    return ClipRect(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: content,
      ),
    );
  }
}
