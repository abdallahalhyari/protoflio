import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

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
                    ? loc.hatsHeaderKickerMobile
                    : loc.hatsHeaderKickerDesktop,
                style: TextStyle(
                  color: context.adaptiveAccentText(scheme.primary),
                  fontSize: AppTypography.label,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                loc.navPerspectives,
                style: TextStyle(
                  fontFamily: AppTypography.displayFont,
                  color: context.onSurface,
                  fontSize: isMobile ? 24 : 40,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                loc.hatsHeaderSubtitle,
                style: TextStyle(
                  color: context.mutedText,
                  fontSize: AppTypography.label,
                  fontStyle: FontStyle.italic,
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
                  foregroundColor: isDark ? scheme.primary : AppColors.tealDeep,
                  side:
                      BorderSide(color: scheme.primary.withValues(alpha: 0.6)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                icon: const Icon(Icons.auto_awesome_motion_rounded, size: 15),
                label: Text(loc.spreadAction,
                    style: const TextStyle(
                        fontSize: AppTypography.label,
                        fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: AppSpacing.sm),
              OutlinedButton(
                onPressed: onReset,
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.mutedText,
                  side: BorderSide(color: context.glassBorderStrong),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                child: Text(loc.alignAction,
                    style: const TextStyle(
                        fontSize: AppTypography.label,
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
