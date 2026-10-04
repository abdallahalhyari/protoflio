import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/projects/domain/entities/project.dart';

import 'package:profile/features/projects/presentation/widgets/card/hero/project_card_quick_links.dart';

class CardFallbackPlaceholder extends StatelessWidget {
  const CardFallbackPlaceholder({
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
    return SizedBox(
      height: isDesktop ? 175 : 155,
      child: Container(
        color: scheme.primary.withValues(alpha: 0.1),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              project.company.toUpperCase(),
              style: TextStyle(
                fontFamily: AppTypography.monoFont,
                color: isDark
                    ? scheme.primary
                    : AppColors.toAccessibleLightText(scheme.primary),
                fontSize: AppTypography.micro,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            if (project.url != null ||
                project.linkedinUrl != null ||
                caseStudySlug != null)
              CompanyQuickLinks(
                project: project,
                scheme: scheme,
                caseStudySlug: caseStudySlug,
              ),
          ],
        ),
      ),
    );
  }
}
