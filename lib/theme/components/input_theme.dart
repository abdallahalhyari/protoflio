import 'package:flutter/material.dart';
import '../tokens.dart';

class AppInputTheme {
  AppInputTheme._();

  static InputDecorationTheme build(ColorScheme scheme, bool isDark) {
    final glassBorderColor =
        isDark ? Colors.white.withValues(alpha: 0.14) : AppColors.slate200;

    return InputDecorationTheme(
      filled: true,
      fillColor: isDark
          ? Colors.white.withValues(alpha: 0.04)
          : Colors.black.withValues(alpha: 0.02),
      contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.smd),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: BorderSide(color: glassBorderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
      hintStyle: TextStyle(
          color: isDark
              ? Colors.white.withValues(alpha: 0.55)
              : AppColors.slate500),
    );
  }
}
