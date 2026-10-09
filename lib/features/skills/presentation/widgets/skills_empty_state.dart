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
            horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.03)
              : AppColors.ink50.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : AppColors.ink200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: isDark ? 0.12 : 0.08),
                borderRadius: BorderRadius.circular(AppRadius.chip),
                border: Border.all(
                  color: scheme.primary.withValues(alpha: 0.3),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'DIAGNOSTIC // ZERO_MATCH',
                    style: TextStyle(
                      fontFamily: AppTypography.monoFont,
                      fontSize: AppTypography.label - 2,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: scheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.04)
                    : AppColors.ink100,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : AppColors.ink200,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.filter_alt_off_rounded,
                  size: 26,
                  color: scheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              query.trim().isEmpty
                  ? l10n.skillsEmptyTitle
                  : l10n.skillsNoMatch(query.trim()),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.onSurface,
                fontSize: AppTypography.body,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            TextButton.icon(
              onPressed: onShowAll,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: Text(
                l10n.skillsEmptyShowAll,
                style: const TextStyle(
                  fontSize: AppTypography.label,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
