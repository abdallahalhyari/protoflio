import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/core/theme/tokens.dart';

/// Empty state placeholder displayed when a skill category filter has no results.
class SkillsEmptyState extends StatelessWidget {
  final VoidCallback onShowAll;

  /// The search text, when a search (not a category) came up empty.
  final String query;

  const SkillsEmptyState({
    super.key,
    required this.onShowAll,
    this.query = '',
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
              isDark ? Colors.white.withValues(alpha: 0.03) : AppColors.ink50,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : AppColors.ink200,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_alt_off_rounded,
              size: 28,
              color: scheme.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              query.trim().isEmpty
                  ? l10n.skillsEmptyTitle
                  : l10n.skillsNoMatch(query.trim()),
              style: TextStyle(
                color: context.onSurface,
                fontSize: AppTypography.body,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: onShowAll,
              child: Text(
                l10n.skillsEmptyShowAll,
                style: const TextStyle(
                  fontSize: AppTypography.label,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
