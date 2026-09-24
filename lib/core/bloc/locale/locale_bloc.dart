import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locale_event.dart';
import 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  static const String _prefsKey = 'localeCode';
  static const List<String> supportedLanguages = ['en', 'ar', 'cs'];

  LocaleBloc({Locale initialLocale = const Locale('en')})
      : super(LocaleState(locale: initialLocale)) {
    on<LocaleStarted>(_onStarted);
    on<LocaleChanged>(_onChanged);
    on<NextLocaleRequested>(_onNextRequested);
  }

  Future<void> _onStarted(
      LocaleStarted event, Emitter<LocaleState> emit) async {
    final urlLang = Uri.base.queryParameters['lang']?.toLowerCase();
    if (urlLang != null && supportedLanguages.contains(urlLang)) {
      final loc = Locale(urlLang);
      emit(state.copyWith(locale: loc));
      unawaited(_persist(urlLang));
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null && supportedLanguages.contains(raw)) {
      final loc = Locale(raw);
      emit(state.copyWith(locale: loc));
    }
  }

  Future<void> _onChanged(
      LocaleChanged event, Emitter<LocaleState> emit) async {
    if (!supportedLanguages.contains(event.languageCode)) return;
    final loc = Locale(event.languageCode);
    emit(state.copyWith(locale: loc));
    unawaited(_persist(event.languageCode));
  }

  Future<void> _onNextRequested(
      NextLocaleRequested event, Emitter<LocaleState> emit) async {
    final currentCode = state.locale.languageCode;
    final currentIndex = supportedLanguages.indexOf(currentCode);
    final nextIndex = (currentIndex + 1) % supportedLanguages.length;
    final nextCode = supportedLanguages[nextIndex];
    final nextLoc = Locale(nextCode);

    emit(state.copyWith(locale: nextLoc));
    unawaited(_persist(nextCode));
  }

  Future<void> _persist(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, code);
  }
}
