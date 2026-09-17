import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/tokens.dart';

class ThemeController {
  ThemeController._();

  static const String _prefsKey = 'themeMode';

  static final ValueNotifier<ThemeMode> mode =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  static final ValueNotifier<Color> seedColor =
      ValueNotifier<Color>(AppColors.seed);

  static Color get activeAccent => seedColor.value;

  static const String _customAccentKey = 'customThemeAccent';
  static final ValueNotifier<Color?> customAccent =
      ValueNotifier<Color?>(null);

  static bool get isDynamicSectionMode => customAccent.value == null;

  /// Canonical mapping of section indices to chromatic accent identities.
  static Color colorForIndex(int index) {
    switch (index) {
      case 1:
        return AppColors.accentGreen; // Experience: Neo-Mint Emerald (0xFF10B981)
      case 2:
        return AppColors.accentViolet; // Projects / Work: Royal Cyber Violet (0xFF8B5CF6)
      case 3:
        return AppColors.accentAmber; // Skills / Stack: Solar Radiant Amber (0xFFFBBF24)
      case 4:
        return AppColors.accentRose; // Engineering: Crimson Coral Flare (0xFFF43F5E)
      case 5:
        return AppColors.accentCyan; // Perspectives / Hats: Quantum Cyber Cyan (0xFF06B6D4)
      case 6:
        return AppColors.accentIndigoDeep; // Contact: Luminous Cyber Indigo (0xFF6366F1)
      case 0:
      default:
        return AppColors.seed; // Home / Intro: Vibrant Electric Indigo (0xFF4F46E5)
    }
  }

  /// Immediately updates seed color from section index when in dynamic mode.
  static void updateSeedFromIndex(int index) {
    if (customAccent.value != null) return;
    seedColor.value = colorForIndex(index);
  }

  /// Updates seed color from URL hash with support for specific case studies.
  static void updateSeedFromHash(String hash) {
    if (customAccent.value != null) return;
    final normalized = hash.replaceAll('#', '').toLowerCase();

    // Check specific case study hashes first
    if (normalized.startsWith('work/')) {
      final parts = normalized.split('/');
      if (parts.length > 1) {
        final study = parts[1];
        switch (study) {
          case 'nathealth':
            seedColor.value = AppColors.caseStudyNatHealthPrimary;
            return;
          case 'eskadenia':
            seedColor.value = AppColors.caseStudyEskadeniaPrimary;
            return;
          case 'solutions':
            seedColor.value = AppColors.caseStudySolutionsPrimary;
            return;
          case 'fais':
            seedColor.value = AppColors.caseStudyFaisPrimary;
            return;
        }
      }
    }

    final clean = normalized.split('/').first;
    switch (clean) {
      case 'experience':
        updateSeedFromIndex(1);
        return;
      case 'work':
        updateSeedFromIndex(2);
        return;
      case 'stack':
        updateSeedFromIndex(3);
        return;
      case 'engineering':
        updateSeedFromIndex(4);
        return;
      case 'about':
        updateSeedFromIndex(5);
        return;
      case 'contact':
        updateSeedFromIndex(6);
        return;
      case 'home':
      default:
        updateSeedFromIndex(0);
        return;
    }
  }

  /// Sets a user-chosen custom chromatic accent, or passes null to revert
  /// to section-dynamic adaptive theming.
  static void setCustomAccent(Color? color) {
    customAccent.value = color;
    if (color != null) {
      seedColor.value = color;
      _persistCustomAccent(color.toARGB32());
    } else {
      _persistCustomAccent(null);
      final hash = Uri.base.fragment;
      if (hash.isNotEmpty) {
        updateSeedFromHash(hash);
      } else {
        updateSeedFromIndex(0);
      }
    }
  }

  static Future<void> _persistCustomAccent(int? colorValue) async {
    final prefs = await SharedPreferences.getInstance();
    if (colorValue == null) {
      await prefs.remove(_customAccentKey);
    } else {
      await prefs.setInt(_customAccentKey, colorValue);
    }
  }

  static Future<void> load() async {
    final urlTheme = Uri.base.queryParameters['theme']?.toLowerCase();
    if (urlTheme == 'light') {
      mode.value = ThemeMode.light;
    } else if (urlTheme == 'dark') {
      mode.value = ThemeMode.dark;
    } else {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      switch (raw) {
        case 'light':
          mode.value = ThemeMode.light;
          break;
        case 'system':
          mode.value = ThemeMode.system;
          break;
        case 'dark':
        default:
          mode.value = ThemeMode.dark;
          break;
      }
    }

    // Load custom accent preference if saved
    final prefs = await SharedPreferences.getInstance();
    final customVal = prefs.getInt(_customAccentKey);
    if (customVal != null) {
      final col = Color(customVal);
      customAccent.value = col;
      seedColor.value = col;
    }
  }

  static Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, mode.value.name);
  }

  static void toggle() {
    mode.value =
        mode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _persist();
  }
}
