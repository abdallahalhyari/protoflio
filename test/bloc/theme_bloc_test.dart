import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';
import 'package:profile/core/bloc/theme/theme_event.dart';
import 'package:profile/core/bloc/theme/theme_state.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('ThemeBloc.resolveInitial', () {
    ThemeMode resolve(String url, [String? stored]) =>
        ThemeBloc.resolveInitial(uri: Uri.parse(url), stored: stored);

    test('defaults to dark', () {
      expect(resolve('https://a.app/'), ThemeMode.dark);
    });

    test('uses the saved choice', () {
      expect(resolve('https://a.app/', 'light'), ThemeMode.light);
      expect(resolve('https://a.app/', 'dark'), ThemeMode.dark);
    });

    test('a ?theme= link wins over the saved choice', () {
      expect(resolve('https://a.app/?theme=light', 'dark'), ThemeMode.light);
      expect(resolve('https://a.app/?theme=DARK', 'light'), ThemeMode.dark);
    });

    test('anything else (including a stale "system") is dark', () {
      expect(resolve('https://a.app/', 'system'), ThemeMode.dark);
      expect(resolve('https://a.app/?theme=sepia'), ThemeMode.dark);
    });
  });

  test('colorForIndex maps each section to its accent', () {
    expect(ThemeBloc.colorForIndex(0), AppColors.seed);
    expect(ThemeBloc.colorForIndex(1), AppColors.teal);
    expect(ThemeBloc.colorForIndex(2), AppColors.teal);
    expect(ThemeBloc.colorForIndex(3), AppColors.gold);
    expect(ThemeBloc.colorForIndex(4), AppColors.signal);
    expect(ThemeBloc.colorForIndex(5), AppColors.teal);
    expect(ThemeBloc.colorForIndex(6), AppColors.teal);
    expect(ThemeBloc.colorForIndex(99), AppColors.seed);
  });

  group('ThemeBloc', () {
    blocTest<ThemeBloc, ThemeState>(
      'toggles between dark and light and saves the choice',
      build: ThemeBloc.new,
      act: (b) => b
        ..add(const ThemeModeToggled())
        ..add(const ThemeModeToggled()),
      expect: () => const [
        ThemeState(mode: ThemeMode.light),
        ThemeState(),
      ],
      verify: (_) async {
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString(ThemeBloc.prefsKey), 'dark');
      },
    );

    blocTest<ThemeBloc, ThemeState>(
      'a section change sets its accent as the seed',
      build: ThemeBloc.new,
      act: (b) => b
        ..add(const ThemeAccentUpdated(3))
        ..add(const ThemeAccentUpdated(3))
        ..add(const ThemeAccentUpdated(0)),
      // The repeat is a no-op (same state), not a second rebuild.
      expect: () => const [
        ThemeState(seedColor: AppColors.gold),
        ThemeState(),
      ],
    );
  });
}
