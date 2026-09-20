import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';
import 'package:profile/core/bloc/theme/theme_event.dart';
import 'package:profile/core/bloc/theme/theme_state.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeBloc Test Suite', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('initial state defaults to dark mode with base seed color', () async {
      final bloc = ThemeBloc();
      expect(bloc.state.mode, equals(ThemeMode.dark));
      expect(bloc.state.seedColor, equals(AppColors.seed));
      expect(bloc.state.activeSectionIndex, equals(0));
      expect(bloc.state.isDark, isTrue);
      await bloc.close();
    });

    test('ThemeModeToggled alternates between light and dark', () async {
      final bloc = ThemeBloc(initialMode: ThemeMode.dark);

      bloc.add(const ThemeModeToggled());
      await expectLater(
        bloc.stream,
        emits(const ThemeState(
          mode: ThemeMode.light,
          seedColor: AppColors.seed,
          activeSectionIndex: 0,
        )),
      );

      bloc.add(const ThemeModeToggled());
      await expectLater(
        bloc.stream,
        emits(const ThemeState(
          mode: ThemeMode.dark,
          seedColor: AppColors.seed,
          activeSectionIndex: 0,
        )),
      );

      await bloc.close();
    });

    test('ThemeModeChanged explicitly updates theme mode', () async {
      final bloc = ThemeBloc(initialMode: ThemeMode.dark);

      bloc.add(const ThemeModeChanged(ThemeMode.system));
      await expectLater(
        bloc.stream,
        emits(const ThemeState(
          mode: ThemeMode.system,
          seedColor: AppColors.seed,
          activeSectionIndex: 0,
        )),
      );

      await bloc.close();
    });

    test('ThemeAccentUpdated updates chromatic seed color per section index', () async {
      final bloc = ThemeBloc();

      // Section 1: Experience (Neo-Mint Emerald)
      bloc.add(const ThemeAccentUpdated(1));
      await expectLater(
        bloc.stream,
        emits(const ThemeState(
          mode: ThemeMode.dark,
          seedColor: AppColors.accentGreen,
          activeSectionIndex: 1,
        )),
      );

      // Section 4: Engineering (Crimson Coral Flare)
      bloc.add(const ThemeAccentUpdated(4));
      await expectLater(
        bloc.stream,
        emits(const ThemeState(
          mode: ThemeMode.dark,
          seedColor: AppColors.accentRose,
          activeSectionIndex: 4,
        )),
      );

      await bloc.close();
    });

    test('ThemeAccentUpdatedFromHash parses slug and resolves chromatic identity', () async {
      final bloc = ThemeBloc();

      bloc.add(const ThemeAccentUpdatedFromHash('#work/nathealth'));
      await expectLater(
        bloc.stream,
        emits(const ThemeState(
          mode: ThemeMode.dark,
          seedColor: AppColors.accentViolet,
          activeSectionIndex: 2,
        )),
      );

      bloc.add(const ThemeAccentUpdatedFromHash('contact'));
      await expectLater(
        bloc.stream,
        emits(const ThemeState(
          mode: ThemeMode.dark,
          seedColor: AppColors.accentIndigoDeep,
          activeSectionIndex: 6,
        )),
      );

      await bloc.close();
    });

    test('ThemeBloc bi-directionally synchronizes with ThemeController', () async {
      final bloc = ThemeBloc();

      // Calling ThemeController.updateSeedFromIndex triggers bloc event
      ThemeController.updateSeedFromIndex(3);
      await expectLater(
        bloc.stream,
        emits(const ThemeState(
          mode: ThemeMode.dark,
          seedColor: AppColors.accentAmber,
          activeSectionIndex: 3,
        )),
      );

      // Dispatched bloc event synchronizes back to ThemeController
      bloc.add(const ThemeAccentUpdated(5));
      await expectLater(
        bloc.stream,
        emits(const ThemeState(
          mode: ThemeMode.dark,
          seedColor: AppColors.accentCyan,
          activeSectionIndex: 5,
        )),
      );
      expect(ThemeController.seedColor.value, equals(AppColors.accentCyan));

      await bloc.close();
    });
  });
}
