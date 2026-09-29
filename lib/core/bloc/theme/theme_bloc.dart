import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:profile/theme/tokens.dart';
import 'package:profile/core/bloc/theme/theme_event.dart';
import 'package:profile/core/bloc/theme/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _prefsKey = 'themeMode';

  ThemeBloc({ThemeMode initialMode = ThemeMode.dark})
      : super(ThemeState(mode: initialMode)) {
    on<ThemeStarted>(_onStarted);
    on<ThemeModeToggled>(_onModeToggled);
    on<ThemeModeChanged>(_onModeChanged);
    on<ThemeAccentUpdated>(_onAccentUpdated);
    on<ThemeAccentUpdatedFromHash>(_onAccentUpdatedFromHash);
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
        case 'system':
          resolvedMode = ThemeMode.system;
        case 'dark':
        default:
          resolvedMode = ThemeMode.dark;
      }
    }

    emit(state.copyWith(mode: resolvedMode));
  }

  Future<void> _onModeToggled(
      ThemeModeToggled event, Emitter<ThemeState> emit) async {
    final nextMode =
        state.mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(state.copyWith(mode: nextMode));
    unawaited(_persistMode(nextMode));
  }

  Future<void> _onModeChanged(
      ThemeModeChanged event, Emitter<ThemeState> emit) async {
    emit(state.copyWith(mode: event.mode));
    unawaited(_persistMode(event.mode));
  }

  void _onAccentUpdated(ThemeAccentUpdated event, Emitter<ThemeState> emit) {
    final newColor = colorForIndex(event.sectionIndex);
    emit(state.copyWith(
      seedColor: newColor,
      activeSectionIndex: event.sectionIndex,
    ));
  }

  void _onAccentUpdatedFromHash(
      ThemeAccentUpdatedFromHash event, Emitter<ThemeState> emit) {
    final clean = event.hash.replaceAll('#', '').split('/').first.toLowerCase();
    int sectionIndex = 0;
    switch (clean) {
      case 'experience':
        sectionIndex = 1;
      case 'work':
        sectionIndex = 2;
      case 'stack':
        sectionIndex = 3;
      case 'engineering':
        sectionIndex = 4;
      case 'about':
        sectionIndex = 5;
      case 'contact':
        sectionIndex = 6;
      case 'home':
      default:
        sectionIndex = 0;
    }
    final newColor = colorForIndex(sectionIndex);
    emit(state.copyWith(
      seedColor: newColor,
      activeSectionIndex: sectionIndex,
    ));
  }

  Future<void> _persistMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, mode.name);
  }
}
