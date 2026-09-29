import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';
import 'package:profile/core/bloc/theme/theme_event.dart';
import 'package:profile/core/bloc/theme/theme_state.dart';
import 'package:profile/theme/tokens.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ThemeBloc Test Suite', () {
    test('initial state has default dark mode, seed color, and section 0', () {
      final bloc = ThemeBloc();
      expect(bloc.state.mode, equals(ThemeMode.dark));
      expect(bloc.state.isDark, isTrue);
      expect(bloc.state.seedColor, equals(AppColors.seed));
      expect(bloc.state.activeSectionIndex, equals(0));
      bloc.close();
    });

    test('ThemeModeToggled alternates between dark and light modes', () async {
      final bloc = ThemeBloc();

      bloc.add(const ThemeModeToggled());
      await expectLater(
        bloc.stream,
        emits(predicate<ThemeState>(
            (s) => s.mode == ThemeMode.light && !s.isDark)),
      );

      bloc.add(const ThemeModeToggled());
      await expectLater(
        bloc.stream,
        emits(
            predicate<ThemeState>((s) => s.mode == ThemeMode.dark && s.isDark)),
      );

      await bloc.close();
    });

    test('ThemeModeChanged sets explicit theme mode', () async {
      final bloc = ThemeBloc();

      bloc.add(const ThemeModeChanged(ThemeMode.light));
      await expectLater(
        bloc.stream,
        emits(predicate<ThemeState>((s) => s.mode == ThemeMode.light)),
      );

      bloc.add(const ThemeModeChanged(ThemeMode.system));
      await expectLater(
        bloc.stream,
        emits(predicate<ThemeState>((s) => s.mode == ThemeMode.system)),
      );

      await bloc.close();
    });

    test('ThemeAccentUpdated updates seed color and activeSectionIndex',
        () async {
      final bloc = ThemeBloc();

      bloc.add(const ThemeAccentUpdated(2));
      await expectLater(
        bloc.stream,
        emits(predicate<ThemeState>((s) =>
            s.activeSectionIndex == 2 &&
            s.seedColor == AppColors.accentViolet)),
      );

      bloc.add(const ThemeAccentUpdated(4));
      await expectLater(
        bloc.stream,
        emits(predicate<ThemeState>((s) =>
            s.activeSectionIndex == 4 && s.seedColor == AppColors.accentRose)),
      );

      await bloc.close();
    });

    test('ThemeAccentUpdatedFromHash parses section route hash correctly',
        () async {
      final bloc = ThemeBloc();

      bloc.add(const ThemeAccentUpdatedFromHash('#work/nathealth'));
      await expectLater(
        bloc.stream,
        emits(predicate<ThemeState>((s) =>
            s.activeSectionIndex == 2 &&
            s.seedColor == AppColors.accentViolet)),
      );

      bloc.add(const ThemeAccentUpdatedFromHash('#contact'));
      await expectLater(
        bloc.stream,
        emits(predicate<ThemeState>((s) =>
            s.activeSectionIndex == 6 &&
            s.seedColor == AppColors.accentIndigoDeep)),
      );

      bloc.add(const ThemeAccentUpdatedFromHash('#unknown'));
      await expectLater(
        bloc.stream,
        emits(predicate<ThemeState>(
            (s) => s.activeSectionIndex == 0 && s.seedColor == AppColors.seed)),
      );

      await bloc.close();
    });

    test('colorForIndex returns expected accent colors', () {
      expect(ThemeBloc.colorForIndex(0), equals(AppColors.seed));
      expect(ThemeBloc.colorForIndex(1), equals(AppColors.accentGreen));
      expect(ThemeBloc.colorForIndex(2), equals(AppColors.accentViolet));
      expect(ThemeBloc.colorForIndex(3), equals(AppColors.accentAmber));
      expect(ThemeBloc.colorForIndex(4), equals(AppColors.accentRose));
      expect(ThemeBloc.colorForIndex(5), equals(AppColors.accentCyan));
      expect(ThemeBloc.colorForIndex(6), equals(AppColors.accentIndigoDeep));
      expect(ThemeBloc.colorForIndex(99), equals(AppColors.seed));
    });

    test('ThemeStarted loads persisted mode from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({'themeMode': 'light'});
      final bloc = ThemeBloc();

      bloc.add(const ThemeStarted());
      await expectLater(
        bloc.stream,
        emits(predicate<ThemeState>((s) => s.mode == ThemeMode.light)),
      );

      await bloc.close();
    });
  });
}
