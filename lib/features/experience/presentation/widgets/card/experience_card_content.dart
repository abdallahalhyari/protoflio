import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/experience/domain/entities/experience.dart';
import 'package:profile/l10n/app_localizations.dart';

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
    this.period,
  });

  final Experience exp;
  final ColorScheme scheme;
  final bool isDesktop;
  final bool isCurrent;
  final bool isDark;

  /// The formatted period, shown above the company where there is no
  /// date gutter (mobile). Null on desktop, where the gutter carries it.
  final String? period;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ConstrainedBox(
      // Keeps highlight lines near 80 characters at body size.
      constraints: const BoxConstraints(maxWidth: 620),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (period != null) ...[
            Text(
              period!,
              style: TextStyle(
                color: isCurrent ? context.onSurface : context.mutedText,
                fontSize: AppTypography.label,
                fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 4),
          ],
          Text(
            exp.company,
            style: TextStyle(
              color: context.onSurface,
              fontSize: isDesktop ? 22 : 20,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            exp.role,
            style: TextStyle(
              color: context.mutedText,
              fontSize: AppTypography.body,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (exp.websiteUrl != null || exp.linkedinUrl != null) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (exp.websiteUrl != null)
                  CompanyActionPill(
                    label: l10n.uiWebsite,
                    tooltip: l10n.studyVisitWebsite(exp.company),
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
                    tooltip: l10n.studyViewOnLinkedIn(exp.company),
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
          const SizedBox(height: 14),
          ...exp.highlights.map((h) => HighlightBullet(text: h)),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final tech in _stackForCompany(exp.company))
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: context.divider),
                  ),
                  child: Text(
                    tech,
                    style: TextStyle(
                      color: context.mutedText,
                      fontSize: AppTypography.label,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  static List<String> _stackForCompany(String company) {
    return switch (company) {
      'NatHealth' => const [
          'NFC / ISO-7816',
          'Flutter',
          'JWT Security',
          'WorkManager'
        ],
      'ESKADENIA Software' => const ['Flutter', 'Dart', 'MVVM', 'DevTools'],
      'Solutions Now IT' => const ['Flutter', 'REST APIs', 'Design System'],
      'Future Advanced Internet Solutions' => const [
          'Flutter',
          'Android',
          'REST APIs'
        ],
      _ => const ['Flutter'],
    };
  }
}
