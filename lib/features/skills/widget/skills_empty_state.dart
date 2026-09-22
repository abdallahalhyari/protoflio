import 'package:flutter/material.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/theme/tokens.dart';

/// Empty state placeholder displayed when a skill category filter has no results.
class SkillsEmptyState extends StatelessWidget {
  final VoidCallback onShowAll;

  const SkillsEmptyState({
    super.key,
    required this.onShowAll,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color:
              isDark ? Colors.white.withValues(alpha: 0.03) : AppColors.slate50,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : AppColors.slate200,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_alt_off_outlined,
              size: 28,
              color: scheme.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.skillsEmptyTitle,
              style: TextStyle(
                color: context.onSurface,
                fontSize: AppTypography.small,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: onShowAll,
              child: Text(
                l10n.skillsEmptyShowAll,
                style: const TextStyle(
                  fontSize: AppTypography.caption,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
