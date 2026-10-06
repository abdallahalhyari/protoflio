import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';

/// Material text roles mapped onto the seven-step scale. Weight carries
/// hierarchy; nothing is tracked out or set in capitals by the theme.
class AppTextTheme {
  AppTextTheme._();

  static TextTheme build(ColorScheme scheme, bool isDark) {
    final baseText = isDark
        ? Typography.material2021().white
        : Typography.material2021().black;

    TextStyle style(double size, FontWeight weight, {double height = 1.45}) =>
        TextStyle(
          color: scheme.onSurface,
          fontSize: size,
          fontWeight: weight,
          height: height,
          letterSpacing: 0,
        );

    return baseText.copyWith(
      displayLarge: style(AppTypography.hero, FontWeight.w600, height: 1.05),
      displayMedium: style(AppTypography.display, FontWeight.w600, height: 1.1),
      displaySmall: style(AppTypography.heading, FontWeight.w600, height: 1.15),
      headlineLarge: style(AppTypography.display, FontWeight.w600, height: 1.1),
      headlineMedium:
          style(AppTypography.heading, FontWeight.w600, height: 1.15),
      headlineSmall: style(AppTypography.title, FontWeight.w600, height: 1.25),
      titleLarge: style(AppTypography.title, FontWeight.w600, height: 1.25),
      titleMedium: style(AppTypography.lead, FontWeight.w600, height: 1.35),
      titleSmall: style(AppTypography.body, FontWeight.w600, height: 1.4),
      bodyLarge: style(AppTypography.lead, FontWeight.w400, height: 1.55),
      bodyMedium: style(AppTypography.body, FontWeight.w400, height: 1.55),
      bodySmall: style(AppTypography.label, FontWeight.w400, height: 1.5),
      labelLarge: style(AppTypography.body, FontWeight.w500, height: 1.2),
      labelMedium: style(AppTypography.label, FontWeight.w500, height: 1.2),
      labelSmall: style(AppTypography.label, FontWeight.w500, height: 1.2),
    );
  }
}
