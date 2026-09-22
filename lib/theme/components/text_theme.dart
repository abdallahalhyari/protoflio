import 'package:flutter/material.dart';
import '../tokens.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme build(ColorScheme scheme, bool isDark) {
    final baseText = isDark
        ? Typography.material2021().white
        : Typography.material2021().black;

    return baseText.copyWith(
      displayLarge: TextStyle(color: scheme.onSurface, fontSize: AppTypography.displayLg, fontWeight: FontWeight.w900),
      displayMedium: TextStyle(color: scheme.onSurface, fontSize: AppTypography.display, fontWeight: FontWeight.w900),
      displaySmall: TextStyle(color: scheme.onSurface, fontSize: AppTypography.displaySm, fontWeight: FontWeight.w800),
      headlineLarge: TextStyle(color: scheme.onSurface, fontSize: AppTypography.heroSm, fontWeight: FontWeight.w800),
      headlineMedium: TextStyle(color: scheme.onSurface, fontSize: AppTypography.heading, fontWeight: FontWeight.w900),
      headlineSmall: TextStyle(color: scheme.onSurface, fontSize: AppTypography.titleLg, fontWeight: FontWeight.w800),
      titleLarge: TextStyle(color: scheme.onSurface, fontSize: AppTypography.titleMid, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(color: scheme.onSurface, fontSize: AppTypography.title, fontWeight: FontWeight.w700),
      titleSmall: TextStyle(color: scheme.onSurface, fontSize: AppTypography.titleSm, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: scheme.onSurface, fontSize: AppTypography.bodyLg),
      bodyMedium: TextStyle(color: scheme.onSurface, fontSize: AppTypography.body),
      bodySmall: TextStyle(color: scheme.onSurface, fontSize: AppTypography.small),
      labelLarge: TextStyle(color: scheme.onSurface, fontSize: AppTypography.caption, fontWeight: FontWeight.w600, letterSpacing: 0.5),
      labelMedium: TextStyle(color: scheme.onSurface, fontSize: AppTypography.captionSm, fontWeight: FontWeight.w600, letterSpacing: 0.5),
      labelSmall: TextStyle(color: scheme.onSurface, fontSize: AppTypography.micro, fontWeight: FontWeight.w600, letterSpacing: 0.5),
    );
  }
}
