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
  static const double huge = 80;
}

/// Breakpoints for Responsive Layouts
class AppBreakpoints {
  AppBreakpoints._();
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

/// Border-radius scale.
class AppRadius {
  AppRadius._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 20;
  static const double xl = 22;
  static const double pill = 999;
}

/// Motion scale — named durations + easing.
class AppMotion {
  AppMotion._();
  static const Duration xs = Duration(milliseconds: 150);
  static const Duration sm = Duration(milliseconds: 250);
  static const Duration md = Duration(milliseconds: 350);
  static const Duration lg = Duration(milliseconds: 500);
  static const Duration xl = Duration(milliseconds: 700);
  static const Duration xxl = Duration(milliseconds: 900);
  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve emphasized = Curves.easeOutBack;
}

/// Colors. Brand seed + semantic surface tones + hat palette (with overlay alpha baked in).
class AppColors {
  AppColors._();

  static const Color seed = Color(0xFF6366F1); // Indigo

  // Dark surface tones (used by scaffolds/pages)
  static const Color darkSurface = Color(0xFF0F172A); // Slate 900
  static const Color lightSurface = Color(0xFFF8FAFC); // Slate 50

  // Contact link
  static const Color linkOnScrim = Colors.lightBlueAccent;

  // Standard text-scrim shadow — put behind hero titles that sit over photos.
  static const List<Shadow> textScrim = [
    Shadow(color: Colors.black87, blurRadius: 10),
  ];

  // Hat palette — 90% alpha (0xE6) so a hint of the card gradient shows through.
  static const int _hatAlpha = 0xE6;
  static Color hatBrown = const Color(0xFF3E2723).withAlpha(_hatAlpha);
  static Color hatOrange = const Color(0xFFE65100).withAlpha(_hatAlpha);
  static Color hatAmber = const Color(0xFFB26A00).withAlpha(_hatAlpha);
  static Color hatRed = const Color(0xFFC62828).withAlpha(_hatAlpha);
  static Color hatGreen = const Color(0xFF1B5E20).withAlpha(_hatAlpha);
  static Color hatPurple = const Color(0xFF4527A0).withAlpha(_hatAlpha);

  // Scrim overlays applied on top of photo backgrounds.
  static Color scrimLight = Colors.black.withValues(alpha: 0.3);
  static Color scrimMedium = Colors.black.withValues(alpha: 0.35);
  static Color scrimHeavy = Colors.black.withValues(alpha: 0.4);

  // Editorial accent palette — extracted from the magic hex values that
  // were littered across intro / contact / experience / hats pages.
  // Use these instead of writing `Color(0xFFxxxxxx)` inline.
  static const Color accentIndigo = Color(0xFF818CF8);
  static const Color accentIndigoSoft = Color(0xFFB6C9FF);
  static const Color accentIndigoDeep = Color(0xFF6366F1);
  static const Color accentAmber = Color(0xFFFBBF24);
  static const Color accentAmberSoft = Color(0xFFFDE68A);
  static const Color accentCyan = Color(0xFF3EA6D6);
  static const Color accentBlueprintNavy = Color(0xFF0A1930);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentSky = Color(0xFF38BDF8);
}

/// Typography scale. Sizes align to a modular scale — clamp at call site
/// when responsive.
class AppTypography {
  AppTypography._();
  static const double micro = 11;
  static const double caption = 12;
  static const double small = 13;
  static const double body = 14;
  static const double bodyMd = 15;
  static const double bodyLg = 16;
  static const double titleSm = 18;
  static const double title = 20;
  static const double subhead = 24;
  static const double head = 26;
  static const double heading = 28;
  static const double display = 40;
  static const double displayLg = 56;
  static const double hero = 60;
  static const double heroLg = 65;
}
