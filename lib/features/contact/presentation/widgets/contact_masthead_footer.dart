import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'package:profile/core/services/analytics_service.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/widgets/spec_sheet_card.dart';

class ContactMastheadFooter extends StatelessWidget {
  const ContactMastheadFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final availabilityGreen = context.greenText;
    final isMobile = AppBreakpoints.isMobile(context);
    final isDark = context.isDarkMode;

    Widget rule() => Expanded(
          child: Container(
            height: 1,
            color: isDark
                ? Colors.white.withValues(alpha: 0.15)
                : AppColors.ink300,
          ),
        );

    Widget block(String label, String value) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: AppTypography.monoFont,
                color: context.mutedText,
                fontSize: AppTypography.label,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: context.onSurface,
                fontSize: AppTypography.label,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        );

    final blocks = [
      block('Primary location', 'Amman, relocating Brno 2027'),
      block('CZ work status', 'Eligible as student, no permit'),
      block('Response SLA', 'Guaranteed within 24 hours'),
      block('Engagement scope', 'Senior roles, advisory'),
    ];

    return Column(
      children: [
        // Trust and identity badge
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : AppColors.ink100,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : AppColors.ink200,
              ),
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              spacing: 6,
              runSpacing: 4,
              children: [
                Icon(Icons.shield_rounded, size: 14, color: availabilityGreen),
                Text(
                  'Verified senior mobile architect, direct communication',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTypography.monoFont,
                    color: context.mutedText,
                    fontSize: AppTypography.label,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Masthead Colophon Rule
        Row(
          children: [
            rule(),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Colophon & dispatch',
                    style: TextStyle(
                      fontFamily: AppTypography.monoFont,
                      color: context.mutedText,
                      fontSize: AppTypography.label,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
            rule(),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (isMobile)
          SpecSheetCard(rows: blocks)
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.02)
                  : AppColors.ink50.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : AppColors.ink200.withValues(alpha: 0.6),
              ),
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.xl,
              runSpacing: AppSpacing.sm,
              children: [
                blocks[0],
                Container(
                  width: 1,
                  height: 28,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.15)
                      : AppColors.ink300,
                ),
                blocks[1],
                Container(
                  width: 1,
                  height: 28,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.15)
                      : AppColors.ink300,
                ),
                blocks[2],
                Container(
                  width: 1,
                  height: 28,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.15)
                      : AppColors.ink300,
                ),
                blocks[3],
              ],
            ),
          ),
        if (kIsWeb) ...[
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: Analytics.reopenConsent,
            child: Text(
              'Analytics preferences',
              style: TextStyle(
                fontFamily: AppTypography.monoFont,
                color: context.subtleText,
                fontSize: AppTypography.label,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

