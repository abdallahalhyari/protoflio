import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/l10n/app_localizations.dart';

const Color kNowAccent = AppColors.accentGreen;

class PeriodBadgeRow extends StatelessWidget {
  const PeriodBadgeRow({
    super.key,
    required this.period,
    required this.isCurrent,
    required this.scheme,
    required this.isDark,
  });

  final String period;
  final bool isCurrent;
  final ColorScheme scheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: Text(
            period.toUpperCase(),
            style: TextStyle(
                color: context.adaptiveAccentText(scheme.primary),
                fontSize: AppTypography.micro,
                fontWeight: FontWeight.w800,
                letterSpacing: 1),
          ),
        ),
        if (isCurrent) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isDark
                  ? kNowAccent.withValues(alpha: 0.15)
                  : AppColors.accentGreenDeep.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppRadius.xs),
              border: Border.all(
                color: isDark
                    ? kNowAccent.withValues(alpha: 0.5)
                    : AppColors.accentGreenDeep.withValues(alpha: 0.45),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.uiLatestDispatch,
              style: TextStyle(
                color: isDark ? kNowAccent : AppColors.accentGreenDeep,
                fontSize: AppTypography.micro,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
        ]
      ],
    );
  }
}
