import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:profile/core/theme/tokens.dart';
import 'package:profile/core/bloc/theme/theme_event.dart';
import 'package:profile/core/bloc/theme/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String prefsKey = 'themeMode';

  ThemeBloc({ThemeMode initialMode = ThemeMode.dark})
      : super(ThemeState(mode: initialMode)) {
    on<ThemeModeToggled>(_onModeToggled);
    on<ThemeAccentUpdated>(_onAccentUpdated);
  }

  /// The mode to start in: a `?theme=light|dark` link wins (not saved, so
  /// it doesn't change a visitor's own choice), then the saved choice, then
  /// dark. Resolved before the first frame so the page never flips after
  /// painting. Only light and dark exist: nothing in the UI offers
  /// "system", and `isDark` would misread it.
  static ThemeMode resolveInitial({required Uri uri, String? stored}) {
    final requested = uri.queryParameters['theme']?.toLowerCase() ?? stored;
    return requested == 'light' ? ThemeMode.light : ThemeMode.dark;
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

  Future<void> _onModeToggled(
      ThemeModeToggled event, Emitter<ThemeState> emit) async {
    final nextMode = state.isDark ? ThemeMode.light : ThemeMode.dark;
    emit(state.copyWith(mode: nextMode));
    unawaited(_persistMode(nextMode));
  }

  void _onAccentUpdated(ThemeAccentUpdated event, Emitter<ThemeState> emit) {
    emit(state.copyWith(seedColor: colorForIndex(event.sectionIndex)));
  }

  Future<void> _persistMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefsKey, mode.name);
  }
}
