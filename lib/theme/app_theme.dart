import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tokens.dart';

/// App-wide light + dark ThemeData composed from tokens in [tokens.dart].
class AppTheme {
  AppTheme._();

  static ThemeData light() => _base(Brightness.light);
  static ThemeData dark() => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: brightness,
    );
    final isDark = brightness == Brightness.dark;

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
      textTheme: GoogleFonts.interTextTheme(
        ThemeData(brightness: brightness).textTheme,
      ).copyWith(
        bodyMedium: GoogleFonts.inter(
          color: scheme.onSurface,
          fontSize: AppTypography.body,
        ),
        titleMedium: GoogleFonts.inter(
          color: scheme.onSurface,
          fontSize: AppTypography.title,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: GoogleFonts.inter(
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
