import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/bloc/locale/locale_bloc.dart';
import 'package:profile/core/bloc/locale/locale_event.dart';
import 'package:profile/core/bloc/locale/locale_state.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('supports exactly the languages the app is translated into', () {
    expect(
      LocaleBloc.supportedLanguages.toSet(),
      AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet(),
    );
  });

  group('LocaleBloc.resolveInitial', () {
    Locale resolve(String url, [String? stored]) =>
        LocaleBloc.resolveInitial(uri: Uri.parse(url), stored: stored);

    test('defaults to English', () {
      expect(resolve('https://a.app/'), const Locale('en'));
    });

    test('uses a saved, supported choice', () {
      expect(resolve('https://a.app/', 'cs'), const Locale('cs'));
      expect(resolve('https://a.app/', 'fr'), const Locale('en'));
    });

    test('a ?lang= link wins over the saved choice', () {
      expect(resolve('https://a.app/?lang=ar', 'cs'), const Locale('ar'));
      expect(resolve('https://a.app/?lang=AR'), const Locale('ar'));
    });

    test('an unsupported ?lang= falls back to the saved choice', () {
      expect(resolve('https://a.app/?lang=de', 'cs'), const Locale('cs'));
      expect(LocaleBloc.languageFromUrl(Uri.parse('https://a.app/?lang=de')),
          isNull);
    });
  });

  group('LocaleBloc', () {
    blocTest<LocaleBloc, LocaleState>(
      'changes to a supported language and saves it; ignores others',
      build: LocaleBloc.new,
      act: (b) => b
        ..add(const LocaleChanged('ar'))
        ..add(const LocaleChanged('xx')),
      expect: () => const [LocaleState(locale: Locale('ar'))],
      verify: (_) async {
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString(LocaleBloc.prefsKey), 'ar');
      },
    );

    blocTest<LocaleBloc, LocaleState>(
      'next language cycles English → Arabic → Czech → English',
      build: LocaleBloc.new,
      act: (b) => b
        ..add(const NextLocaleRequested())
        ..add(const NextLocaleRequested())
        ..add(const NextLocaleRequested()),
      expect: () => const [
        LocaleState(locale: Locale('ar')),
        LocaleState(locale: Locale('cs')),
        LocaleState(),
      ],
    );
  });
}
