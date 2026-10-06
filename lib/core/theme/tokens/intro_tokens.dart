import 'package:flutter/painting.dart';

/// The original intro's palette and type steps. The issued-credential
/// identity retired these everywhere else (one accent, seven type steps);
/// the cover keeps its first design, so its values live here and are used
/// by `lib/features/intro` only.
class IntroColors {
  IntroColors._();

  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate900 = Color(0xFF0F172A);

  static const Color accentIndigo = Color(0xFF818CF8);
  static const Color accentIndigo600 = Color(0xFF4F46E5);
  static const Color accentViolet = Color(0xFF8B5CF6);
  static const Color accentVioletLight = Color(0xFFA78BFA);
  static const Color accentSky = Color(0xFF38BDF8);
  static const Color accentSkySoft = Color(0xFF7DD3FC);
  static const Color accentCyanLight = Color(0xFF22D3EE);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentGreenLight = Color(0xFF34D399);
  static const Color accentAmberSoft = Color(0xFFFDE68A);
  static const Color accentAmberBright = Color(0xFFD97706);
  static const Color accentAmberDeep = Color(0xFF92400E);

  static final Color glowIndigo =
      const Color(0xFF6366F1).withValues(alpha: 0.32);
}

/// The original intro's small type steps (below the identity's 12px floor
/// for the cover's meta labels, as the first design set them).
class IntroType {
  IntroType._();

  static const double editorialSm = 9.5;
  static const double micro = 10;
  static const double caption = 11;
  static const double captionSm = 11.5;
  static const double small = 13;
}
