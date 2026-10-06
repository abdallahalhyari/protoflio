import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/shared/utils/career_facts.dart';

class IntroProofRow extends StatelessWidget {
  final bool isDark;
  final bool isWide;

  const IntroProofRow({
    super.key,
    required this.isDark,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;
    final years = CareerFacts.yearsOfExperience();

    final proofItems = [
      (
        icon: Icons.workspace_premium_rounded,
        label: '$years+ YEARS EXPERIENCE',
      ),
      (
        icon: Icons.phone_android_rounded,
        label: 'PRODUCTION MOBILE APPS',
      ),
      (
        icon: Icons.layers_rounded,
        label: 'FLUTTER + ANDROID',
      ),
      (
        icon: Icons.hub_rounded,
        label: 'COMPLEX SYSTEMS',
      ),
    ];

    Widget proofChip({
      required IconData icon,
      required String label,
    }) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.03)
              : IntroColors.slate100,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : IntroColors.slate200,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isDark
                  ? accent.withValues(alpha: 0.85)
                  : AppColors.toAccessibleLightText(accent),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppTypography.monoFont,
                    fontSize: IntroType.micro,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: context.onSurface
                        .withValues(alpha: isDark ? 0.85 : 0.80),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final item in proofItems)
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * 0.9),
                child: proofChip(
                  icon: item.icon,
                  label: item.label,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
