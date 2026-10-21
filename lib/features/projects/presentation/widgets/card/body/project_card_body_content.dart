import 'package:flutter/material.dart';
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
    required this.onOpenStudy,
    required this.onFocusChange,
  });

  final Project project;
  final ColorScheme scheme;
  final bool isDesktop;
  final bool isHovered;
  final bool isDark;

  /// Push the "Read case study" row to the bottom of a card that has been
  /// stretched to a grid row's height.
  final bool pinFoot;
  final VoidCallback onOpenStudy;
  final ValueChanged<bool> onFocusChange;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final outcome = localizedProjectOutcome(loc, project);
    final figure = localizedProjectFigure(loc, project);
    final caseCopy = localizedProjectCase(loc, project);
    final caseStudySlug = CaseStudyRouter.slugForCompany(project.company);

    // The case in three lines, in full: nothing on the card is clamped
    // with an ellipsis, because a cut sentence reads as broken.
    Widget dossier() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabeledLine(label: loc.projectLblProblem, text: caseCopy!.problem),
            LabeledLine(label: loc.projectLblSystem, text: caseCopy.system),
            LabeledLine(label: loc.projectLblRole, text: caseCopy.role),
          ],
        );

    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          project.company,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: AppTypography.label + 1,
            fontWeight: FontWeight.w500,
            color: isHovered
                ? (isDark
                    ? scheme.primary
                    : AppColors.toAccessibleLightText(scheme.primary))
                : context.mutedText,
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
            localizedProjectName(loc, project),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final tag in project.stack) CardTechTagChip(tag: tag),
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
            child: dossier(),
          ),
        ] else
          Text(
            ltrContent(context, localizedProjectTagline(loc, project)),
            style: TextStyle(
              color: context.mutedText,
              fontSize: AppTypography.body,
              height: 1.4,
            ),
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
            stacked: !isDesktop,
          ),
        ],
      ],
    );

    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: pinFoot ? MainAxisSize.max : MainAxisSize.min,
      children: [
        middle,
        if (pinFoot) const Spacer(),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: ReadCaseStudyCta(
                projectName: localizedProjectName(loc, project),
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: content,
    );
  }
}
