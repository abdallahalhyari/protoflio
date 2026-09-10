import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController {
  LocaleController._();

  static const String _prefsKey = 'localeCode';

  static final ValueNotifier<Locale> locale = ValueNotifier<Locale>(const Locale('en'));

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      locale.value = Locale(raw);
    }
  }

  static Future<void> _persist(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, code);
  }

  static void changeLocale(String code) {
    locale.value = Locale(code);
    _persist(code);
  }

  static void nextLocale() {
    const supported = ['en', 'ar', 'cs'];
    final current = locale.value.languageCode;
    final currentIndex = supported.indexOf(current);
    final nextIndex = (currentIndex + 1) % supported.length;
    changeLocale(supported[nextIndex]);
  }
}
