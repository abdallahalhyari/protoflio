import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/case_study/case_study_eskadenia.dart';
import 'package:profile/features/case_study/case_study_fais.dart';
import 'package:profile/features/case_study/case_study_nathealth.dart';
import 'package:profile/features/case_study/case_study_solutions.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/theme/app_theme.dart';

Future<List<String>> _open(
    WidgetTester tester, Widget study, Locale locale, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final errors = <String>[];
  final previous = FlutterError.onError;
  FlutterError.onError = (d) => errors.add(d.exceptionAsString());
  addTearDown(() => FlutterError.onError = previous);
  await tester.pumpWidget(MaterialApp(
    theme: AppTheme.dark(),
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    // As CaseStudyRouter presents it: in the reader's own direction.
    home: study,
  ));
  await tester.pump(const Duration(seconds: 1));
  FlutterError.onError = previous;
  return errors;
}

void main() {
  testWidgets('Czech: frame and summary translated, English-content note',
      (tester) async {
    await _open(tester, const NatHealthCaseStudy(), const Locale('cs'),
        const Size(1280, 900));
    expect(find.text('NATHEALTH · PŘÍPADOVÁ STUDIE'), findsOneWidget);
    expect(find.text('VÝZVA'), findsOneWidget);
    expect(find.text('CO JSEM VYTVOŘIL'), findsOneWidget);
    expect(find.textContaining('Ověření karty za méně než sekundu'),
        findsOneWidget);
    // Lazy list: the note sits just below the first screen in Czech.
    await tester.scrollUntilVisible(
        find.text('Podrobný technický rozbor níže je v angličtině.'), 300,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('PROBLÉM'), findsWidgets);
  });

  testWidgets('Arabic: right-to-left with translated frame', (tester) async {
    await _open(tester, const FaisCaseStudy(), const Locale('ar'),
        const Size(1280, 900));
    expect(find.text('التحدي'), findsOneWidget);
    // Translated summary reads right-to-left; the English body stays
    // left-to-right.
    expect(Directionality.of(tester.element(find.text('التحدي'))),
        TextDirection.rtl);
    await tester.scrollUntilVisible(
        find.text('التفاصيل التقنية أدناه باللغة الإنجليزية.'), 300,
        scrollable: find.byType(Scrollable).first);
    final englishBody =
        find.textContaining('Future Advanced Internet Solutions (FAIS)');
    await tester.scrollUntilVisible(englishBody, 300,
        scrollable: find.byType(Scrollable).first);
    expect(Directionality.of(tester.element(englishBody)), TextDirection.ltr);
  });

  testWidgets('English: no language note', (tester) async {
    await _open(tester, const NatHealthCaseStudy(), const Locale('en'),
        const Size(1280, 900));
    expect(find.text('CHALLENGE'), findsOneWidget);
    expect(find.byIcon(Icons.translate_rounded), findsNothing);
  });

  const studies = <String, Widget>{
    'nathealth': NatHealthCaseStudy(),
    'eskadenia': EskadeniaCaseStudy(),
    'solutions': SolutionsCaseStudy(),
    'fais': FaisCaseStudy(),
  };
  // Every section, not just the first screen: the article is a lazy list,
  // so scroll to the end while collecting errors. 900-1024 is the desktop
  // band where the chapter dock is at its widest relative to the screen.
  const configs = <(Size, double)>[
    (Size(1280, 900), 1.0),
    (Size(900, 700), 1.0),
    (Size(1024, 700), 2.0),
    (Size(360, 740), 1.0),
    (Size(360, 740), 2.0),
  ];
  for (final locale in const [Locale('en'), Locale('cs'), Locale('ar')]) {
    for (final entry in studies.entries) {
      for (final (size, scale) in configs) {
        testWidgets(
            '${entry.key} lays out cleanly in ${locale.languageCode} '
            '@ ${size.width.toInt()} x$scale', (tester) async {
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          final errors = <String>[];
          final previous = FlutterError.onError;
          FlutterError.onError = (d) => errors.add(
              '${d.exceptionAsString().split('\n').first} @ '
              '${RegExp(r'lib/[\w/]+\.dart:\d+').firstMatch(d.toString())?.group(0)}');
          addTearDown(() => FlutterError.onError = previous);
          await _open(tester, entry.value, locale, size);
          FlutterError.onError = (d) => errors.add(
              '${d.exceptionAsString().split('\n').first} @ '
              '${RegExp(r'lib/[\w/]+\.dart:\d+').firstMatch(d.toString())?.group(0)}');
          final scrollable = find.byType(Scrollable).first;
          for (var i = 0; i < 80; i++) {
            final position = tester.state<ScrollableState>(scrollable).position;
            if (position.pixels >= position.maxScrollExtent) break;
            await tester.drag(scrollable, const Offset(0, -500));
            await tester.pump(const Duration(milliseconds: 60));
          }
          await tester.pump(const Duration(milliseconds: 400));
          FlutterError.onError = previous;
          expect(errors.toSet(), isEmpty);
        });
      }
    }
  }
}
