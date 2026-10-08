import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:profile/core/bloc/theme/theme_event.dart';
import 'package:profile/core/bloc/theme/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String prefsKey = 'themeMode';

  ThemeBloc({ThemeMode initialMode = ThemeMode.light})
      : super(ThemeState(mode: initialMode)) {
    on<ThemeModeToggled>(_onModeToggled);
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

  Future<void> _onModeToggled(
      ThemeModeToggled event, Emitter<ThemeState> emit) async {
    final nextMode = state.isDark ? ThemeMode.light : ThemeMode.dark;
    emit(state.copyWith(mode: nextMode));
    unawaited(_persistMode(nextMode));
  }

  Future<void> _persistMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefsKey, mode.name);
  }
}
