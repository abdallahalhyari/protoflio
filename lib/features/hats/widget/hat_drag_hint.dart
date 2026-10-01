import 'package:flutter/material.dart';
import 'package:profile/theme/surface_tone.dart';

import 'package:profile/theme/tokens.dart';
import 'package:profile/l10n/app_localizations.dart';

class HatDragHint extends StatelessWidget {
  const HatDragHint({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isDark
                ? primary.withValues(alpha: 0.10)
                : primary.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: primary.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.back_hand_rounded,
                size: 13,
                color: context.adaptiveAccentText(primary),
              ),
              const SizedBox(width: 6),
              Text(
                AppLocalizations.of(context)!.uiDragCardsHint,
                style: TextStyle(
                  fontFamily: AppTypography.monoFont,
                  // Full-strength accent: at border opacity this
                  // instruction measured ~2:1 on the dark canvas.
                  color: context.adaptiveAccentText(primary),
                  fontSize: AppTypography.editorial,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
