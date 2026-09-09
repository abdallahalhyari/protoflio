import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/main.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/module/home/page/hats_grid_page.dart';
import 'package:profile/module/home/page/projects_page.dart';
import 'package:profile/module/home/page/skills_page.dart';

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
    expect(find.text('EXPLORE PUBLICATION'), findsOneWidget);
  });

  testWidgets('HatsGridPage renders and role selector updates state (desktop & mobile)', (tester) async {
    // Desktop layout
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    await tester.pumpWidget(createTestApp(const HatsGridPage(), const Size(1200, 900)));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('THE HATS SPREAD'), findsOneWidget);
    expect(find.text('SHUFFLE'), findsOneWidget);
    expect(find.text('RESET'), findsOneWidget);
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
    expect(find.text('ALL'), findsOneWidget);
    expect(find.textContaining('MOBILE SYSTEMS'), findsWidgets);

    await tester.binding.setSurfaceSize(null);
  });
}
