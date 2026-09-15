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
        seedColor.value = const Color(0xFF10B981); // Neo-Mint Emerald
        return;
      case 'work':
        seedColor.value = const Color(0xFF8B5CF6); // Royal Cyber Violet
        return;
      case 'stack':
        seedColor.value = const Color(0xFFF59E0B); // Solar Radiant Amber
        return;
      case 'engineering':
        seedColor.value = const Color(0xFFF43F5E); // Crimson Coral Flare
        return;
      case 'about':
        seedColor.value = const Color(0xFF06B6D4); // Quantum Cyber Cyan
        return;
      case 'contact':
        seedColor.value = const Color(0xFF2563EB); // Ultramarine Sapphire
        return;
      case 'home':
      default:
        seedColor.value = AppColors.seed; // Vibrant Electric Indigo
        return;
    }
  }

  static Future<void> load() async {
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
