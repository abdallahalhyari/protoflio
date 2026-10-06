import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';
import 'package:profile/core/bloc/theme/theme_event.dart';
import 'package:profile/core/bloc/theme/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('ThemeBloc.resolveInitial', () {
    ThemeMode resolve(String url, [String? stored]) =>
        ThemeBloc.resolveInitial(uri: Uri.parse(url), stored: stored);

    test('defaults to light', () {
      expect(resolve('https://a.app/'), ThemeMode.light);
    });

    test('uses the saved choice', () {
      expect(resolve('https://a.app/', 'light'), ThemeMode.light);
      expect(resolve('https://a.app/', 'dark'), ThemeMode.dark);
    });

    test('a ?theme= link wins over the saved choice', () {
      expect(resolve('https://a.app/?theme=light', 'dark'), ThemeMode.light);
      expect(resolve('https://a.app/?theme=DARK', 'light'), ThemeMode.dark);
    });

    test('anything else (including a stale "system") is light', () {
      expect(resolve('https://a.app/', 'system'), ThemeMode.light);
      expect(resolve('https://a.app/?theme=sepia'), ThemeMode.light);
    });
  });

  group('ThemeBloc', () {
    blocTest<ThemeBloc, ThemeState>(
      'toggles between light and dark and saves the choice',
      build: ThemeBloc.new,
      act: (b) => b
        ..add(const ThemeModeToggled())
        ..add(const ThemeModeToggled()),
      expect: () => const [
        ThemeState(mode: ThemeMode.dark),
        ThemeState(),
      ],
      verify: (_) async {
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString(ThemeBloc.prefsKey), 'light');
      },
    );
  });
}
