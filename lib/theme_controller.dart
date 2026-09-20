import 'dart:async';
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

  /// Canonical mapping of section indices to chromatic accent identities.
  static Color colorForIndex(int index) {
    switch (index) {
      case 1:
        return AppColors
            .accentGreen; // Experience: Neo-Mint Emerald (0xFF10B981)
      case 2:
        return AppColors
            .accentViolet; // Projects / Work: Royal Cyber Violet (0xFF8B5CF6)
      case 3:
        return AppColors
            .accentAmber; // Skills / Stack: Solar Radiant Amber (0xFFFBBF24)
      case 4:
        return AppColors
            .accentRose; // Engineering: Crimson Coral Flare (0xFFF43F5E)
      case 5:
        return AppColors
            .accentCyan; // Perspectives / Hats: Quantum Cyber Cyan (0xFF06B6D4)
      case 6:
        return AppColors
            .accentIndigoDeep; // Contact: Luminous Cyber Indigo (0xFF6366F1)
      case 0:
      default:
        return AppColors
            .seed; // Home / Intro: Vibrant Electric Indigo (0xFF4F46E5)
    }
  }

  /// Immediately updates seed color from section index.
  static void updateSeedFromIndex(int index) {
    seedColor.value = colorForIndex(index);
  }

  static void updateSeedFromHash(String hash) {
    final clean = hash.replaceAll('#', '').split('/').first.toLowerCase();
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

  static Future<void> load() async {
    final urlTheme = Uri.base.queryParameters['theme']?.toLowerCase();
    if (urlTheme == 'light') {
      mode.value = ThemeMode.light;
      return;
    } else if (urlTheme == 'dark') {
      mode.value = ThemeMode.dark;
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    switch (raw) {
      case 'light':
        mode.value = ThemeMode.light;
        return;
      case 'system':
        mode.value = ThemeMode.system;
        return;
      case 'dark':
        mode.value = ThemeMode.dark;
        return;
      default:
        mode.value = ThemeMode.dark;
        return;
    }
  }

  static Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, mode.value.name);
  }

  static void toggle() {
    mode.value =
        mode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    unawaited(_persist());
  }
}
