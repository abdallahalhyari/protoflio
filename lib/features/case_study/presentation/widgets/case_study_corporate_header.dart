import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

import 'package:profile/features/case_study/presentation/widgets/header/case_study_action_pill.dart';
import 'package:profile/features/case_study/presentation/widgets/header/case_study_share_pill.dart';

export 'package:profile/features/case_study/presentation/widgets/header/case_study_share_util.dart';

class CaseStudyCorporateHeader extends StatelessWidget {
  final String company;
  final String websiteUrl;
  final String linkedinUrl;
  final String slug;
  final String title;

  const CaseStudyCorporateHeader({
    super.key,
    required this.company,
    required this.websiteUrl,
    required this.linkedinUrl,
    required this.slug,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Wrap(
        spacing: 10,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          CaseStudyActionPill(
            label: l10n.studyOfficialWebsite,
            tooltip: l10n.studyVisitWebsite(company),
            icon: Icons.language_rounded,
            url: websiteUrl,
            company: company,
            type: 'website',
            scheme: scheme,
            isDark: isDark,
          ),
          CaseStudyActionPill(
            label: l10n.studyCompanyLinkedIn,
            tooltip: l10n.studyViewOnLinkedIn(company),
            isLinkedIn: true,
            url: linkedinUrl,
            company: company,
            type: 'linkedin',
            scheme: scheme,
            isDark: isDark,
          ),
          CaseStudySharePill(
            slug: slug,
            title: title,
            scheme: scheme,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}
