import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/bloc/locale/locale_bloc.dart';
import 'package:profile/core/bloc/locale/locale_event.dart';
import 'package:profile/core/bloc/locale/locale_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('LocaleBloc Test Suite', () {
    test('initial state defaults to English LTR locale', () {
      final bloc = LocaleBloc();
      expect(bloc.state.locale.languageCode, equals('en'));
      expect(bloc.state.isRtl, isFalse);
      bloc.close();
    });

    test('LocaleChanged updates locale for supported language codes', () async {
      final bloc = LocaleBloc();

      bloc.add(const LocaleChanged('ar'));
      await expectLater(
        bloc.stream,
        emits(predicate<LocaleState>(
            (s) => s.locale.languageCode == 'ar' && s.isRtl)),
      );

      bloc.add(const LocaleChanged('cs'));
      await expectLater(
        bloc.stream,
        emits(predicate<LocaleState>(
            (s) => s.locale.languageCode == 'cs' && !s.isRtl)),
      );

      await bloc.close();
    });

    test('LocaleChanged rejects unsupported language code', () async {
      final bloc = LocaleBloc();

      bloc.add(const LocaleChanged('fr'));
      // No emission expected for unsupported language
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(bloc.state.locale.languageCode, equals('en'));

      await bloc.close();
    });

    test('NextLocaleRequested cycles through en -> ar -> cs -> en', () async {
      final bloc = LocaleBloc();

      bloc.add(const NextLocaleRequested());
      await expectLater(
        bloc.stream,
        emits(predicate<LocaleState>((s) => s.locale.languageCode == 'ar')),
      );

      bloc.add(const NextLocaleRequested());
      await expectLater(
        bloc.stream,
        emits(predicate<LocaleState>((s) => s.locale.languageCode == 'cs')),
      );

      bloc.add(const NextLocaleRequested());
      await expectLater(
        bloc.stream,
        emits(predicate<LocaleState>((s) => s.locale.languageCode == 'en')),
      );

      await bloc.close();
    });

    test('LocaleStarted loads persisted locale from SharedPreferences',
        () async {
      SharedPreferences.setMockInitialValues({'localeCode': 'ar'});
      final bloc = LocaleBloc();

      bloc.add(const LocaleStarted());
      await expectLater(
        bloc.stream,
        emits(predicate<LocaleState>(
            (s) => s.locale.languageCode == 'ar' && s.isRtl)),
      );

      await bloc.close();
    });
  });
}
