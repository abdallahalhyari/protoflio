import 'package:flutter/material.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
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
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            exp.role.toUpperCase(),
            style: TextStyle(
              color: context.adaptiveAccentText(scheme.primary),
              fontSize: isDesktop ? 14 : 12.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
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
                    label: 'WEBSITE',
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
                    label: 'LINKEDIN',
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
          ...exp.highlights
              .map((h) => HighlightBullet(text: h, scheme: scheme)),
        ],
      ),
    );
  }
}
