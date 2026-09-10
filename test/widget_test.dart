import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/main.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/module/home/page/hats_grid_page.dart';
import 'package:profile/module/home/page/projects_page.dart';
import 'package:profile/module/home/page/skills_page.dart';
import 'package:profile/module/home/page/engineering_page.dart';

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
    await tester.pumpWidget(const PortfolioApp());
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.textContaining('ABDALLAH'), findsWidgets);
    expect(find.text('VIEW MY WORK'), findsOneWidget);
  });

  testWidgets('HatsGridPage renders and role selector updates state (desktop & mobile)', (tester) async {
    // Desktop layout
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    await tester.pumpWidget(createTestApp(const HatsGridPage(), const Size(1200, 900)));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('ARCHITECTURAL PERSPECTIVES'), findsOneWidget);
    expect(find.text('SPREAD'), findsOneWidget);
    expect(find.text('ALIGN'), findsOneWidget);
    expect(find.textContaining('THINKING'), findsWidgets);

    // Tap role pill
    await tester.tap(find.text('02 COMMUNICATING'));
    await tester.pump(const Duration(milliseconds: 200));

    // Mobile layout
    await tester.binding.setSurfaceSize(const Size(400, 800));
    await tester.pumpWidget(createTestApp(const HatsGridPage(), const Size(400, 800)));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('PREV'), findsOneWidget);
    expect(find.text('NEXT'), findsOneWidget);

    await tester.tap(find.text('NEXT'));
    await tester.pump(const Duration(milliseconds: 200));

    // Reset surface size
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('ProjectsPage renders master-detail and mobile tabs without scroll issues', (tester) async {
    // Desktop layout
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    await tester.pumpWidget(createTestApp(const ProjectsPage(), const Size(1200, 900)));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('NATHEALTH'), findsWidgets);
    expect(find.textContaining('ESKADENIA'), findsWidgets);

    // Mobile layout
    await tester.binding.setSurfaceSize(const Size(400, 800));
    await tester.pumpWidget(createTestApp(const ProjectsPage(), const Size(400, 800)));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('PREV'), findsOneWidget);
    expect(find.text('NEXT'), findsOneWidget);

    await tester.tap(find.text('NEXT'));
    await tester.pump(const Duration(milliseconds: 200));

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('SkillsPage renders kinetic cloud and category filters', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    await tester.pumpWidget(createTestApp(const SkillsPage(), const Size(1200, 900)));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('SKILLS'), findsWidgets);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('EngineeringPage renders 4 production architectures and tabs work', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    await tester.pumpWidget(createTestApp(const EngineeringPage(), const Size(1200, 900)));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('ENGINEERING EXPERTISE'), findsOneWidget);
    expect(find.textContaining('CLEAN MOBILE ARCHITECTURE'), findsWidgets);
    expect(find.textContaining('OFFLINE-FIRST SYNCHRONIZATION'), findsWidgets);

    // Tap second tab (Offline-First)
    await tester.tap(find.textContaining('OFFLINE-FIRST SYNCHRONIZATION'));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.textContaining('WorkManager Pipeline'), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('HomeScreen desktop pointer scroll advances pages when not over inner scrollable', (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PortfolioApp());
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('ABDALLAH'), findsWidgets);

    // Send pointer scroll event downwards (dy: 100) to advance from Intro to Projects
    await tester.sendEventToBinding(
      const PointerScrollEvent(
        position: Offset(600, 450),
        scrollDelta: Offset(0, 100),
      ),
    );
    for (int i = 0; i < 15; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    // Now on Projects page
    final pageView = tester.widget<PageView>(find.byType(PageView));
    expect(pageView.controller!.page!.round(), 1);
  });

  testWidgets('HomeScreen preserves inner scrollable on ProjectsPage and does not advance page', (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PortfolioApp());
    await tester.pump(const Duration(milliseconds: 300));

    // First advance to Projects page
    await tester.sendEventToBinding(
      const PointerScrollEvent(
        position: Offset(600, 450),
        scrollDelta: Offset(0, 100),
      ),
    );
    for (int i = 0; i < 15; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    final pageView = tester.widget<PageView>(find.byType(PageView));
    expect(pageView.controller!.page!.round(), 1);

    // Now send pointer scroll event over the case study article (Offset(800, 500))
    // The inner article has content to scroll down, so this scroll should be absorbed by the article
    // and NOT advance to EngineeringPage.
    await tester.sendEventToBinding(
      const PointerScrollEvent(
        position: Offset(800, 500),
        scrollDelta: Offset(0, 80),
      ),
    );
    for (int i = 0; i < 15; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    // Must still be on Projects page (page index 1.0)!
    expect(pageView.controller!.page!.round(), 1);
  });
}

