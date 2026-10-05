import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/widgets/directional_icon.dart';
import 'package:profile/shared/utils/bidi.dart';

class HatPaginationRow extends StatelessWidget {
  final int selectedIndex;
  final int totalCount;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const HatPaginationRow({
    super.key,
    required this.selectedIndex,
    required this.totalCount,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final l10n = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // The buttons may shrink too (labels scale down): Arabic labels at
        // 2x text on a 320px phone overflowed the row by 8px.
        Flexible(
            child: OutlinedButton.icon(
          onPressed: onPrev,
          style: OutlinedButton.styleFrom(
            // Full-strength accent text (was border-alpha, read as
            // disabled) and a padded 48px hit area around the same visual.
            foregroundColor: context.adaptiveAccentText(primary),
            side: BorderSide(color: AppColors.gold.withValues(alpha: 0.7)),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            visualDensity: VisualDensity.compact,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.padded,
          ),
          icon: const DirIcon(Icons.chevron_left_rounded, size: 14),
          label: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              l10n?.previousAction ?? 'PREV',
              style: const TextStyle(
                fontSize: AppTypography.label,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        )),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                ltrAlways(context, 'ROLE 0${selectedIndex + 1} / 0$totalCount'),
                style: TextStyle(
                  color: primary,
                  fontSize: AppTypography.label,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ),
        Flexible(
            child: OutlinedButton.icon(
          onPressed: onNext,
          style: OutlinedButton.styleFrom(
            // Full-strength accent text (was border-alpha, read as
            // disabled) and a padded 48px hit area around the same visual.
            foregroundColor: context.adaptiveAccentText(primary),
            side: BorderSide(color: AppColors.gold.withValues(alpha: 0.7)),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            visualDensity: VisualDensity.compact,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.padded,
          ),
          icon: const DirIcon(Icons.chevron_right_rounded, size: 14),
          label: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              l10n?.nextAction ?? 'NEXT',
              style: const TextStyle(
                fontSize: AppTypography.label,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        )),
      ],
    );
  }
}
