import 'package:flutter/material.dart';

import '../../../../theme/tokens.dart';
import '../../data/hats_data.dart';

class HatRolePills extends StatelessWidget {
  final int selectedIndex;
  final bool isDesktop;
  final ValueChanged<int> onSelectRole;

  const HatRolePills({
    super.key,
    required this.selectedIndex,
    required this.isDesktop,
    required this.onSelectRole,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;

    return Wrap(
      spacing: 6,
      runSpacing: 5,
      children: [
        for (int i = 0; i < kHats.length; i++)
          InkWell(
            onTap: () => onSelectRole(i),
            borderRadius: BorderRadius.circular(AppRadius.chip),
            child: AnimatedContainer(
              duration: AppMotion.chipHover,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 9 : 7,
                vertical: isDesktop ? 4 : 3,
              ),
              decoration: BoxDecoration(
                color: selectedIndex == i
                    ? AppColors.hatGold.withValues(alpha: 0.28)
                    : (isDark
                        ? Colors.black.withValues(alpha: 0.3)
                        : Colors.white.withValues(alpha: 0.85)),
                borderRadius: BorderRadius.circular(AppRadius.chip),
                border: Border.all(
                  color: selectedIndex == i
                      ? primary
                      : (isDark
                          ? AppColors.hatGold.withValues(alpha: 0.4)
                          : AppColors.slate300),
                  width: selectedIndex == i ? 1.6 : 1.0,
                ),
                boxShadow: selectedIndex == i
                    ? [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: kHats[i].color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '0${i + 1} ${kHats[i].title.toUpperCase()}',
                    style: TextStyle(
                      fontFamily: 'Courier',
                      color: selectedIndex == i
                          ? (isDark ? Colors.white : AppColors.slate900)
                          : (isDark ? Colors.white70 : AppColors.slate700),
                      fontSize: isDesktop ? 10.0 : 8.5,
                      fontWeight: selectedIndex == i
                          ? FontWeight.w900
                          : FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
