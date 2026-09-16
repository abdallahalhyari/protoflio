import 'package:flutter/material.dart';

/// Spacing scale (4pt base). Use these instead of magic numbers.
class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double smd = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

/// Breakpoints for Responsive Layouts
class AppBreakpoints {
  AppBreakpoints._();
  static const double tablet = 900;
}

/// Runtime-adaptive presentation helpers.
class AppMedia {
  AppMedia._();

  /// Whether to skip expensive backdrop blur (shader passes are the
  /// single biggest paint cost on web). Currently gated on the user's
  /// `Reduce Motion` accessibility flag — a proxy for "prefers cheaper
  /// visuals". Callers should fall back to a solid tinted surface.
  static bool reduceBlur(BuildContext context) {
    return MediaQuery.disableAnimationsOf(context);
  }
}

/// Border-radius scale.
class AppRadius {
  AppRadius._();
  static const double xxs = 2;
  static const double xs = 4;
  static const double chip = 6; // secondary chips / small pills
  static const double sm = 8;
  static const double smd = 10;
  static const double md = 12;
  static const double card = 16;
  static const double lg = 20;
  static const double pill = 999;
}

/// Motion scale — named durations + easing.
class AppMotion {
  AppMotion._();

  // Numeric scale — Material-style tiers.
  static const Duration micro = Duration(milliseconds: 100);
  static const Duration xs = Duration(milliseconds: 150);
  static const Duration sm = Duration(milliseconds: 250);
  static const Duration md = Duration(milliseconds: 350);
  static const Duration lg = Duration(milliseconds: 500);
  static const Duration xl = Duration(milliseconds: 700);

  // Intent-named durations — use these where the numeric scale doesn't
  // fit an established interaction beat. Values chosen from the ad-hoc
  // Duration literals that used to live across pages.
  static const Duration chipHover = Duration(milliseconds: 180); // filter / tab hover
  static const Duration snap = Duration(milliseconds: 200); // page pill / snap-to
  static const Duration cardHover = Duration(milliseconds: 300); // card lift / border pulse
  static const Duration switcher = Duration(milliseconds: 280); // AnimatedSwitcher content
  static const Duration heroEntry = Duration(milliseconds: 260); // intro wordmark
  static const Duration pageTurn = Duration(milliseconds: 380); // desktop wheel page jump
  static const Duration cardFlip = Duration(milliseconds: 400); // skill / hat card flip
  static const Duration sectionScroll = Duration(milliseconds: 600); // mobile section jump
  static const Duration entry = Duration(milliseconds: 800); // page-entry stagger
  static const Duration ambient = Duration(milliseconds: 1400); // long-loop hint bounces
  static const Duration pulse = Duration(milliseconds: 1500); // presence dot breath
  static const Duration wheelResetGap = Duration(milliseconds: 220); // wheel accumulator reset
  static const Duration toast = Duration(milliseconds: 2600); // floating snack lifetime

  // Material 3 emphasized easing — snappier at the top, decelerates
  // gently. Use for state changes the user drove (tap, hover), so the
  // motion feels responsive without whip-crack.
  static const Cubic emphasized = Cubic(0.2, 0.0, 0.0, 1.0);
  static const Cubic emphasizedAccel = Cubic(0.3, 0.0, 0.8, 0.15);
  static const Cubic emphasizedDecel = Cubic(0.05, 0.7, 0.1, 1.0);
  // Standard Material curve — for continuous transitions where the user
  // isn't the trigger (auto-advance, section snap).
  static const Cubic standard = Cubic(0.2, 0.0, 0.0, 1.0);
  // Overshoot spring — for pill-drop / card-catch beats that want a
  // gentle bounce past the target.
  static const Cubic spring = Cubic(0.34, 1.56, 0.64, 1.0);
}

/// Colors. Brand seed + semantic surface tones + hat palette (with overlay alpha baked in).
class AppColors {
  AppColors._();

  static const Color seed = Color(0xFF6366F1); // Vibrant Electric Indigo

  // Deep luxury obsidian dark surface tones (replacing washed slate)
  static const Color darkSurface = Color(0xFF080C14); // Deep Obsidian Midnight
  static const Color darkSurfaceElevated = Color(0xFF0D1322); // Layered Surface
  static const Color darkCard = Color(0xFF111726); // Glass Card Surface
  static const Color lightSurface = Color(0xFFF8FAFC); // Slate 50 Pearl

  // Hat palette — 90% alpha (0xE6) so a hint of the card gradient shows through.
  static const int _hatAlpha = 0xE6;
  static Color hatBrown = const Color(0xFF3E2723).withAlpha(_hatAlpha);
  static Color hatOrange = const Color(0xFFE65100).withAlpha(_hatAlpha);
  static Color hatAmber = const Color(0xFFB26A00).withAlpha(_hatAlpha);
  static Color hatRed = const Color(0xFFC62828).withAlpha(_hatAlpha);
  static Color hatGreen = const Color(0xFF1B5E20).withAlpha(_hatAlpha);
  static Color hatPurple = const Color(0xFF4527A0).withAlpha(_hatAlpha);

  // Scrim overlay applied on top of photo backgrounds (deep obsidian tint)
  static Color scrimMedium = const Color(0xFF080C14).withValues(alpha: 0.88);

  // Curated luminous section accents
  static const Color accentIndigo = Color(0xFF818CF8);
  static const Color accentIndigoSoft = Color(0xFFA5B4FC);
  static const Color accentIndigoDeep = Color(0xFF6366F1);
  static const Color accentViolet = Color(0xFF8B5CF6);
  static const Color accentVioletLight = Color(0xFFA78BFA);
  static const Color accentAmber = Color(0xFFFBBF24);
  static const Color accentAmberSoft = Color(0xFFFDE68A);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentGreenLight = Color(0xFF34D399);
  static const Color accentRose = Color(0xFFF43F5E);
  static const Color accentRoseLight = Color(0xFFFB7185);
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color accentCyanLight = Color(0xFF22D3EE);
  static const Color accentSky = Color(0xFF38BDF8);
  static const Color accentSkySoft = Color(0xFF7DD3FC);
  static const Color accentIndigo600 = Color(0xFF4F46E5);
  static const Color accentIndigo700 = Color(0xFF4338CA);
  static const Color hatGold = Color(0xFFC8A951);

  // Accessible high-contrast Light Mode accent counterparts (>4.5:1 on white/slate50)
  static const Color accentAmberDeep = Color(0xFFB45309); // Amber 700 (5.8:1)
  static const Color accentGreenDeep = Color(0xFF047857); // Emerald 700 (6.1:1)
  static const Color accentSkyDeep = Color(0xFF0284C7); // Sky 700 (4.6:1)
  static const Color accentIndigoDeepText = Color(0xFF4338CA); // Indigo 700 (8.0:1)
  static const Color accentVioletDeep = Color(0xFF6D28D9); // Violet 700 (6.8:1)
  static const Color accentRoseDeep = Color(0xFFBE123C); // Rose 700 (5.9:1)
  static const Color accentCyanDeep = Color(0xFF0E7490); // Cyan 700 (5.5:1)

  /// Returns a luminous pastel tone in dark mode, or a high-contrast deep tone in light mode.
  static Color adaptive({
    required bool isDark,
    required Color dark,
    required Color light,
  }) => isDark ? dark : light;

  // Neutral slate palette
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);
  static const Color slate950 = Color(0xFF080C14);

  // Depth & atmosphere — colored shadows and glow tints layered under
  // hover states. Alpha baked in; drop straight into `boxShadow.color`.
  // Colored shadows read as "premium" where black shadows read as "flat
  // material" — use these on hero cards, primary CTAs, hovered chips.
  static Color glowIndigo = const Color(0xFF6366F1).withValues(alpha: 0.32);
  static Color glowIndigoSoft = const Color(0xFF6366F1).withValues(alpha: 0.16);
  static Color glowAmber = const Color(0xFFFBBF24).withValues(alpha: 0.30);
  static Color glowRose = const Color(0xFFF43F5E).withValues(alpha: 0.28);
  static Color glowCyan = const Color(0xFF06B6D4).withValues(alpha: 0.26);
  static Color glowGreen = const Color(0xFF10B981).withValues(alpha: 0.28);

  // Rim lights — thin bright borders that give glass surfaces a lifted
  // edge under the dark obsidian canvas.
  static Color rimLight = Colors.white.withValues(alpha: 0.10);
  static Color rimLightStrong = Colors.white.withValues(alpha: 0.18);

  // Neutral shadow tokens — use `shadowSoft` for resting cards,
  // `shadowMedium` under hovered / lifted surfaces.
  static Color shadowSoft = Colors.black.withValues(alpha: 0.14);
  static Color shadowMedium = Colors.black.withValues(alpha: 0.28);
  static Color shadowDeep = Colors.black.withValues(alpha: 0.42);
}

/// Typography scale. Sizes align to a modular scale — clamp at call site
/// when responsive.
class AppTypography {
  AppTypography._();

  static const String displayFont = 'Tenada';

  // Editorial microtext — magazine-style tiny labels, kickers, meta chips.
  static const double editorialSm = 9.5;
  static const double editorial = 10.5;

  // Standard typographic steps.
  static const double small = 13;
  static const double body = 14;
  static const double title = 20;
  static const double heading = 28;
}
