import 'package:flutter/material.dart';

import '../../../../theme/tokens.dart';

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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton.icon(
          onPressed: onPrev,
          style: OutlinedButton.styleFrom(
            foregroundColor: primary.withValues(alpha: 0.35),
            side: const BorderSide(color: AppColors.hatGold),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            visualDensity: VisualDensity.compact,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: const Icon(Icons.chevron_left, size: 14),
          label: const Text(
            'PREV',
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: AppTypography.editorialSm,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'ROLE 0${selectedIndex + 1} / 0$totalCount',
                style: TextStyle(
                  fontFamily: 'Courier',
                  color: primary,
                  fontSize: AppTypography.editorial,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: onNext,
          style: OutlinedButton.styleFrom(
            foregroundColor: primary.withValues(alpha: 0.35),
            side: const BorderSide(color: AppColors.hatGold),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            visualDensity: VisualDensity.compact,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: const Icon(Icons.chevron_right, size: 14),
          label: const Text(
            'NEXT',
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: AppTypography.editorialSm,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
