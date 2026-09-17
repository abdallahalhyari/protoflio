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

/// Border-radius scale. Mixes tier names (`xxs`-`lg`) with intent names
/// (`chip`, `card`, `pill`). **Prefer intent tokens** when one fits —
/// they encode design decisions and are easier to migrate. Tier tokens
/// remain for one-off geometry.
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

/// Motion scale — named durations + easing. Mixes numeric tiers
/// (`micro`, `xs`, `sm`, ...) with intent-named durations (`cardHover`,
/// `heroEntry`, ...). **Prefer intent tokens** — they express *why*, not
/// *how long*, and let global timing tune without hunting call sites.
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
  static const Duration chipHover =
      Duration(milliseconds: 180); // filter / tab hover
  static const Duration snap =
      Duration(milliseconds: 200); // page pill / snap-to
  static const Duration cardHover =
      Duration(milliseconds: 300); // card lift / border pulse
  static const Duration switcher =
      Duration(milliseconds: 280); // AnimatedSwitcher content
  static const Duration heroEntry =
      Duration(milliseconds: 260); // intro wordmark
  static const Duration pageTurn =
      Duration(milliseconds: 380); // desktop wheel page jump
  static const Duration cardFlip =
      Duration(milliseconds: 400); // skill / hat card flip
  static const Duration sectionScroll =
      Duration(milliseconds: 600); // mobile section jump
  static const Duration entry =
      Duration(milliseconds: 800); // page-entry stagger
  static const Duration ambient =
      Duration(milliseconds: 1400); // long-loop hint bounces
  static const Duration pulse =
      Duration(milliseconds: 1500); // presence dot breath
  static const Duration wheelResetGap =
      Duration(milliseconds: 220); // wheel accumulator reset
  static const Duration toast =
      Duration(milliseconds: 2600); // floating snack lifetime

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

  /// Alias: seed brand color. Kept for semantic clarity when referring to
  /// the primary brand hue in accent contexts (e.g. section indigo).
  /// Same value as [seed] — pick whichever reads clearer at the callsite.
  static const Color brandPrimary = seed;

  /// Official LinkedIn corporate brand identity color.
  static const Color linkedIn = Color(0xFF0A66C2);

  // Deep luxury obsidian dark surface tones (replacing washed slate)
  static const Color darkSurface = Color(0xFF080C14); // Deep Obsidian Midnight
  static const Color darkSurfaceElevated = Color(0xFF0D1322); // Layered Surface
  static const Color darkCard = Color(0xFF111726); // Glass Card Surface
  static const Color lightSurface = Color(0xFFF8FAFC); // Slate 50 Pearl

  // Hat palette — 90% alpha so a hint of the card gradient shows through.
  // Uses `withValues(alpha:)` (M3 style) to stay consistent with the rest
  // of the file — no `withAlpha` mixing.
  static const double _hatAlpha = 0.90;
  static Color hatBrown = const Color(0xFF3E2723).withValues(alpha: _hatAlpha);
  static Color hatOrange = const Color(0xFFE65100).withValues(alpha: _hatAlpha);
  static Color hatAmber = const Color(0xFFB26A00).withValues(alpha: _hatAlpha);
  static Color hatRed = const Color(0xFFC62828).withValues(alpha: _hatAlpha);
  static Color hatGreen = const Color(0xFF1B5E20).withValues(alpha: _hatAlpha);
  static Color hatPurple = const Color(0xFF4527A0).withValues(alpha: _hatAlpha);

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

  // Extended palette — one-off tints reused just enough to name.
  static const Color accentAmberMid =
      Color(0xFFF59E0B); // amber 500 — mid warmth
  static const Color accentAmberBright =
      Color(0xFFD97706); // amber 600 — punchy warm
  static const Color accentPink = Color(0xFFF472B6); // pink 400 — soft accent
  static const Color accentPinkBright =
      Color(0xFFEC4899); // pink 500 — vivid accent
  static const Color accentPinkDeep =
      Color(0xFFBE185D); // pink 700 — high-contrast pink
  static const Color accentVioletMid =
      Color(0xFF7C3AED); // violet 600 — mid violet
  static const Color accentPurpleSoft =
      Color(0xFFC084FC); // purple 400 — soft purple
  static const Color accentRoseSoft = Color(0xFFF87171); // red 400 — soft rose
  // Dark bg variants — layered obsidian tones sub-slate950.
  static const Color darkCanvas =
      Color(0xFF0A0F1A); // between slate950 and midnight
  static const Color darkCanvasElevated =
      Color(0xFF141B2A); // one tier above canvas
  static const Color darkNight =
      Color(0xFF0B101D); // page bg midnight blue-black
  static const Color lightMist =
      Color(0xFFFAFBFC); // pearl white background wash

  // Accessible high-contrast Light Mode accent counterparts (>4.5:1 on white/slate50)
  static const Color accentAmberDeep = Color(0xFFB45309); // Amber 700 (5.8:1)
  static const Color accentGreenDeep = Color(0xFF047857); // Emerald 700 (6.1:1)
  static const Color accentSkyDeep = Color(0xFF0284C7); // Sky 700 (4.6:1)
  static const Color accentIndigoDeepText =
      Color(0xFF4338CA); // Indigo 700 (8.0:1)
  static const Color accentVioletDeep = Color(0xFF6D28D9); // Violet 700 (6.8:1)
  static const Color accentRoseDeep = Color(0xFFBE123C); // Rose 700 (5.9:1)
  static const Color accentCyanDeep = Color(0xFF0E7490); // Cyan 700 (5.5:1)

  /// Returns a luminous pastel tone in dark mode, or a high-contrast deep tone in light mode.
  static Color adaptive({
    required bool isDark,
    required Color dark,
    required Color light,
  }) =>
      isDark ? dark : light;

  /// Maps a vibrant or pastel accent tone into an accessible, high-contrast
  /// deep tone (>4.5:1, typical >5.5:1) for text/icons on white/slate50 in light mode.
  static Color toAccessibleLightText(Color color) {
    final argb = color.toARGB32();
    if (color == accentAmber || argb == 0xFFFBBF24 || argb == 0xFFF59E0B || argb == 0xFFFDE68A) {
      return accentAmberDeep;
    }
    if (color == accentGreen || color == accentGreenLight || argb == 0xFF10B981 || argb == 0xFF34D399) {
      return accentGreenDeep;
    }
    if (color == accentSky || color == accentSkySoft || argb == 0xFF38BDF8 || argb == 0xFF7DD3FC) {
      return accentSkyDeep;
    }
    if (color == accentCyan || color == accentCyanLight || argb == 0xFF06B6D4 || argb == 0xFF22D3EE) {
      return accentCyanDeep;
    }
    if (color == accentRose || color == accentRoseLight || color == accentRoseSoft || argb == 0xFFF43F5E || argb == 0xFFFB7185 || argb == 0xFFF87171) {
      return accentRoseDeep;
    }
    if (color == accentViolet || argb == 0xFF8B5CF6) {
      return accentVioletDeep;
    }
    if (color == accentVioletLight || argb == 0xFFA78BFA) {
      return accentVioletMid;
    }
    if (argb == 0xFFF472B6 || argb == 0xFFEC4899) {
      return accentPinkDeep;
    }
    if (color == accentIndigo || color == accentIndigoSoft || argb == 0xFF818CF8 || argb == 0xFFA5B4FC) {
      return accentIndigoDeepText;
    }
    return color;
  }

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
/// when responsive. Prefer these constants over raw `fontSize:` literals;
/// the 6 named steps cover 95% of cases.
class AppTypography {
  AppTypography._();

  static const String displayFont = 'Tenada';
  static const String monoFont = 'Courier';

  // Editorial microtext — magazine-style tiny labels, kickers, meta chips.
  static const double nano = 8.5; // badge numbers, tiny logo badges
  static const double editorialSm = 9.5;
  static const double editorial = 10.5;

  // Standard typographic steps.
  static const double micro =
      10; // meta labels above chip size, timeline stamps
  static const double captionSm =
      11.5; // fine crop between caption and overline
  static const double caption = 11; // sub-body helper text, chip labels
  static const double overlineTight =
      12.5; // fine crop between overline and small
  static const double overline = 12; // uppercase kickers over headings
  static const double small = 13;
  static const double smallLoose = 13.5; // fine crop between small and body
  static const double body = 14;
  static const double bodyLoose = 14.5; // fine crop between body and subtitle
  static const double bodyLg = 15;
  static const double subtitle = 16;
  static const double titleSm = 18;
  static const double title = 20;
  static const double titleMid = 22;
  static const double titleLg = 24;
  static const double heading = 28;
  static const double displaySm = 36;
  static const double statDisplay = 38;
  static const double display = 40; // full-bleed page titles
  static const double displayLg = 54;
  static const double heroSm = 60;
  static const double hero = 72; // intro wordmark, splash impact text
  static const double watermark = 220; // fitted background display wordmark
}
