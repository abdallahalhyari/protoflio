import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController {
  ThemeController._();

  static const String _prefsKey = 'themeMode';

  static final ValueNotifier<ThemeMode> mode =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  static Future<void> load() async {
    try {
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
    } catch (e) {
      debugPrint('ThemeController.load failed: $e');
    }
  }

  static Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, mode.value.name);
    } catch (e) {
      debugPrint('ThemeController._persist failed: $e');
    }
  }

  static Future<void> toggle() async {
    mode.value =
        mode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await _persist();
  }
}
