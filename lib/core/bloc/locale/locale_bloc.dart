import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:profile/core/bloc/locale/locale_event.dart';
import 'package:profile/core/bloc/locale/locale_state.dart';
import 'package:profile/l10n/app_localizations.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  static const String prefsKey = 'localeCode';

  /// Language codes the app ships, from the generated localizations (one
  /// source of truth with MaterialApp.supportedLocales).
  static final List<String> supportedLanguages = [
    for (final locale in AppLocalizations.supportedLocales) locale.languageCode,
  ];

  LocaleBloc({Locale initialLocale = const Locale('en')})
      : super(LocaleState(locale: initialLocale)) {
    on<LocaleChanged>(_onChanged);
    on<NextLocaleRequested>(_onNextRequested);
  }

  /// A supported `?lang=` code in [uri], or null.
  static String? languageFromUrl(Uri uri) {
    final code = uri.queryParameters['lang']?.toLowerCase();
    return supportedLanguages.contains(code) ? code : null;
  }

  /// The locale to start in: a `?lang=` link wins, then the saved choice,
  /// then English. Resolved before the first frame, so a shared Arabic link
  /// doesn't paint in English (and left-to-right) first.
  static Locale resolveInitial({required Uri uri, String? stored}) {
    final code = languageFromUrl(uri) ??
        (supportedLanguages.contains(stored) ? stored! : 'en');
    return Locale(code);
  }

  Future<void> _onChanged(
      LocaleChanged event, Emitter<LocaleState> emit) async {
    if (!supportedLanguages.contains(event.languageCode)) return;
    emit(state.copyWith(locale: Locale(event.languageCode)));
    unawaited(persist(event.languageCode));
  }

  Future<void> _onNextRequested(
      NextLocaleRequested event, Emitter<LocaleState> emit) async {
    final currentIndex = supportedLanguages.indexOf(state.locale.languageCode);
    final nextCode =
        supportedLanguages[(currentIndex + 1) % supportedLanguages.length];
    emit(state.copyWith(locale: Locale(nextCode)));
    unawaited(persist(nextCode));
  }

  static Future<void> persist(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefsKey, code);
  }
}
