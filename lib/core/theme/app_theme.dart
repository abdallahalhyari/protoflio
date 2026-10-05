import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/core/theme/components/button_theme.dart';
import 'package:profile/core/theme/components/input_theme.dart';
import 'package:profile/core/theme/components/surface_theme.dart';
import 'package:profile/core/theme/components/text_theme.dart';

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

  static Color _shift(Color c, double delta) {
    final hsl = HSLColor.fromColor(c);
    return hsl
        .withHue((hsl.hue + delta) % 360)
        .withSaturation(hsl.saturation.clamp(0.0, 1.0))
        .toColor();
  }

  /// [base] recoloured for a section accent: [seed] becomes the primary
  /// and its hue neighbours the secondary/tertiary.
  ///
  /// The primary doubles as a text colour (eyebrows, links, chip labels),
  /// so each accent is tuned to stay legible on the mode's cards: bright
  /// ones deepen on light surfaces (amber was 1.7:1 on white), mid ones
  /// lift a touch on dark ones (indigo was 4.4:1). Text on the accent as a
  /// fill is then picked for contrast rather than fixed white.
  static ThemeData withAccent(ThemeData base, Color seed) {
    Color legible(Color c) => base.brightness == Brightness.dark
        ? AppColors.legibleOn(c, AppColors.darkCard, target: _accentContrast)
        : AppColors.legibleOn(c, AppColors.slate100, target: _accentContrast);
    final primary = legible(seed);
    final secondary = legible(_shift(seed, 24));
    final tertiary = legible(_shift(seed, -24));
    final scheme = base.colorScheme.copyWith(
      primary: primary,
      onPrimary: AppColors.onAccent(primary),
      secondary: secondary,
      onSecondary: AppColors.onAccent(secondary),
      tertiary: tertiary,
      onTertiary: AppColors.onAccent(tertiary),
      surfaceTint: primary,
    );
    return base.copyWith(colorScheme: scheme);
  }

  /// Contrast an accent keeps against the plain card surface. Above the
  /// 4.5:1 minimum so it still passes on the accent-tinted chips and
  /// badges drawn on those cards.
  static const double _accentContrast = 5.5;

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
    // We preserve the punchy, luminous seed color, with text picked for contrast.
    final scheme = isDark
        ? baseScheme.copyWith(
            primary: seedColor,
            onPrimary: AppColors.onAccent(seedColor),
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
