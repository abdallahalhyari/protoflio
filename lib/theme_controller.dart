import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController {
  ThemeController._();

  static const String _prefsKey = 'themeMode';

  static final ValueNotifier<ThemeMode> mode =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  static final ValueNotifier<Color> seedColor =
      ValueNotifier<Color>(const Color(0xFF6366F1));

  static void updateSeedFromHash(String hash) {
    switch (hash.replaceAll('#', '').toLowerCase()) {
      case 'experience':
        seedColor.value = const Color(0xFF10B981); // Emerald
      case 'work':
        seedColor.value = const Color(0xFF8B5CF6); // Violet
      case 'stack':
        seedColor.value = const Color(0xFFF59E0B); // Amber
      case 'engineering':
        seedColor.value = const Color(0xFFF43F5E); // Rose
      case 'about':
        seedColor.value = const Color(0xFF06B6D4); // Cyan
      case 'contact':
        seedColor.value = const Color(0xFF3B82F6); // Sky Blue
      case 'home':
      default:
        seedColor.value = const Color(0xFF6366F1); // Indigo
    }
  }

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    switch (raw) {
      case 'light':
        mode.value = ThemeMode.light;
      case 'system':
        mode.value = ThemeMode.system;
      case 'dark':
      default:
        mode.value = ThemeMode.dark;
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
