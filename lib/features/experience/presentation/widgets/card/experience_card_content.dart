import 'package:flutter/material.dart';
import 'package:profile/features/projects/presentation/utils/project_copy.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/widgets/labeled_line.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/experience/domain/entities/experience.dart';

import 'package:profile/features/experience/presentation/widgets/card/experience_card_period_badge.dart';
import 'package:profile/features/experience/presentation/widgets/card/experience_card_company_action_pill.dart';
import 'package:profile/features/experience/presentation/widgets/card/experience_card_highlight_bullet.dart';

class CardContent extends StatelessWidget {
  const CardContent({
    super.key,
    required this.exp,
    required this.scheme,
    required this.isDesktop,
    required this.isCurrent,
    required this.isDark,
  });

  final Experience exp;
  final ColorScheme scheme;
  final bool isDesktop;
  final bool isCurrent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final caseCopy =
        loc == null ? null : localizedCompanyCase(loc, exp.company);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PeriodBadgeRow(
            period: exp.period,
            isCurrent: isCurrent,
            scheme: scheme,
            isDark: isDark,
          ),
          const SizedBox(height: 14),
          Text(
            exp.company,
            style: TextStyle(
              fontFamily: AppTypography.displayFont,
              color: scheme.onSurface,
              fontSize: isDesktop ? 28 : 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            exp.role,
            style: TextStyle(
              color: context.adaptiveAccentText(scheme.primary),
              fontSize: isDesktop ? 14 : 12.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (exp.websiteUrl != null || exp.linkedinUrl != null) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (exp.websiteUrl != null)
                  CompanyActionPill(
                    label: 'Website',
                    tooltip: 'Visit ${exp.company} official website',
                    icon: Icons.language_rounded,
                    url: exp.websiteUrl!,
                    company: exp.company,
                    type: 'website',
                    scheme: scheme,
                    isDark: isDark,
                  ),
                if (exp.linkedinUrl != null)
                  CompanyActionPill(
                    label: 'LinkedIn',
                    tooltip: 'View ${exp.company} on LinkedIn',
                    isLinkedIn: true,
                    url: exp.linkedinUrl!,
                    company: exp.company,
                    type: 'linkedin',
                    scheme: scheme,
                    isDark: isDark,
                  ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          if (loc != null && caseCopy != null) ...[
            LabeledLine(label: loc.expLblChallenge, text: caseCopy.challenge),
            LabeledLine(label: loc.expLblImpact, text: caseCopy.impact),
            const SizedBox(height: 8),
          ],
          ...exp.highlights
              .map((h) => HighlightBullet(text: h, scheme: scheme)),
        ],
      ),
    );
  }
}
