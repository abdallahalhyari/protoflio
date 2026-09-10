import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/module/home/page/intro_page.dart';
import 'package:profile/module/home/page/projects_page.dart';
import 'package:profile/module/home/page/engineering_page.dart';
import 'package:profile/module/home/page/experience_page.dart';
import 'package:profile/module/home/page/skills_page.dart';
import 'package:profile/module/home/page/hats_grid_page.dart';
import 'package:profile/module/home/page/contact_page.dart';

Widget createTestPage(Widget page, Size size) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: MediaQueryData(size: size),
      child: Scaffold(
        body: page,
      ),
    ),
  );
}

void main() {
  final testSizes = [
    const Size(320, 568), // Ultra-compact mobile (iPhone SE1)
    const Size(360, 780), // Standard Android compact
    const Size(390, 844), // iPhone standard
    const Size(768, 1024), // Tablet / iPad
  ];

  for (final size in testSizes) {
    group('Viewport ${size.width.toInt()}x${size.height.toInt()}', () {
      testWidgets('IntroPage audit', (tester) async {
        await tester.binding.setSurfaceSize(size);
        final ctrl = PageController();
        await tester.pumpWidget(createTestPage(
          IntroPage(onScrollDown: () {}, controller: ctrl, pageIndex: 0),
          size,
        ));
        await tester.pump(const Duration(milliseconds: 300));
        final err = tester.takeException();
        expect(err, isNull);
      });

      testWidgets('ProjectsPage audit', (tester) async {
        await tester.binding.setSurfaceSize(size);
        final ctrl = PageController();
        await tester.pumpWidget(createTestPage(
          ProjectsPage(controller: ctrl, pageIndex: 1),
          size,
        ));
        await tester.pump(const Duration(milliseconds: 300));
        final err = tester.takeException();
        expect(err, isNull);
      });

      testWidgets('EngineeringPage audit', (tester) async {
        await tester.binding.setSurfaceSize(size);
        final ctrl = PageController();
        await tester.pumpWidget(createTestPage(
          EngineeringPage(controller: ctrl, pageIndex: 2),
          size,
        ));
        await tester.pump(const Duration(milliseconds: 300));
        final err = tester.takeException();
        expect(err, isNull);
      });

      testWidgets('ExperiencePage audit', (tester) async {
        await tester.binding.setSurfaceSize(size);
        final ctrl = PageController();
        await tester.pumpWidget(createTestPage(
          ExperiencePage(controller: ctrl, pageIndex: 3),
          size,
        ));
        await tester.pump(const Duration(milliseconds: 300));
        final err = tester.takeException();
        expect(err, isNull);
      });

      testWidgets('SkillsPage audit', (tester) async {
        await tester.binding.setSurfaceSize(size);
        final ctrl = PageController();
        await tester.pumpWidget(createTestPage(
          SkillsPage(controller: ctrl, pageIndex: 4),
          size,
        ));
        await tester.pump(const Duration(milliseconds: 300));
        final err = tester.takeException();
        expect(err, isNull);
      });

      testWidgets('HatsGridPage audit', (tester) async {
        await tester.binding.setSurfaceSize(size);
        await tester.pumpWidget(createTestPage(
          const HatsGridPage(),
          size,
        ));
        await tester.pump(const Duration(milliseconds: 300));
        final err = tester.takeException();
        expect(err, isNull);
      });

      testWidgets('ContactPage audit', (tester) async {
        await tester.binding.setSurfaceSize(size);
        final ctrl = PageController();
        await tester.pumpWidget(createTestPage(
          ContactPage(controller: ctrl, pageIndex: 6),
          size,
        ));
        await tester.pump(const Duration(milliseconds: 300));
        final err = tester.takeException();
        expect(err, isNull);
      });
    });
  }
}
