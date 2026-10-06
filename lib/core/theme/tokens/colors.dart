import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Colors for the "issued credential" identity: polycarbonate card stock,
/// issuer ink, and the gold of a smart-card contact plate.
///
/// Three hues only. Gold marks what can be tapped (the single accent),
/// guilloche teal draws secondary lines and diagrams, and signal red is
/// for errors. Everything else is the ink ramp.
class AppColors {
  AppColors._();

  /// Contact gold: the one accent. Seeds the theme's primary.
  static const Color seed = gold;

  /// Official LinkedIn corporate brand identity color.
  static const Color linkedIn = Color(0xFF0A66C2);

  // Light canvas: the card stock a credential is printed on.
  static const Color paper = Color(0xFFEEF0EC); // polycarbonate
  static const Color cardStock = Color(0xFFF7F8F5); // laminated card face
  static const Color lightSurface = paper;

  // Dark canvas: the same card stock printed in issuer ink, not obsidian.
  static const Color darkSurface = Color(0xFF16243B);
  static const Color darkSurfaceElevated = Color(0xFF1C2C46);
  static const Color darkCard = Color(0xFF1F3049);

  // Hat palette — the six perspective cards. Muted so they read as inks
  // printed on the same stock; 90% alpha so the card gradient shows.
  static const double _hatAlpha = 0.90;
  static Color hatBrown = const Color(0xFF4A3528).withValues(alpha: _hatAlpha);
  static Color hatOrange = const Color(0xFFA4532A).withValues(alpha: _hatAlpha);
  static Color hatAmber = const Color(0xFF8F6B22).withValues(alpha: _hatAlpha);
  static Color hatRed = const Color(0xFF8E3426).withValues(alpha: _hatAlpha);
  static Color hatGreen = const Color(0xFF2F5D4A).withValues(alpha: _hatAlpha);
  static Color hatPurple = const Color(0xFF3F3D6B).withValues(alpha: _hatAlpha);

  // Contact gold — interactive accent.
  static const Color gold = Color(0xFFB08D3C);
  static const Color goldSoft = Color(0xFFE3CB8E); // on ink surfaces
  static const Color goldDeep = Color(0xFF6B5216); // text on paper (6.4:1)

  // Guilloche teal — secondary lines, diagram strokes, positive status.
  static const Color teal = Color(0xFF2F6F6A);
  static const Color tealLight = Color(0xFF7FBDB5); // on ink surfaces
  static const Color tealDeep = Color(0xFF1F5552); // text on paper (7.1:1)

  // Signal red — errors and destructive states only.
  static const Color signal = Color(0xFFB5402B);
  static const Color signalLight = Color(0xFFE58A74); // on ink surfaces
  static const Color signalDeep = Color(0xFF93321F); // text on paper (6.6:1)

  // Dark bg variants — layered issuer-ink tones.
  static const Color darkCanvas = Color(0xFF18273F);
  static const Color darkCanvasElevated = Color(0xFF22344F);
  static const Color darkNight = Color(0xFF152238);

  // The HTML boot screen's background (web/index.html, #boot-loader).
  // Flutter's own loading screen repeats it so the two never flash
  // different backgrounds at each other.
  static const Color bootGlow = ink950;
  static const Color bootEdge = ink950;

  // Modal surface — opaque fill for full-screen dialogs.
  static const Color darkModal = Color(0xFF1A2940);

  // Semantic status tokens. Aliases to the three hues so a rebrand
  // cascades. Use these for indicators instead of raw accents.
  static const Color statusCritical = signal;
  static const Color statusWarn = gold;
  static const Color statusOk = teal;
  static const Color statusInfo = tealLight;

  /// Maps an accent into its accessible deep tone (>5:1 on paper) for
  /// text and icons in light mode.
  static Color toAccessibleLightText(Color color) {
    if (color == gold || color == goldSoft) return goldDeep;
    if (color == teal || color == tealLight) return tealDeep;
    if (color == signal || color == signalLight) return signalDeep;
    // Anything else is deepened just enough rather than passed through.
    return legibleOn(color, ink100, target: 5.0);
  }

  /// Text colour for content sitting on a solid [background]: white when
  /// it clears WCAG AA (4.5:1), otherwise whichever of white and black
  /// reads better.
  static Color onAccent(Color background) {
    final bg = background.withValues(alpha: 1);
    if (contrastRatio(Colors.white, bg) >= 4.5) return Colors.white;
    return contrastRatio(Colors.black, bg) > contrastRatio(Colors.white, bg)
        ? Colors.black
        : Colors.white;
  }

  /// [color] with its lightness moved away from [surface] just far enough
  /// to reach [target] contrast on it; hue and saturation are kept, so the
  /// accent still reads as itself. Unchanged when it already passes.
  static Color legibleOn(Color color, Color surface, {double target = 4.5}) {
    if (contrastRatio(color, surface) >= target) return color;
    final lighten = surface.computeLuminance() < 0.5;
    var hsl = HSLColor.fromColor(color);
    for (var i = 0; i < 100; i++) {
      final next = (hsl.lightness + (lighten ? 0.01 : -0.01)).clamp(0.0, 1.0);
      hsl = hsl.withLightness(next);
      if (contrastRatio(hsl.toColor(), surface) >= target) break;
    }
    return hsl.toColor();
  }

  /// WCAG 2 contrast ratio between two opaque colours (1 to 21).
  static double contrastRatio(Color a, Color b) {
    final la = a.computeLuminance();
    final lb = b.computeLuminance();
    return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
  }

  // Ink ramp: polycarbonate grey-green at the light end, issuer ink blue
  // at the dark end.
  static const Color ink50 = Color(0xFFF7F8F5);
  static const Color ink100 = Color(0xFFEEF0EC);
  static const Color ink200 = Color(0xFFDDE1DA);
  static const Color ink300 = Color(0xFFC9CEC6);
  static const Color ink400 = Color(0xFF959E9B);
  static const Color ink500 = Color(0xFF5E6967);
  static const Color ink600 = Color(0xFF4A5763);
  static const Color ink700 = Color(0xFF34425A);
  static const Color ink800 = Color(0xFF24324A);
  static const Color ink900 = Color(0xFF1B2A41); // issuer ink
  static const Color ink950 = Color(0xFF121D2F);

  // Neutral shadow tokens — `shadowSoft` for resting cards,
  // `shadowMedium` under lifted surfaces. Ink-tinted, never coloured.
  static Color shadowSoft = ink950.withValues(alpha: 0.08);
  static Color shadowMedium = ink950.withValues(alpha: 0.18);
  static Color shadowDeep = ink950.withValues(alpha: 0.36);
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
