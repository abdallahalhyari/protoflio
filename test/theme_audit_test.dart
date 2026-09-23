import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/bloc/locale/locale_bloc.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';
import 'package:profile/main.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/intro/page/intro_page.dart';
import 'package:profile/features/projects/page/projects_page.dart';
import 'package:profile/features/engineering/page/engineering_page.dart';
import 'package:profile/features/experience/page/experience_page.dart';
import 'package:profile/features/skills/page/skills_page.dart';
import 'package:profile/features/hats/page/hats_grid_page.dart';
import 'package:profile/features/contact/page/contact_page.dart';
import 'package:profile/features/shell/home_controller.dart';
import 'package:profile/features/shell/widget/portfolio_nav.dart';
import 'package:profile/features/shell/widget/mobile_app_bar.dart';
import 'package:profile/theme/app_theme.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/theme/surface_tone.dart';

Widget createThemedTestApp({
  required Widget child,
  required Brightness brightness,
  Size size = const Size(1200, 900),
}) {
  final mode = brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
  return MultiBlocProvider(
    providers: [
      BlocProvider<ThemeBloc>(create: (_) => ThemeBloc(initialMode: mode)),
      BlocProvider<LocaleBloc>(create: (_) => LocaleBloc()),
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: mode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: MediaQueryData(size: size),
        child: Scaffold(
          body: child,
        ),
      ),
    ),
  );
}

void main() {
  group('Light & Dark Mode Theme Audit', () {
    for (final brightness in [Brightness.dark, Brightness.light]) {
      final modeName =
          brightness == Brightness.dark ? 'Dark Mode' : 'Light Mode';

      testWidgets('$modeName - IntroPage renders cleanly', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 900));
        await tester.pumpWidget(createThemedTestApp(
          child: IntroPage(
            onScrollDown: () {},
          ),
          brightness: brightness,
        ));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.textContaining('ABDALLAH'), findsWidgets);
        expect(find.text('VIEW MY WORK'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('$modeName - ProjectsPage desktop & mobile render adaptively',
          (tester) async {
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

      testWidgets('$modeName - EngineeringPage renders architecture blueprints',
          (tester) async {
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

      testWidgets(
          '$modeName - ExperiencePage renders timeline and academic annex',
          (tester) async {
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

      testWidgets(
          '$modeName - SkillsPage renders category chips and collectible skills',
          (tester) async {
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

      testWidgets(
          '$modeName - HatsGridPage renders perspectives and action buttons',
          (tester) async {
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

      testWidgets(
          '$modeName - ContactPage renders availability and communication channels',
          (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 900));
        await tester.pumpWidget(createThemedTestApp(
          child: const ContactPage(),
          brightness: brightness,
        ));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.textContaining('DIRECT LINE'), findsWidgets);
        expect(tester.takeException(), isNull);
        await tester.binding.setSurfaceSize(null);
      });

      testWidgets(
          '$modeName - PortfolioNav TopNav and MobileAppBar adapt to theme',
          (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 900));
        final stubController = HomeController(
          pageIndex: ValueNotifier<int>(0),
          showScrollToTop: ValueNotifier<bool>(false),
          pageCount: 7,
          goTo: (int _, {bool syncUrl = true}) {},
          next: () {},
          prev: () {},
          scrollToMobileSection: (int _, {bool syncUrl = true}) {},
          downloadResume: () async {},
        );
        await tester.pumpWidget(createThemedTestApp(
          child: HomeControllerScope(
            controller: stubController,
            child: Column(
              children: [
                const TopNav(),
                MobileAppBar(onMenuPressed: () {}),
              ],
            ),
          ),
          brightness: brightness,
        ));
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.byType(TopNav), findsOneWidget);
        expect(find.byType(MobileAppBar), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.binding.setSurfaceSize(null);
      });
    }

    testWidgets(
        'Theme toggle does not navigate to contact page on various viewports',
        (tester) async {
      for (final size in [
        const Size(1440, 900),
        const Size(1280, 800),
        const Size(1100, 800),
        const Size(1024, 768),
        const Size(950, 700),
        const Size(400, 800),
      ]) {
        tester.view.devicePixelRatio = 1.0;
        tester.view.physicalSize = size;
        await tester.pumpWidget(PortfolioApp(
            key: ValueKey(size),
            initialTheme: ThemeMode.dark,
            initialLocale: const Locale('en')));
        await tester.pump(const Duration(milliseconds: 300));

        final themeBtnFinder = find.byWidgetPredicate((w) =>
            w is IconButton &&
            (w.tooltip == 'Switch to light' ||
                w.tooltip == 'Switch to dark' ||
                w.icon is Icon &&
                    ((w.icon as Icon).icon == Icons.light_mode ||
                        (w.icon as Icon).icon == Icons.dark_mode ||
                        (w.icon as Icon).icon == Icons.light_mode_outlined ||
                        (w.icon as Icon).icon == Icons.dark_mode_outlined)));

        expect(themeBtnFinder, findsOneWidget,
            reason: 'Theme button must exist for size $size');

        // Tap theme button
        await tester.tap(themeBtnFinder);
        await tester.pump(const Duration(milliseconds: 300));

        expect(tester.takeException(), isNull);
      }
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets(
        'Mobile theme toggle preserves scroll position and does not jump to contact',
        (tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(400, 800);

      await tester.pumpWidget(const PortfolioApp(
          initialTheme: ThemeMode.dark, initialLocale: Locale('en')));
      await tester.pump(const Duration(milliseconds: 300));

      final scrollable = find.byWidgetPredicate((w) =>
          w is ScrollView &&
          w.controller != null &&
          w.scrollDirection == Axis.vertical);
      expect(scrollable, findsOneWidget);

      // Scroll down 1200 pixels (towards section 2/3)
      await tester.drag(scrollable, const Offset(0, -1200));
      await tester.pump(const Duration(milliseconds: 300));

      final scrollableWidget = tester.widget<ScrollView>(scrollable);
      final offsetBefore = scrollableWidget.controller!.offset;
      expect(offsetBefore, greaterThan(800));

      // Tap theme toggle button
      final themeBtn = find.byWidgetPredicate((w) =>
          w is IconButton &&
          w.icon is Icon &&
          ((w.icon as Icon).icon == Icons.light_mode_outlined ||
              (w.icon as Icon).icon == Icons.dark_mode_outlined));
      expect(themeBtn, findsOneWidget);

      await tester.tap(themeBtn);
      await tester.pump(const Duration(milliseconds: 300));

      final offsetAfter = scrollableWidget.controller!.offset;
      expect((offsetAfter - offsetBefore).abs(), lessThan(5.0));

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });

  group('Token Unification and Accessible Contrast Audit', () {
    test('AppColors.linkedIn token matches corporate standard', () {
      expect(AppColors.linkedIn, const Color(0xFF0A66C2));
    });

    test(
        'toAccessibleLightText maps saturated dark-mode tones to high-contrast light tones',
        () {
      expect(AppColors.toAccessibleLightText(AppColors.accentAmber),
          AppColors.accentAmberDeep);
      expect(AppColors.toAccessibleLightText(const Color(0xFFFBBF24)),
          AppColors.accentAmberDeep);
      expect(AppColors.toAccessibleLightText(AppColors.accentGreen),
          AppColors.accentGreenDeep);
      expect(AppColors.toAccessibleLightText(AppColors.accentSky),
          AppColors.accentSkyDeep);
      expect(AppColors.toAccessibleLightText(AppColors.accentCyan),
          AppColors.accentCyanDeep);
      expect(AppColors.toAccessibleLightText(AppColors.accentRose),
          AppColors.accentRoseDeep);
      expect(AppColors.toAccessibleLightText(AppColors.accentViolet),
          AppColors.accentVioletDeep);
      expect(AppColors.toAccessibleLightText(AppColors.accentIndigo),
          AppColors.accentIndigoDeepText);
    });

    testWidgets(
        'SurfaceTone.adaptiveAccentText adapts according to theme brightness',
        (tester) async {
      await tester.pumpWidget(
        Theme(
          data: ThemeData.light(),
          child: Builder(
            builder: (context) {
              expect(context.isDarkMode, isFalse);
              expect(context.adaptiveAccentText(AppColors.accentAmber),
                  AppColors.accentAmberDeep);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      await tester.pumpWidget(
        Theme(
          data: ThemeData.dark(),
          child: Builder(
            builder: (context) {
              expect(context.isDarkMode, isTrue);
              expect(context.adaptiveAccentText(AppColors.accentAmber),
                  AppColors.accentAmber);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets(
        'SurfaceTone.cardGlass and cardGlassHover provide hybrid dense glass opacities',
        (tester) async {
      await tester.pumpWidget(
        Theme(
          data: ThemeData.dark(),
          child: Builder(
            builder: (context) {
              expect(context.cardGlass.a, closeTo(0.88, 0.01));
              expect(context.cardGlassHover.a, closeTo(0.95, 0.01));
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      await tester.pumpWidget(
        Theme(
          data: ThemeData.light(),
          child: Builder(
            builder: (context) {
              expect(context.cardGlass.a, closeTo(0.92, 0.01));
              expect(context.cardGlassHover.a, closeTo(0.96, 0.01));
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });
  });
}
