import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';

class AppSurfaceTheme {
  AppSurfaceTheme._();

  static CardThemeData card(
      Color cardGlassColor, Color glassBorderColor, bool isDark) {
    return CardThemeData(
      color: cardGlassColor,
      elevation: isDark ? 0 : 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: BorderSide(color: glassBorderColor),
      ),
    );
  }

  static DialogThemeData dialog(
      Color cardGlassColor, Color glassBorderColor, bool isDark) {
    return DialogThemeData(
      backgroundColor: cardGlassColor,
      elevation: isDark ? 0 : 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.container),
        side: BorderSide(color: glassBorderColor),
      ),
    );
  }

  static BottomSheetThemeData bottomSheet(Color cardGlassColor, bool isDark) {
    return BottomSheetThemeData(
      backgroundColor: cardGlassColor,
      elevation: isDark ? 0 : 8,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.container)),
      ),
    );
  }

  static ChipThemeData chip(
      TextTheme textTheme, Color glassBorderColor, bool isDark) {
    return ChipThemeData(
      backgroundColor: isDark
          ? Colors.white.withValues(alpha: 0.06)
          : Colors.black.withValues(alpha: 0.04),
      side: BorderSide(color: glassBorderColor),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.chip)),
      labelStyle: textTheme.labelMedium,
    );
  }

  static TooltipThemeData tooltip(bool isDark) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: isDark ? AppColors.slate900 : AppColors.slate800,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      textStyle: const TextStyle(
          color: Colors.white, fontSize: AppTypography.captionSm),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
    );
  }
}
