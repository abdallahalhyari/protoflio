import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/module/case_study/case_study_eskadenia.dart';
import 'package:profile/module/case_study/case_study_fais.dart';
import 'package:profile/module/case_study/case_study_nathealth.dart';
import 'package:profile/module/case_study/case_study_solutions.dart';
import 'package:profile/module/case_study/case_study_widgets.dart';
import 'package:profile/theme/app_theme.dart';

Widget _wrap(Widget child, [Size size = const Size(1200, 5000)]) {
  return MaterialApp(
    theme: AppTheme.dark(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: MediaQueryData(size: size),
      child: child,
    ),
  );
}

void main() {
  group('Case Study Pages Test Suite', () {
    testWidgets('NatHealthCaseStudy renders all chapters and outcomes (Desktop & Mobile)',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 5000));
      await tester.pumpWidget(_wrap(const NatHealthCaseStudy()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('NATHEALTH · CASE STUDY'), findsOneWidget);
      expect(find.text('NatHealth Mobile Suite'), findsOneWidget);
      expect(find.text('THE PROBLEM'), findsOneWidget);
      expect(find.text('MY ROLE'), findsOneWidget);
      expect(find.text('SYSTEM ARCHITECTURE'), findsOneWidget);
      expect(find.text('OUTCOMES'), findsOneWidget);
      expect(find.text('LESSONS'), findsOneWidget);
      expect(find.text('Back to portfolio'), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Mobile
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(_wrap(const NatHealthCaseStudy(), const Size(390, 844)));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('NATHEALTH · CASE STUDY'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('EskadeniaCaseStudy renders all chapters and outcomes (Desktop & Mobile)',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 5000));
      await tester.pumpWidget(_wrap(const EskadeniaCaseStudy()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('ESKADENIA · CASE STUDY'), findsOneWidget);
      expect(find.text('E-Learning & Healthcare Enterprise Suite'), findsOneWidget);
      expect(find.text('THE PROBLEM'), findsOneWidget);
      expect(find.text('MY ROLE'), findsOneWidget);
      expect(find.text('SYSTEM ARCHITECTURE'), findsOneWidget);
      expect(find.text('OUTCOMES'), findsOneWidget);
      expect(find.text('LESSONS'), findsOneWidget);
      expect(find.text('60 FPS'), findsOneWidget);
      expect(find.text('Back to portfolio'), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Mobile
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(_wrap(const EskadeniaCaseStudy(), const Size(390, 844)));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('ESKADENIA · CASE STUDY'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('SolutionsCaseStudy renders all chapters and outcomes (Desktop & Mobile)',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 5000));
      await tester.pumpWidget(_wrap(const SolutionsCaseStudy()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('SOLUTIONS NOW · CASE STUDY'), findsOneWidget);
      expect(find.text('Loyalty Rewards & Ephemeral Social Media Apps'), findsOneWidget);
      expect(find.text('THE PROBLEM'), findsOneWidget);
      expect(find.text('MY ROLE'), findsOneWidget);
      expect(find.text('SYSTEM ARCHITECTURE'), findsOneWidget);
      expect(find.text('OUTCOMES'), findsOneWidget);
      expect(find.text('LESSONS'), findsOneWidget);
      expect(find.text('4.7+'), findsOneWidget);
      expect(find.text('Back to portfolio'), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Mobile
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(_wrap(const SolutionsCaseStudy(), const Size(390, 844)));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('SOLUTIONS NOW · CASE STUDY'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('FaisCaseStudy renders all chapters and outcomes (Desktop & Mobile)',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 5000));
      await tester.pumpWidget(_wrap(const FaisCaseStudy()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('FAIS · CASE STUDY'), findsOneWidget);
      expect(find.text('M-Commerce & Media-Streaming Clients'), findsOneWidget);
      expect(find.text('THE PROBLEM'), findsOneWidget);
      expect(find.text('MY ROLE'), findsOneWidget);
      expect(find.text('SYSTEM ARCHITECTURE'), findsOneWidget);
      expect(find.text('OUTCOMES'), findsOneWidget);
      expect(find.text('LESSONS'), findsOneWidget);
      expect(find.text('99.8%'), findsOneWidget);
      expect(find.text('Back to portfolio'), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Mobile
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(_wrap(const FaisCaseStudy(), const Size(390, 844)));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('FAIS · CASE STUDY'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('Case study masthead renders corporate verification links and share action',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 5000));
      await tester.pumpWidget(_wrap(const NatHealthCaseStudy()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(CaseStudyCorporateHeader), findsOneWidget);
      expect(find.byType(CaseStudyToolbarShareButton), findsOneWidget);
      expect(find.text('OFFICIAL WEBSITE'), findsOneWidget);
      expect(find.text('COMPANY LINKEDIN'), findsOneWidget);
      expect(find.text('SHARE STUDY'), findsOneWidget);

      // Tap toolbar share button with runAsync for platform channel
      await tester.runAsync(() async {
        await tester.tap(find.byType(CaseStudyToolbarShareButton));
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Case study link copied:'), findsOneWidget);

      // Tap masthead share pill
      await tester.runAsync(() async {
        await tester.tap(find.text('SHARE STUDY'));
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(SnackBar), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.binding.setSurfaceSize(null);
    });
  });
}
