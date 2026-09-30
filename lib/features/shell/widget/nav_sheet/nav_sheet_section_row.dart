import 'package:flutter/material.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/shared/widget/directional_icon.dart';
import 'package:profile/features/shell/widget/mobile_nav_sheet.dart';

class NavSectionRow extends StatelessWidget {
  const NavSectionRow({
    super.key,
    required this.item,
    required this.isActive,
    required this.isDark,
    required this.onSelect,
  });

  final NavSectionItem item;
  final bool isActive;
  final bool isDark;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final activeColor = isDark
        ? item.accentColor
        : switch (item.accentColor.toARGB32()) {
            0xFF06B6D4 => AppColors.accentSkyDeep,
            0xFF10B981 => AppColors.accentGreenDeep,
            0xFF8B5CF6 => AppColors.accentVioletDeep,
            0xFFFBBF24 => AppColors.accentAmberDeep,
            0xFFF43F5E => AppColors.accentRoseDeep,
            _ => item.accentColor,
          };

    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: AnimatedContainer(
        duration: AppMotion.chipHover,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? item.accentColor.withValues(alpha: isDark ? 0.18 : 0.12)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : AppColors.slate50),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isActive
                ? activeColor.withValues(alpha: isDark ? 0.6 : 0.55)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.07)
                    : AppColors.slate200),
            width: isActive ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            NumberBadge(
              number: item.number,
              isActive: isActive,
              accentColor: item.accentColor,
              isDark: isDark,
            ),
            const SizedBox(width: 12),
            Icon(
              item.icon,
              size: 18,
              color: isActive
                  ? activeColor
                  : (isDark ? Colors.white60 : AppColors.slate500),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      color: isActive
                          ? (context.onSurface)
                          : (isDark
                              ? Colors.white.withValues(alpha: 0.85)
                              : AppColors.slate800),
                      fontSize: AppTypography.small,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      color: isActive
                          ? item.accentColor.withValues(alpha: 0.9)
                          : (isDark ? Colors.white38 : AppColors.slate500),
                      fontSize: AppTypography.editorial,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Semantics(
              button: true,
              label: 'Copy link to ${item.title}',
              child: Tooltip(
                message: 'Copy link',
                child: InkResponse(
                  radius: 18,
                  onTap: () => MobileNavSheet.copySectionLink(
                    context,
                    item,
                    isDark: isDark,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.link_rounded,
                      size: 16,
                      color: isDark ? Colors.white38 : AppColors.slate400,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            if (isActive)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: item.accentColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: item.accentColor.withValues(alpha: 0.6),
                      blurRadius: 8,
                    ),
                  ],
                ),
              )
            else
              DirIcon(
                Icons.chevron_right_rounded,
                size: 16,
                color: isDark ? Colors.white24 : AppColors.slate400,
              ),
          ],
        ),
      ),
    );
  }
}

class NumberBadge extends StatelessWidget {
  const NumberBadge({
    super.key,
    required this.number,
    required this.isActive,
    required this.accentColor,
    required this.isDark,
  });

  final String number;
  final bool isActive;
  final Color accentColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isActive
            ? accentColor
            : (isDark
                ? Colors.white.withValues(alpha: 0.08)
                : AppColors.slate200),
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            color: isActive ? Colors.black : (context.mutedText),
            fontSize: AppTypography.caption,
            fontWeight: FontWeight.w900,
            fontFamily: AppTypography.monoFont,
          ),
        ),
      ),
    );
  }
}
