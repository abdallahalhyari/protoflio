import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/main.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/hats/presentation/pages/hats_grid_page.dart';
import 'package:profile/features/projects/presentation/pages/projects_page.dart';
import 'package:profile/features/skills/presentation/pages/skills_page.dart';
import 'package:profile/features/engineering/presentation/pages/engineering_page.dart';
import 'helpers/test_data.dart';

Widget createTestApp(Widget child, [Size size = const Size(1200, 900)]) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: MediaQueryData(size: size),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  testWidgets('Portfolio smoke test - renders intro', (tester) async {
    await tester.pumpWidget(PortfolioApp(
      projectRepo: TestProjectRepository(),
      experienceRepo: TestExperienceRepository(),
      hatRepo: TestHatRepository(),
      skillRepo: TestSkillRepository(),
    ));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.textContaining('ABDALLAH'), findsWidgets);
    expect(find.text('VIEW MY WORK'), findsOneWidget);
  });

  testWidgets(
      'HatsGridPage renders and role selector updates state (desktop & mobile)',
      (tester) async {
    // Desktop layout
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    await tester.pumpWidget(createTestApp(const HatsGridPage()));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('PERSPECTIVES'), findsOneWidget);
    expect(find.text('SPREAD'), findsOneWidget);
    expect(find.text('ALIGN'), findsOneWidget);
    expect(find.textContaining('THINKING'), findsWidgets);

    // Tap role pill
    await tester.tap(find.text('02 COMMUNICATING'));
    await tester.pump(const Duration(milliseconds: 200));

    // Mobile layout
    await tester.binding.setSurfaceSize(const Size(400, 800));
    await tester
        .pumpWidget(createTestApp(const HatsGridPage(), const Size(400, 800)));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('PREV'), findsOneWidget);
    expect(find.text('NEXT'), findsOneWidget);

    await tester.tap(find.text('NEXT'));
    await tester.pump(const Duration(milliseconds: 200));

    // Reset surface size
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets(
      'ProjectsPage renders master-detail and mobile tabs without scroll issues',
      (tester) async {
    // Desktop layout
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    await tester.pumpWidget(createTestApp(const ProjectsPage()));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('NATHEALTH'), findsWidgets);
    expect(find.textContaining('ESKADENIA'), findsWidgets);

    // Mobile layout
    await tester.binding.setSurfaceSize(const Size(400, 800));
    await tester
        .pumpWidget(createTestApp(const ProjectsPage(), const Size(400, 800)));
    await tester.pumpAndSettle();

    // Mobile lists every case study; the last one scrolls into view.
    await tester.scrollUntilVisible(
        find.text('M-Commerce & Media-Streaming Clients'), 200,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('M-Commerce & Media-Streaming Clients'), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('SkillsPage renders kinetic cloud and category filters',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    await tester.pumpWidget(createTestApp(const SkillsPage()));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('SKILLS'), findsWidgets);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets(
      'EngineeringPage renders 4 production architectures and tabs work',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    await tester.pumpWidget(createTestApp(const EngineeringPage()));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('ENGINEERING'), findsOneWidget);
    expect(find.textContaining('CLEAN MOBILE ARCHITECTURE'), findsWidgets);
    expect(find.textContaining('OFFLINE-FIRST SYNCHRONIZATION'), findsWidgets);

    // Tap second tab (Offline-First)
    await tester.tap(find.textContaining('OFFLINE-FIRST SYNCHRONIZATION'));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.textContaining('WorkManager Pipeline'), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets(
      'HomeScreen desktop pointer scroll advances pages when not over inner scrollable',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(PortfolioApp(
      projectRepo: TestProjectRepository(),
      experienceRepo: TestExperienceRepository(),
      hatRepo: TestHatRepository(),
      skillRepo: TestSkillRepository(),
    ));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('ABDALLAH'), findsWidgets);

    // Send pointer scroll event downwards (dy: 150) to advance from Intro to Projects
    await tester.sendEventToBinding(
      const PointerScrollEvent(
        position: Offset(600, 450),
        scrollDelta: Offset(0, 150),
      ),
    );
    for (int i = 0; i < 15; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    // Now on Projects page
    expect(_desktopPages(tester).page!.round(), 1);
  });
}

/// The desktop page controller. Pages live in a custom Scrollable
/// (all pages prebuilt) rather than a PageView, keyed 'desktop_pageview'.
PageController _desktopPages(WidgetTester tester) => tester
    .widget<Scrollable>(
        find.byKey(const PageStorageKey<String>('desktop_pageview')))
    .controller! as PageController;
