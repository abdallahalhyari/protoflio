import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/theme/tokens.dart';

/// Top header for the Hats & Perspectives section, including title, subtitle,
/// and desktop deck shuffle/align action buttons.
class HatDeckHeader extends StatelessWidget {
  final bool isMobile;
  final VoidCallback onShuffle;
  final VoidCallback onReset;

  const HatDeckHeader({
    super.key,
    required this.isMobile,
    required this.onShuffle,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 2,
                color: scheme.primary.withValues(alpha: 0.9),
              ),
              const SizedBox(height: 6),
              Text(
                isMobile
                    ? 'FEATURE 06 · 6 ROLES'
                    : 'FEATURE 06 · MULTI-DISCIPLINARY LEADERSHIP',
                style: TextStyle(
                  color: scheme.primary,
                  fontSize: AppTypography.editorial,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'ARCHITECTURAL PERSPECTIVES',
                style: TextStyle(
                  fontFamily: AppTypography.displayFont,
                  color: isDark ? Colors.white : AppColors.slate900,
                  fontSize: isMobile ? 24 : 40,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Six roles a senior engineer switches between',
                style: TextStyle(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.75)
                      : AppColors.slate600,
                  fontSize: isMobile ? 11 : 12.5,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        if (!isMobile)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton.icon(
                onPressed: onShuffle,
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark
                      ? scheme.primary
                      : AppColors.accentSkyDeep,
                  side: BorderSide(
                      color: scheme.primary.withValues(alpha: 0.6)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                ),
                icon: const Icon(
                    Icons.auto_awesome_motion_rounded,
                    size: 15),
                label: Text(loc.spreadAction,
                    style: const TextStyle(
                        fontSize: AppTypography.editorial,
                        fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: AppSpacing.sm),
              OutlinedButton(
                onPressed: onReset,
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white70 : AppColors.slate600,
                  side: BorderSide(
                      color: isDark ? Colors.white24 : AppColors.slate300),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                ),
                child: Text(loc.alignAction,
                    style: const TextStyle(
                        fontSize: AppTypography.editorial,
                        fontWeight: FontWeight.w700)),
              ),
              // Reserve the top-right toggle cluster's width
              const SizedBox(width: 140),
            ],
          ),
      ],
    );
  }
}
