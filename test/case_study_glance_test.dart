import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/case_study/presentation/pages/case_study_eskadenia.dart';
import 'package:profile/features/case_study/presentation/pages/case_study_fais.dart';
import 'package:profile/features/case_study/presentation/pages/case_study_nathealth.dart';
import 'package:profile/features/case_study/presentation/pages/case_study_solutions.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/theme/app_theme.dart';

Future<void> _open(WidgetTester tester, Widget study, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(MaterialApp(
    theme: AppTheme.dark(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: study,
  ));
  await tester.pump(const Duration(seconds: 1));
}

/// The OUTCOMES kicker is built and inside the viewport.
bool _outcomesOnScreen(WidgetTester tester) {
  final kicker = find.text('OUTCOMES');
  if (kicker.evaluate().isEmpty) return false;
  final rect = tester.getRect(kicker.first);
  final screen = Offset.zero & tester.view.physicalSize;
  return screen.contains(rect.center);
}

void main() {
  const studies = {
    'nathealth': NatHealthCaseStudy(),
    'eskadenia': EskadeniaCaseStudy(),
    'solutions': SolutionsCaseStudy(),
    'fais': FaisCaseStudy(),
  };

  for (final entry in studies.entries) {
    testWidgets('${entry.key}: at-a-glance summary sits under the masthead',
        (tester) async {
      await _open(tester, entry.value, const Size(1280, 800));
      final glance = find.byKey(const Key('case_study_at_a_glance'));
      expect(glance, findsOneWidget);
      expect(find.text('CHALLENGE'), findsOneWidget);
      expect(find.text('WHAT I BUILT'), findsOneWidget);
      expect(find.text('RESULT'), findsOneWidget);
      // Visible without scrolling on a laptop screen.
      expect(tester.getRect(glance).top, lessThan(1000));
    });
  }

  for (final size in const [Size(1280, 800), Size(390, 844)]) {
    testWidgets('"See all outcomes" reaches the outcomes from the top ($size)',
        (tester) async {
      await _open(tester, const NatHealthCaseStudy(), size);
      expect(_outcomesOnScreen(tester), isFalse);
      await tester.scrollUntilVisible(
        find.byKey(const Key('case_study_glance_outcomes')),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump();
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(_outcomesOnScreen(tester), isFalse);
      await tester.tap(find.byKey(const Key('case_study_glance_outcomes')));
      await tester.pump();
      // Pump enough time for the sweep + scroll animation to finish.
      // PulsingDot has an infinite animation, so pumpAndSettle will timeout.
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 300));
        if (_outcomesOnScreen(tester)) break;
      }
      expect(_outcomesOnScreen(tester), isTrue);
    });
  }

  // Regression: the article is a lazy list, so the dock's jump to a chapter
  // that wasn't built yet silently did nothing.
  testWidgets('chapter dock jumps to outcomes that are not built yet',
      (tester) async {
    await _open(tester, const NatHealthCaseStudy(), const Size(1280, 800));
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
    await tester.pump();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.text('OUTCOMES'), findsNothing);
    await tester.tap(find.byKey(const Key('case_study_chapter_outcomes')));
    await tester.pump();
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 300));
      if (_outcomesOnScreen(tester)) break;
    }
    expect(_outcomesOnScreen(tester), isTrue);

    // And back up to a chapter that has been disposed above.
    await tester.tap(find.byKey(const Key('case_study_chapter_problem')));
    await tester.pump();
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 300));
      if (find.text('THE PROBLEM').evaluate().isNotEmpty) break;
    }
    expect(find.text('THE PROBLEM'), findsOneWidget);
  });
}
