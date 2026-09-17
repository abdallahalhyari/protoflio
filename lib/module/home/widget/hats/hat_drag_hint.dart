import 'package:flutter/material.dart';

import '../../../../theme/tokens.dart';

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
                Icons.back_hand_outlined,
                size: 13,
                color: isDark
                    ? primary.withValues(alpha: 0.35)
                    : primary,
              ),
              const SizedBox(width: 6),
              Text(
                'DRAG THE CARDS · CLICK TO FLIP · SHUFFLE TO RESHAPE',
                style: TextStyle(
                  fontFamily: AppTypography.monoFont,
                  color: isDark
                      ? primary.withValues(alpha: 0.35)
                      : primary,
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
