import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:profile/theme/tokens.dart';
import 'package:profile/theme_controller.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _prefsKey = 'themeMode';

  ThemeBloc({ThemeMode initialMode = ThemeMode.dark})
      : super(ThemeState(mode: initialMode, seedColor: AppColors.seed)) {
    ThemeController.onAccentChanged = (index) {
      if (!isClosed && state.activeSectionIndex != index) {
        add(ThemeAccentUpdated(index));
      }
    };
    ThemeController.onModeChanged = (mode) {
      if (!isClosed && state.mode != mode) {
        add(ThemeModeChanged(mode));
      }
    };

    on<ThemeStarted>(_onStarted);
    on<ThemeModeToggled>(_onModeToggled);
    on<ThemeModeChanged>(_onModeChanged);
    on<ThemeAccentUpdated>(_onAccentUpdated);
    on<ThemeAccentUpdatedFromHash>(_onAccentUpdatedFromHash);
  }

  @override
  Future<void> close() {
    ThemeController.onAccentChanged = null;
    ThemeController.onModeChanged = null;
    return super.close();
  }

  static Color colorForIndex(int index) {
    switch (index) {
      case 1:
        return AppColors.accentGreen;
      case 2:
        return AppColors.accentViolet;
      case 3:
        return AppColors.accentAmber;
      case 4:
        return AppColors.accentRose;
      case 5:
        return AppColors.accentCyan;
      case 6:
        return AppColors.accentIndigoDeep;
      case 0:
      default:
        return AppColors.seed;
    }
  }

  Future<void> _onStarted(ThemeStarted event, Emitter<ThemeState> emit) async {
    final urlTheme = Uri.base.queryParameters['theme']?.toLowerCase();
    ThemeMode resolvedMode = state.mode;

    if (urlTheme == 'light') {
      resolvedMode = ThemeMode.light;
    } else if (urlTheme == 'dark') {
      resolvedMode = ThemeMode.dark;
    } else {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      switch (raw) {
        case 'light':
          resolvedMode = ThemeMode.light;
          break;
        case 'system':
          resolvedMode = ThemeMode.system;
          break;
        case 'dark':
        default:
          resolvedMode = ThemeMode.dark;
          break;
      }
    }

    emit(state.copyWith(mode: resolvedMode));
    _syncLegacyController(resolvedMode, state.seedColor);
  }

  Future<void> _onModeToggled(
      ThemeModeToggled event, Emitter<ThemeState> emit) async {
    final nextMode =
        state.mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(state.copyWith(mode: nextMode));
    _syncLegacyController(nextMode, state.seedColor);
    unawaited(_persistMode(nextMode));
  }

  Future<void> _onModeChanged(
      ThemeModeChanged event, Emitter<ThemeState> emit) async {
    emit(state.copyWith(mode: event.mode));
    _syncLegacyController(event.mode, state.seedColor);
    unawaited(_persistMode(event.mode));
  }

  void _onAccentUpdated(ThemeAccentUpdated event, Emitter<ThemeState> emit) {
    final newColor = colorForIndex(event.sectionIndex);
    emit(state.copyWith(
      seedColor: newColor,
      activeSectionIndex: event.sectionIndex,
    ));
    _syncLegacyController(state.mode, newColor);
  }

  void _onAccentUpdatedFromHash(
      ThemeAccentUpdatedFromHash event, Emitter<ThemeState> emit) {
    final clean = event.hash.replaceAll('#', '').split('/').first.toLowerCase();
    int sectionIndex = 0;
    switch (clean) {
      case 'experience':
        sectionIndex = 1;
        break;
      case 'work':
        sectionIndex = 2;
        break;
      case 'stack':
        sectionIndex = 3;
        break;
      case 'engineering':
        sectionIndex = 4;
        break;
      case 'about':
        sectionIndex = 5;
        break;
      case 'contact':
        sectionIndex = 6;
        break;
      case 'home':
      default:
        sectionIndex = 0;
        break;
    }
    final newColor = colorForIndex(sectionIndex);
    emit(state.copyWith(
      seedColor: newColor,
      activeSectionIndex: sectionIndex,
    ));
    _syncLegacyController(state.mode, newColor);
  }

  void _syncLegacyController(ThemeMode mode, Color seed) {
    ThemeController.syncFromBloc(mode, seed);
  }

  Future<void> _persistMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, mode.name);
  }
}
