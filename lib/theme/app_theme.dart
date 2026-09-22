import 'package:flutter/material.dart';
import 'tokens.dart';
import 'components/button_theme.dart';
import 'components/input_theme.dart';
import 'components/surface_theme.dart';
import 'components/text_theme.dart';

/// App-wide light + dark ThemeData composed from tokens in [tokens.dart].
class AppTheme {
  AppTheme._();

  /// Base themes seeded with [AppColors.seed]. The live section-accent
  /// override is applied by `_AccentTheme` in `main.dart` so callers
  /// never need to pass a dynamic seed here.
  static final ThemeData _defaultLight =
      _base(Brightness.light, AppColors.seed);
  static final ThemeData _defaultDark = _base(Brightness.dark, AppColors.seed);

  /// Base themes seeded with [AppColors.seed]. The live section-accent
  /// override is applied by `_AccentTheme` in `main.dart` so callers
  /// never need to pass a dynamic seed here.
  static ThemeData light([Color seedColor = AppColors.seed]) =>
      seedColor == AppColors.seed
          ? _defaultLight
          : _base(Brightness.light, seedColor);
  static ThemeData dark([Color seedColor = AppColors.seed]) =>
      seedColor == AppColors.seed
          ? _defaultDark
          : _base(Brightness.dark, seedColor);

  static ThemeData _base(Brightness brightness, Color seedColor) {
    final isDark = brightness == Brightness.dark;
    final dynamicLightSurface = Color.alphaBlend(
      seedColor.withValues(alpha: 0.03),
      Colors.white,
    );

    final baseScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
      surface: isDark ? AppColors.darkSurface : dynamicLightSurface,
    );

    // In dark mode, ColorScheme.fromSeed washes out the primary into a muted tone-80 pastel.
    // We preserve the punchy, luminous seed color with pure white onPrimary (>7:1 contrast).
    final scheme = isDark
        ? baseScheme.copyWith(
            primary: seedColor,
            onPrimary: Colors.white,
            surface: AppColors.darkSurface,
            onSurface: Colors.white,
            surfaceContainer: AppColors.darkCard,
            surfaceContainerHigh: AppColors.darkSurfaceElevated,
          )
        : baseScheme.copyWith(
            surface: dynamicLightSurface,
            onSurface: AppColors.slate900,
          );

    final textTheme = AppTextTheme.build(scheme, isDark);
    final buttonStyle = AppButtonTheme.style(scheme);

    final cardGlassColor = isDark
        ? AppColors.darkCard.withValues(alpha: 0.88)
        : dynamicLightSurface;

    final dividerColor =
        isDark ? Colors.white.withValues(alpha: 0.12) : AppColors.slate200;
    final glassBorderColor =
        isDark ? Colors.white.withValues(alpha: 0.14) : AppColors.slate200;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          isDark ? AppColors.darkSurface : dynamicLightSurface,
      focusColor: scheme.primary.withValues(alpha: 0.24),
      textTheme: textTheme,

      // Delegated to components
      cardTheme: AppSurfaceTheme.card(cardGlassColor, glassBorderColor, isDark),
      dialogTheme:
          AppSurfaceTheme.dialog(cardGlassColor, glassBorderColor, isDark),
      bottomSheetTheme: AppSurfaceTheme.bottomSheet(cardGlassColor, isDark),
      inputDecorationTheme: AppInputTheme.build(scheme, isDark),
      chipTheme: AppSurfaceTheme.chip(textTheme, glassBorderColor, isDark),
      tooltipTheme: AppSurfaceTheme.tooltip(isDark),

      dividerTheme: DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(style: buttonStyle),
      textButtonTheme: TextButtonThemeData(style: buttonStyle),
      elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle),
      iconButtonTheme: AppButtonTheme.iconTheme(scheme),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}
