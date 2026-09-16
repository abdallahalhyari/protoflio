import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'tokens.dart';

/// App-wide light + dark ThemeData composed from tokens in [tokens.dart].
class AppTheme {
  AppTheme._();

  /// Base themes seeded with [AppColors.seed]. The live section-accent
  /// override is applied by `_AccentTheme` in `main.dart` so callers
  /// never need to pass a dynamic seed here.
  static ThemeData light([Color seedColor = AppColors.seed]) => _base(Brightness.light, seedColor);
  static ThemeData dark([Color seedColor = AppColors.seed]) => _base(Brightness.dark, seedColor);

  static ThemeData _base(Brightness brightness, Color seedColor) {
    final isDark = brightness == Brightness.dark;
    final baseScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
      surface: isDark ? AppColors.darkSurface : AppColors.lightSurface,
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
            surface: AppColors.lightSurface,
            onSurface: AppColors.slate900,
          );

    // Focus-visible ring: shows a 2px seed-tinted outline whenever an
    // interactive element gains keyboard focus. Uses WidgetStateProperty
    // so the border only appears in the focused state — mouse/touch users
    // never see it.
    final focusBorder = WidgetStateProperty.resolveWith<BorderSide?>((states) {
      if (states.contains(WidgetState.focused)) {
        return BorderSide(color: scheme.primary, width: 2);
      }
      return null;
    });

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          isDark ? AppColors.darkSurface : AppColors.lightSurface,
      focusColor: scheme.primary.withValues(alpha: 0.24),
      cardTheme: CardThemeData(
        color: isDark ? AppColors.darkCard : Colors.white,
        elevation: isDark ? 0 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.10) : AppColors.slate200,
            width: 1,
          ),
        ),
      ),
      textTheme: ThemeData(brightness: brightness).textTheme.copyWith(
        bodyMedium: TextStyle(
          color: scheme.onSurface,
          fontSize: AppTypography.body,
        ),
        titleMedium: TextStyle(
          color: scheme.onSurface,
          fontSize: AppTypography.title,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: scheme.onSurface,
          fontSize: AppTypography.heading,
          fontWeight: FontWeight.w900,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(side: focusBorder),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(side: focusBorder),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(side: focusBorder),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.focused)) {
              return scheme.primary.withValues(alpha: 0.24);
            }
            return null;
          }),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
