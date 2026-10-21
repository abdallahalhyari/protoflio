import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/l10n/app_localizations.dart';

/// Shown when a search or category leaves no skills: what happened, what
/// to try instead, and one way back to the full list.
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
    final l10n = AppLocalizations.of(context)!;
    final searched = query.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            searched ? l10n.skillsNoMatch(query.trim()) : l10n.skillsEmptyTitle,
            style: TextStyle(
              color: context.onSurface,
              fontSize: AppTypography.lead,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (searched) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.skillsNoMatchHint,
              style: TextStyle(
                color: context.mutedText,
                fontSize: AppTypography.body,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: onShowAll,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 44),
              alignment: AlignmentDirectional.centerStart,
            ),
            child: Text(l10n.skillsEmptyShowAll),
          ),
        ],
      ),
    );
  }
}
