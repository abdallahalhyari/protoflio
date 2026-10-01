import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:profile/app/bootstrap.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('readInitialThemeMode', () {
    test('defaults to dark for missing or invalid values', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      expect(readInitialThemeMode(prefs), ThemeMode.dark);

      SharedPreferences.setMockInitialValues({'themeMode': 'invalid'});
      final invalidPrefs = await SharedPreferences.getInstance();
      expect(readInitialThemeMode(invalidPrefs), ThemeMode.dark);
    });

    test('reads supported theme preferences', () async {
      SharedPreferences.setMockInitialValues({'themeMode': 'light'});
      final lightPrefs = await SharedPreferences.getInstance();
      expect(readInitialThemeMode(lightPrefs), ThemeMode.light);

      SharedPreferences.setMockInitialValues({'themeMode': 'dark'});
      final darkPrefs = await SharedPreferences.getInstance();
      expect(readInitialThemeMode(darkPrefs), ThemeMode.dark);
    });

    test('URL theme overrides the saved preference', () async {
      SharedPreferences.setMockInitialValues({'themeMode': 'dark'});
      final prefs = await SharedPreferences.getInstance();
      expect(
        readInitialThemeMode(prefs,
            uri: Uri.parse('https://example.com/?theme=light')),
        ThemeMode.light,
      );
    });
  });

  group('readInitialLocale', () {
    test('defaults to English for missing or unsupported values', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      expect(readInitialLocale(prefs), const Locale('en'));

      SharedPreferences.setMockInitialValues({'localeCode': 'fr'});
      final invalidPrefs = await SharedPreferences.getInstance();
      expect(readInitialLocale(invalidPrefs), const Locale('en'));
    });

    test('reads supported locales', () async {
      SharedPreferences.setMockInitialValues({'localeCode': 'ar'});
      final arabicPrefs = await SharedPreferences.getInstance();
      expect(readInitialLocale(arabicPrefs), const Locale('ar'));

      SharedPreferences.setMockInitialValues({'localeCode': 'cs'});
      final czechPrefs = await SharedPreferences.getInstance();
      expect(readInitialLocale(czechPrefs), const Locale('cs'));
    });

    test('URL language overrides the saved preference', () async {
      SharedPreferences.setMockInitialValues({'localeCode': 'en'});
      final prefs = await SharedPreferences.getInstance();
      expect(
        readInitialLocale(prefs,
            uri: Uri.parse('https://example.com/?lang=ar')),
        const Locale('ar'),
      );
    });
  });

  testWidgets('AppBootstrapper renders startup loading state immediately',
      (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(MaterialApp(
      home: AppBootstrapper(builder: (_) => const SizedBox()),
    ));

    expect(find.text('Loading portfolio…'), findsOneWidget);
    expect(find.text('ABDALLAH ALHYARI'), findsOneWidget);
  });
}
