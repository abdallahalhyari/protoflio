import 'package:flutter/material.dart';

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

  // Modal & terminal surfaces — denser obsidian for full-screen dialogs
  // (opaque, so no cardGlass see-through) and CLI-styled chrome.
  static const Color darkModal =
      Color(0xFF0C101B); // solid modal fill between darkCanvas + darkNight
  static const Color darkTerminal =
      Color(0xFF090D16); // near-black terminal chrome

  // Semantic status tokens — traffic-light role labels. Aliases to
  // existing accent hues so a rebrand cascades. Use these for indicators
  // (health dots, badges, telemetry chips) instead of raw accents.
  static const Color statusCritical = Color(0xFFEF4444); // red 500
  static const Color statusWarn = accentAmberMid;         // amber 500
  static const Color statusOk = accentGreen;              // emerald 500
  static const Color statusOkLight = accentGreenLight;    // emerald 400
  static const Color statusInfo = accentSky;              // sky 400

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
    if (color == accentAmber ||
        argb == 0xFFFBBF24 ||
        argb == 0xFFF59E0B ||
        argb == 0xFFFDE68A) {
      return accentAmberDeep;
    }
    if (color == accentGreen ||
        color == accentGreenLight ||
        argb == 0xFF10B981 ||
        argb == 0xFF34D399) {
      return accentGreenDeep;
    }
    if (color == accentSky ||
        color == accentSkySoft ||
        argb == 0xFF38BDF8 ||
        argb == 0xFF7DD3FC) {
      return accentSkyDeep;
    }
    if (color == accentCyan ||
        color == accentCyanLight ||
        argb == 0xFF06B6D4 ||
        argb == 0xFF22D3EE) {
      return accentCyanDeep;
    }
    if (color == accentRose ||
        color == accentRoseLight ||
        color == accentRoseSoft ||
        argb == 0xFFF43F5E ||
        argb == 0xFFFB7185 ||
        argb == 0xFFF87171) {
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
    if (color == accentIndigo ||
        color == accentIndigoSoft ||
        argb == 0xFF818CF8 ||
        argb == 0xFFA5B4FC) {
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
  static Color shadowSoft = Colors.black.withValues(alpha: AppAlpha.hover);
  static Color shadowMedium = Colors.black.withValues(alpha: AppAlpha.fill);
  static Color shadowDeep = Colors.black.withValues(alpha: 0.42);
}

/// Semantic alpha tiers for tinted overlays on any color. Names encode
/// *what the overlay is for*, not the numeric value — so a rebrand can
/// tune the ramp centrally.
///
/// Use as `myColor.withValues(alpha: AppAlpha.hover)`. Fine-tuned outlier
/// values (0.045, 0.72, etc.) that the design deliberately calls for
/// stay inline — the scale is for the common case, not every leaf.
class AppAlpha {
  AppAlpha._();

  /// 0.06 — barely-there rim / hairline fill on a canvas.
  static const double whisper = 0.06;

  /// 0.12 — hover state tint / subtle overlay.
  static const double hover = 0.12;

  /// 0.25 — visible fill / backdrop tint / soft shadow layer.
  static const double fill = 0.25;

  /// 0.35 — border tint / focus ring / mid overlay.
  static const double border = 0.35;

  /// 0.65 — prominent text/icon opacity on a matched surface.
  static const double prominent = 0.65;

  /// 0.88 — near-solid overlay for hero fills / opaque glass.
  static const double solid = 0.88;
}
