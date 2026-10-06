import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:profile/core/theme/app_theme.dart';
import 'package:profile/features/case_study/presentation/pages/case_study_eskadenia.dart';
import 'package:profile/features/case_study/presentation/pages/case_study_fais.dart';
import 'package:profile/features/case_study/presentation/pages/case_study_nathealth.dart';
import 'package:profile/features/case_study/presentation/pages/case_study_solutions.dart';
import 'package:profile/features/case_study/presentation/widgets/case_study_widgets.dart';
import 'package:profile/features/projects/domain/repositories/project_repository.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'helpers/test_data.dart';

Widget _wrap(Widget child, [Size size = const Size(1200, 900)]) {
  return MaterialApp(
    theme: AppTheme.dark(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: MediaQueryData(size: size),
      child: RepositoryProvider<ProjectRepository>(
        create: (_) => TestProjectRepository(),
        child: Material(child: child),
      ),
    ),
  );
}

void main() {
  group('Case Study Pages Test Suite', () {
    testWidgets(
        'NatHealthCaseStudy renders all chapters and outcomes (Desktop & Mobile)',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 5000));
      await tester.pumpWidget(_wrap(const NatHealthCaseStudy()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('NATHEALTH · Case study'), findsOneWidget);
      expect(find.text('NatHealth Mobile Suite'), findsOneWidget);
      expect(find.text('The problem'), findsOneWidget);
      expect(find.text('My role'), findsOneWidget);
      expect(find.text('System architecture'), findsOneWidget);
      expect(find.text('Outcomes'), findsOneWidget);
      expect(find.text('Lessons'), findsOneWidget);
      expect(find.text('2M+'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Back to portfolio'), 800,
          scrollable: find.byType(Scrollable).first);
      expect(find.text('Back to portfolio'), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Mobile
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester
          .pumpWidget(_wrap(const NatHealthCaseStudy(), const Size(390, 844)));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('NATHEALTH · Case study'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets(
        'EskadeniaCaseStudy renders all chapters and outcomes (Desktop & Mobile)',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 5000));
      await tester.pumpWidget(_wrap(const EskadeniaCaseStudy()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('ESKADENIA · Case study'), findsOneWidget);
      expect(find.text('E-Learning & Healthcare Enterprise Suite'),
          findsOneWidget);
      expect(find.text('The problem'), findsOneWidget);
      expect(find.text('My role'), findsOneWidget);
      expect(find.text('System architecture'), findsOneWidget);
      expect(find.text('Outcomes'), findsOneWidget);
      expect(find.text('Lessons'), findsOneWidget);
      expect(find.text('60 FPS'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Back to portfolio'), 800,
          scrollable: find.byType(Scrollable).first);
      expect(find.text('Back to portfolio'), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Mobile
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester
          .pumpWidget(_wrap(const EskadeniaCaseStudy(), const Size(390, 844)));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('ESKADENIA · Case study'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets(
        'SolutionsCaseStudy renders all chapters and outcomes (Desktop & Mobile)',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 5000));
      await tester.pumpWidget(_wrap(const SolutionsCaseStudy()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('SOLUTIONS NOW · Case study'), findsOneWidget);
      expect(find.text('Loyalty Rewards & Ephemeral Social Media Apps'),
          findsOneWidget);
      expect(find.text('The problem'), findsOneWidget);
      expect(find.text('My role'), findsOneWidget);
      expect(find.text('System architecture'), findsOneWidget);
      expect(find.text('Outcomes'), findsOneWidget);
      expect(find.text('Lessons'), findsOneWidget);
      expect(find.text('50k+'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Back to portfolio'), 800,
          scrollable: find.byType(Scrollable).first);
      expect(find.text('Back to portfolio'), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Mobile
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester
          .pumpWidget(_wrap(const SolutionsCaseStudy(), const Size(390, 844)));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('SOLUTIONS NOW · Case study'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets(
        'FaisCaseStudy renders all chapters and outcomes (Desktop & Mobile)',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 5000));
      await tester.pumpWidget(_wrap(const FaisCaseStudy()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('FAIS · Case study'), findsOneWidget);
      expect(find.text('M-Commerce & Media-Streaming Clients'), findsOneWidget);
      expect(find.text('The problem'), findsOneWidget);
      expect(find.text('My role'), findsOneWidget);
      expect(find.text('System architecture'), findsOneWidget);
      expect(find.text('Outcomes'), findsOneWidget);
      expect(find.text('Lessons'), findsOneWidget);
      expect(find.text('99.8%'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Back to portfolio'), 800,
          scrollable: find.byType(Scrollable).first);
      expect(find.text('Back to portfolio'), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Mobile
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester
          .pumpWidget(_wrap(const FaisCaseStudy(), const Size(390, 844)));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('FAIS · Case study'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('AtAGlance renders company metrics properly', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester
          .pumpWidget(_wrap(const NatHealthCaseStudy(), const Size(1200, 800)));
      await tester.pumpAndSettle();

      expect(find.byType(CaseStudyAtAGlance), findsOneWidget);
      expect(find.text('Challenge'), findsOneWidget);
      expect(find.text('What I built'), findsOneWidget);
      expect(find.text('Result'), findsOneWidget);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('Outcomes grid renders bullet impact metrics', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester
          .pumpWidget(_wrap(const NatHealthCaseStudy(), const Size(1200, 800)));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.byType(OutcomeGrid), 500,
          scrollable: find.byType(Scrollable).first);
      expect(find.byType(OutcomeGrid), findsOneWidget);
      expect(find.text('Outcomes'), findsOneWidget);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('TechnicalChapters renders step breakdowns with badges',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester
          .pumpWidget(_wrap(const NatHealthCaseStudy(), const Size(1200, 800)));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.text('04'), 500,
          scrollable: find.byType(Scrollable).first);
      expect(find.byType(TechnicalChapter), findsWidgets);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets(
        'Case study masthead renders corporate verification links and share action',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester
          .pumpWidget(_wrap(const NatHealthCaseStudy(), const Size(1200, 800)));
      await tester.pumpAndSettle();

      expect(find.byType(CaseStudyCorporateHeader), findsOneWidget);
      expect(find.byType(CaseStudyToolbarShareButton), findsOneWidget);
      expect(find.text('Company website'), findsOneWidget);
      expect(find.text('Company LinkedIn'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);

      // Tap toolbar share button
      await tester.tap(find.byType(CaseStudyToolbarShareButton));
      await tester.pump(const Duration(milliseconds: 500));
      if (find.text('COPY LINK').evaluate().isNotEmpty) {
        await tester.tap(find.text('COPY LINK'));
        await tester.pumpAndSettle();
      }

      // Tap masthead share pill
      await tester.tap(find.text('Share'));
      await tester.pump(const Duration(milliseconds: 500));
      if (find.text('COPY LINK').evaluate().isNotEmpty) {
        await tester.tap(find.text('COPY LINK'));
        await tester.pumpAndSettle();
      }

      expect(tester.takeException(), isNull);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets(
        'CaseStudyReadingCompanion renders top progress bar, reveals dock on scroll, jumps to chapters and back to top',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester
          .pumpWidget(_wrap(const NatHealthCaseStudy(), const Size(1200, 800)));
      await tester.pump(const Duration(milliseconds: 300));

      // Verify top reading progress bar is present
      expect(find.byType(CaseStudyReadingCompanion), findsOneWidget);

      // Scroll down to trigger the floating chapter dock
      final scrollable = find.byType(Scrollable).first;
      await tester.drag(scrollable, const Offset(0, -600));
      await tester.pumpAndSettle();

      // Tap chapter 2 jump button in companion dock
      final ch2Button = find.byKey(const Key('case_study_chapter_role'));
      expect(ch2Button, findsOneWidget);
      await tester.tap(ch2Button);
      await tester.pumpAndSettle();

      // Tap back-to-top pill
      final backToTopButton = find.byKey(const Key('case_study_back_to_top'));
      expect(backToTopButton, findsOneWidget);
      await tester.tap(backToTopButton);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('CaseStudyReadingCompanion adapts cleanly to mobile viewport',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester
          .pumpWidget(_wrap(const NatHealthCaseStudy(), const Size(390, 844)));
      await tester.pump(const Duration(milliseconds: 300));

      final scrollable = find.byType(Scrollable).first;
      await tester.drag(scrollable, const Offset(0, -600));
      await tester.pumpAndSettle();

      final ch3Button =
          find.byKey(const Key('case_study_chapter_architecture'));
      expect(ch3Button, findsOneWidget);
      await tester.tap(ch3Button);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      await tester.binding.setSurfaceSize(null);
    });
  });
}
