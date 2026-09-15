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
  static const Duration xs = Duration(milliseconds: 150);
  static const Duration sm = Duration(milliseconds: 250);
  static const Duration md = Duration(milliseconds: 350);
  static const Duration lg = Duration(milliseconds: 500);

  // Intent-named durations — use these where the numeric scale doesn't
  // fit an established interaction beat. Values chosen from the ad-hoc
  // Duration literals that used to live across pages.
  static const Duration chipHover = Duration(milliseconds: 180); // filter / tab hover
  static const Duration snap = Duration(milliseconds: 200); // page pill / snap-to
  static const Duration switcher = Duration(milliseconds: 280); // AnimatedSwitcher content
  static const Duration cardFlip = Duration(milliseconds: 400); // skill / hat card flip
  static const Duration sectionScroll = Duration(milliseconds: 600); // mobile section jump
  static const Duration entry = Duration(milliseconds: 800); // page-entry stagger
  static const Duration pulse = Duration(milliseconds: 1500); // presence dot breath
  static const Duration wheelResetGap = Duration(milliseconds: 220); // wheel accumulator reset
  static const Duration toast = Duration(milliseconds: 2600); // floating snack lifetime
}

/// Colors. Brand seed + semantic surface tones + hat palette (with overlay alpha baked in).
class AppColors {
  AppColors._();

  static const Color seed = Color(0xFF6366F1); // Indigo

  // Dark surface tones (used by scaffolds/pages)
  static const Color darkSurface = Color(0xFF0F172A); // Slate 900
  static const Color lightSurface = Color(0xFFF8FAFC); // Slate 50

  // Hat palette — 90% alpha (0xE6) so a hint of the card gradient shows through.
  static const int _hatAlpha = 0xE6;
  static Color hatBrown = const Color(0xFF3E2723).withAlpha(_hatAlpha);
  static Color hatOrange = const Color(0xFFE65100).withAlpha(_hatAlpha);
  static Color hatAmber = const Color(0xFFB26A00).withAlpha(_hatAlpha);
  static Color hatRed = const Color(0xFFC62828).withAlpha(_hatAlpha);
  static Color hatGreen = const Color(0xFF1B5E20).withAlpha(_hatAlpha);
  static Color hatPurple = const Color(0xFF4527A0).withAlpha(_hatAlpha);

  // Scrim overlay applied on top of photo backgrounds.
  static Color scrimMedium = Colors.black.withValues(alpha: 0.35);

  // Editorial accent palette — extracted from the magic hex values that
  // were littered across intro / contact / experience / hats pages.
  // Use these instead of writing `Color(0xFFxxxxxx)` inline.
  static const Color accentIndigo = Color(0xFF818CF8);
  static const Color accentIndigoSoft = Color(0xFFB6C9FF);
  static const Color accentIndigoDeep = Color(0xFF6366F1);
  static const Color accentAmber = Color(0xFFFBBF24);
  static const Color accentAmberSoft = Color(0xFFFDE68A);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentSky = Color(0xFF38BDF8);
  static const Color accentSkySoft = Color(0xFF7DD3FC); // Sky 300 hover / soft state
  static const Color accentIndigo600 = Color(0xFF4F46E5); // Indigo 600
  static const Color accentIndigo700 = Color(0xFF4338CA); // Indigo 700
  // Casino / poker-fan gold used on the Hats deck felt border + selection ring.
  static const Color hatGold = Color(0xFFC8A951);

  // Neutral slate palette — every literal below matches the Tailwind
  // slate scale so cross-file greys stay identical.
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
