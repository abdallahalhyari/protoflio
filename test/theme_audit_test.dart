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
import 'package:profile/module/home/widget/portfolio_nav.dart';
import 'package:profile/theme/app_theme.dart';

Widget createThemedTestApp({
  required Widget child,
  required Brightness brightness,
  Size size = const Size(1200, 900),
}) {
  return MaterialApp(
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    themeMode: brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: MediaQueryData(size: size),
      child: Scaffold(
        body: child,
      ),
    ),
  );
}

void main() {
  group('Light & Dark Mode Theme Audit', () {
    for (final brightness in [Brightness.dark, Brightness.light]) {
      final modeName = brightness == Brightness.dark ? 'Dark Mode' : 'Light Mode';

      testWidgets('$modeName - IntroPage renders cleanly', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 900));
        final controller = PageController();
        await tester.pumpWidget(createThemedTestApp(
          child: IntroPage(
            onScrollDown: () {},
            controller: controller,
            pageIndex: 0,
          ),
          brightness: brightness,
        ));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.textContaining('ABDALLAH'), findsWidgets);
        expect(find.text('VIEW MY WORK'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('$modeName - ProjectsPage desktop & mobile render adaptively', (tester) async {
        // Desktop
        await tester.binding.setSurfaceSize(const Size(1200, 900));
        await tester.pumpWidget(createThemedTestApp(
          child: const ProjectsPage(),
          brightness: brightness,
          size: const Size(1200, 900),
        ));
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.textContaining('CASE STUDIES'), findsWidgets);
        expect(tester.takeException(), isNull);

        // Mobile
        await tester.binding.setSurfaceSize(const Size(390, 844));
        await tester.pumpWidget(createThemedTestApp(
          child: const ProjectsPage(),
          brightness: brightness,
          size: const Size(390, 844),
        ));
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.textContaining('SELECTED WORK'), findsWidgets);
        expect(tester.takeException(), isNull);

        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('$modeName - EngineeringPage renders architecture blueprints', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 900));
        await tester.pumpWidget(createThemedTestApp(
          child: const EngineeringPage(),
          brightness: brightness,
        ));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.textContaining('CLEAN MOBILE ARCHITECTURE'), findsWidgets);
        expect(tester.takeException(), isNull);
        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('$modeName - ExperiencePage renders timeline and academic annex', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 900));
        final ctrl = PageController();
        await tester.pumpWidget(createThemedTestApp(
          child: ExperiencePage(controller: ctrl, pageIndex: 3),
          brightness: brightness,
        ));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.textContaining('CAREER TRAJECTORY'), findsWidgets);
        expect(tester.takeException(), isNull);
        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('$modeName - SkillsPage renders category chips and collectible skills', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 900));
        await tester.pumpWidget(createThemedTestApp(
          child: const SkillsPage(),
          brightness: brightness,
        ));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.textContaining('SKILLS'), findsWidgets);
        expect(tester.takeException(), isNull);
        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('$modeName - HatsGridPage renders perspectives and action buttons', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 900));
        await tester.pumpWidget(createThemedTestApp(
          child: const HatsGridPage(),
          brightness: brightness,
          size: const Size(1200, 900),
        ));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('ARCHITECTURAL PERSPECTIVES'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('$modeName - ContactPage renders availability and communication channels', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 900));
        final controller = PageController();
        await tester.pumpWidget(createThemedTestApp(
          child: ContactPage(controller: controller, pageIndex: 6),
          brightness: brightness,
        ));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.textContaining('DIRECT LINE'), findsWidgets);
        expect(tester.takeException(), isNull);
        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('$modeName - PortfolioNav TopNav and MobileNav adapt to theme', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 900));
        await tester.pumpWidget(createThemedTestApp(
          child: Column(
            children: [
              TopNav(current: 0, onTap: (_) {}, onResume: () {}),
              MobileNav(current: 0, onTap: (_) {}, onResume: () {}),
            ],
          ),
          brightness: brightness,
        ));
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.byType(TopNav), findsOneWidget);
        expect(find.byType(MobileNav), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.binding.setSurfaceSize(null);
      });
    }
  });
}
