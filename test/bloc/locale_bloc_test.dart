import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/bloc/locale/locale_bloc.dart';
import 'package:profile/core/bloc/locale/locale_event.dart';
import 'package:profile/core/bloc/locale/locale_state.dart';
import 'package:profile/locale_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocaleBloc Test Suite', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('initial state defaults to English', () async {
      final bloc = LocaleBloc();
      expect(bloc.state.locale, equals(const Locale('en')));
      expect(bloc.state.isRtl, isFalse);
      await bloc.close();
    });

    test('LocaleStarted reads stored preference', () async {
      SharedPreferences.setMockInitialValues({'localeCode': 'ar'});
      final bloc = LocaleBloc();

      bloc.add(const LocaleStarted());
      await expectLater(
        bloc.stream,
        emits(const LocaleState(locale: Locale('ar'))),
      );
      expect(bloc.state.isRtl, isTrue);

      await bloc.close();
    });

    test('LocaleChanged updates language and persists preference', () async {
      final bloc = LocaleBloc();

      bloc.add(const LocaleChanged('cs'));
      await expectLater(
        bloc.stream,
        emits(const LocaleState(locale: Locale('cs'))),
      );
      expect(bloc.state.isRtl, isFalse);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('localeCode'), equals('cs'));

      await bloc.close();
    });

    test(
        'NextLocaleRequested cycles supported languages [en -> ar -> cs -> en]',
        () async {
      final bloc = LocaleBloc(initialLocale: const Locale('en'));

      bloc.add(const NextLocaleRequested());
      await expectLater(
        bloc.stream,
        emits(const LocaleState(locale: Locale('ar'))),
      );

      bloc.add(const NextLocaleRequested());
      await expectLater(
        bloc.stream,
        emits(const LocaleState(locale: Locale('cs'))),
      );

      bloc.add(const NextLocaleRequested());
      await expectLater(
        bloc.stream,
        emits(const LocaleState(locale: Locale('en'))),
      );

      await bloc.close();
    });

    test('LocaleBloc bi-directionally synchronizes with LocaleController',
        () async {
      final bloc = LocaleBloc();

      LocaleController.changeLocale('ar');
      await expectLater(
        bloc.stream,
        emits(const LocaleState(locale: Locale('ar'))),
      );

      bloc.add(const LocaleChanged('cs'));
      await expectLater(
        bloc.stream,
        emits(const LocaleState(locale: Locale('cs'))),
      );
      expect(LocaleController.locale.value, equals(const Locale('cs')));

      await bloc.close();
    });
  });
}
