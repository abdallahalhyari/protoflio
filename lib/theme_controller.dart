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

  static void updateSeedFromHash(String hash) {
    switch (hash.replaceAll('#', '').toLowerCase()) {
      case 'experience':
        seedColor.value = AppColors.accentGreen; // Neo-Mint Emerald (0xFF10B981)
        return;
      case 'work':
        seedColor.value = AppColors.accentViolet; // Royal Cyber Violet (0xFF8B5CF6)
        return;
      case 'stack':
        seedColor.value = AppColors.accentAmber; // Solar Radiant Amber (0xFFFBBF24)
        return;
      case 'engineering':
        seedColor.value = AppColors.accentRose; // Crimson Coral Flare (0xFFF43F5E)
        return;
      case 'about':
        seedColor.value = AppColors.accentCyan; // Quantum Cyber Cyan (0xFF06B6D4)
        return;
      case 'contact':
        seedColor.value = AppColors.accentIndigoDeep; // Luminous Cyber Indigo (0xFF6366F1)
        return;
      case 'home':
      default:
        seedColor.value = AppColors.seed; // Vibrant Electric Indigo
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
    _persist();
  }
}
