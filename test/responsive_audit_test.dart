import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/projects/data/projects_data.dart';
import 'package:profile/features/contact/page/contact_page.dart';
import 'package:profile/features/engineering/page/engineering_page.dart';
import 'package:profile/features/experience/page/experience_page.dart';
import 'package:profile/features/hats/page/hats_grid_page.dart';
import 'package:profile/features/intro/page/intro_page.dart';
import 'package:profile/features/projects/page/project_modal.dart';
import 'package:profile/features/projects/page/projects_page.dart';
import 'package:profile/features/skills/page/skills_page.dart';
import 'package:profile/features/shell/widget/mobile_app_bar.dart';
import 'package:profile/shared/widget/screen_shell.dart';
import 'package:profile/features/shell/widget/shortcut_help_dialog.dart';
import 'package:profile/theme/app_theme.dart';
import 'package:profile/theme/tokens.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _buildViewportHarness(Widget child, Size size, {bool isDark = true, bool scrollable = false}) {
  return MediaQuery(
    data: MediaQueryData(size: size),
    child: MaterialApp(
      theme: isDark ? AppTheme.dark() : AppTheme.light(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('cs'),
      ],
      home: Scaffold(
        body: scrollable ? SingleChildScrollView(child: child) : child,
      ),
    ),
  );
}

void _setViewport(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AppBreakpoints Architecture & Classification Audit', () {
    testWidgets('Classifies compact smartphone (320x568) accurately', (tester) async {
      _setViewport(tester, const Size(320, 568));
      late BuildContext capturedContext;
      await tester.pumpWidget(_buildViewportHarness(
        Builder(builder: (ctx) {
          capturedContext = ctx;
          return const SizedBox.shrink();
        }),
        const Size(320, 568),
      ));

      expect(AppBreakpoints.isCompact(capturedContext), isTrue);
      expect(AppBreakpoints.isMobile(capturedContext), isTrue);
      expect(AppBreakpoints.isTablet(capturedContext), isFalse);
      expect(AppBreakpoints.isDesktop(capturedContext), isFalse);
      expect(AppBreakpoints.isWideDesktop(capturedContext), isFalse);
      expect(AppBreakpoints.isUltraWide(capturedContext), isFalse);
    });

    testWidgets('Classifies standard phone (390x844) accurately', (tester) async {
      _setViewport(tester, const Size(390, 844));
      late BuildContext capturedContext;
      await tester.pumpWidget(_buildViewportHarness(
        Builder(builder: (ctx) {
          capturedContext = ctx;
          return const SizedBox.shrink();
        }),
        const Size(390, 844),
      ));

      expect(AppBreakpoints.isCompact(capturedContext), isTrue);
      expect(AppBreakpoints.isMobile(capturedContext), isTrue);
      expect(AppBreakpoints.isTablet(capturedContext), isFalse);
      expect(AppBreakpoints.isDesktop(capturedContext), isFalse);
    });

    testWidgets('Classifies tablet portrait (768x1024) accurately', (tester) async {
      _setViewport(tester, const Size(768, 1024));
      late BuildContext capturedContext;
      await tester.pumpWidget(_buildViewportHarness(
        Builder(builder: (ctx) {
          capturedContext = ctx;
          return const SizedBox.shrink();
        }),
        const Size(768, 1024),
      ));

      expect(AppBreakpoints.isCompact(capturedContext), isFalse);
      expect(AppBreakpoints.isMobile(capturedContext), isTrue);
      expect(AppBreakpoints.isTablet(capturedContext), isFalse);
      expect(AppBreakpoints.isDesktop(capturedContext), isFalse);
    });

    testWidgets('Classifies tablet landscape mid-split (950x700) accurately', (tester) async {
      _setViewport(tester, const Size(950, 700));
      late BuildContext capturedContext;
      await tester.pumpWidget(_buildViewportHarness(
        Builder(builder: (ctx) {
          capturedContext = ctx;
          return const SizedBox.shrink();
        }),
        const Size(950, 700),
      ));

      expect(AppBreakpoints.isCompact(capturedContext), isFalse);
      expect(AppBreakpoints.isMobile(capturedContext), isFalse);
      expect(AppBreakpoints.isTablet(capturedContext), isTrue);
      expect(AppBreakpoints.isDesktop(capturedContext), isTrue);
      expect(AppBreakpoints.isWideDesktop(capturedContext), isFalse);
    });

    testWidgets('Classifies wide desktop (1440x900) accurately', (tester) async {
      _setViewport(tester, const Size(1440, 900));
      late BuildContext capturedContext;
      await tester.pumpWidget(_buildViewportHarness(
        Builder(builder: (ctx) {
          capturedContext = ctx;
          return const SizedBox.shrink();
        }),
        const Size(1440, 900),
      ));

      expect(AppBreakpoints.isDesktop(capturedContext), isTrue);
      expect(AppBreakpoints.isWideDesktop(capturedContext), isTrue);
      expect(AppBreakpoints.isUltraWide(capturedContext), isFalse);
    });

    testWidgets('Classifies 4K ultrawide monitor (3840x2160) accurately', (tester) async {
      _setViewport(tester, const Size(3840, 2160));
      late BuildContext capturedContext;
      await tester.pumpWidget(_buildViewportHarness(
        Builder(builder: (ctx) {
          capturedContext = ctx;
          return const SizedBox.shrink();
        }),
        const Size(3840, 2160),
      ));

      expect(AppBreakpoints.isDesktop(capturedContext), isTrue);
      expect(AppBreakpoints.isWideDesktop(capturedContext), isTrue);
      expect(AppBreakpoints.isUltraWide(capturedContext), isTrue);
    });
  });

  group('ScreenShell Horizontal Padding Monotonicity Audit', () {
    testWidgets('Scales padding smoothly from compact to 4K ultra-wide', (tester) async {
      final measurements = <double, double>{};

      for (final width in [320.0, 350.0, 360.0, 500.0, 600.0, 800.0, 1024.0, 1300.0, 1440.0, 3840.0]) {
        _setViewport(tester, Size(width, 800));
        await tester.pumpWidget(_buildViewportHarness(
          Builder(builder: (ctx) {
            measurements[width] = AppScreenShell.horizontalPadding(ctx);
            return const SizedBox.shrink();
          }),
          Size(width, 800),
        ));
      }

      // Compact phones (< 360) receive 12px margins for extra breathability
      expect(measurements[320.0], equals(12.0));
      expect(measurements[350.0], equals(12.0));

      // Standard phones (360 - 599) receive 16px
      expect(measurements[360.0], equals(16.0));
      expect(measurements[500.0], equals(16.0));

      // Mobile large / tablet portrait (600 - 1023) receive 24px
      expect(measurements[600.0], equals(24.0));
      expect(measurements[800.0], equals(24.0));

      // Desktop (1024 - 1439) receive 32px
      expect(measurements[1024.0], equals(32.0));
      expect(measurements[1300.0], equals(32.0));

      // Wide desktop and 4K ultra-wide (>= 1440) receive 48px
      expect(measurements[1440.0], equals(48.0));
      expect(measurements[3840.0], equals(48.0));
    });
  });

  group('Compact Viewport (320x568) Page Rendering Resilience', () {
    const compactSize = Size(320, 568);

    testWidgets('IntroPage renders cleanly on compact 320x568', (tester) async {
      _setViewport(tester, compactSize);
      await tester.pumpWidget(_buildViewportHarness(
        IntroPage(
          onScrollDown: () {},
          isContinuousMobile: true,
        ),
        compactSize,
        scrollable: true,
      ));
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);
      expect(find.text('ABDALLAH'), findsWidgets);
    });

    testWidgets('ExperiencePage renders cleanly on compact 320x568', (tester) async {
      _setViewport(tester, compactSize);
      await tester.pumpWidget(_buildViewportHarness(
        const ExperiencePage(isContinuousMobile: true),
        compactSize,
        scrollable: true,
      ));
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);
      expect(find.text('CAREER TRAJECTORY'), findsOneWidget);
    });

    testWidgets('ProjectsPage renders cleanly on compact 320x568', (tester) async {
      _setViewport(tester, compactSize);
      await tester.pumpWidget(_buildViewportHarness(
        const ProjectsPage(isContinuousMobile: true),
        compactSize,
        scrollable: true,
      ));
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);
      expect(find.text('CASE STUDIES'), findsOneWidget);
    });

    testWidgets('SkillsPage renders cleanly on compact 320x568', (tester) async {
      _setViewport(tester, compactSize);
      await tester.pumpWidget(_buildViewportHarness(
        const SkillsPage(isContinuousMobile: true),
        compactSize,
        scrollable: true,
      ));
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);
      expect(find.text('SKILLS'), findsOneWidget);
    });

    testWidgets('EngineeringPage renders cleanly on compact 320x568', (tester) async {
      _setViewport(tester, compactSize);
      await tester.pumpWidget(_buildViewportHarness(
        const EngineeringPage(isContinuousMobile: true),
        compactSize,
        scrollable: true,
      ));
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);
      expect(find.text('ENGINEERING EXPERTISE'), findsOneWidget);
    });

    testWidgets('HatsGridPage renders cleanly on compact 320x568', (tester) async {
      _setViewport(tester, compactSize);
      await tester.pumpWidget(_buildViewportHarness(
        const HatsGridPage(isContinuousMobile: true),
        compactSize,
        scrollable: true,
      ));
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);
      expect(find.text('ARCHITECTURAL PERSPECTIVES'), findsOneWidget);
    });

    testWidgets('ContactPage renders cleanly on compact 320x568', (tester) async {
      _setViewport(tester, compactSize);
      await tester.pumpWidget(_buildViewportHarness(
        const ContactPage(isContinuousMobile: true),
        compactSize,
        scrollable: true,
      ));
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);
      expect(find.text("LET'S BUILD SOMETHING EXTRAORDINARY"), findsOneWidget);
    });
  });

  group('4K Ultra-Wide Viewport (3840x2160) Content Containment Audit', () {
    const ultraWideSize = Size(3840, 2160);

    testWidgets('IntroPage centers and constrains maxWidth on 4K display', (tester) async {
      _setViewport(tester, ultraWideSize);
      await tester.pumpWidget(_buildViewportHarness(
        IntroPage(onScrollDown: () {}),
        ultraWideSize,
      ));
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);
      final constrainedBox = tester.widget<ConstrainedBox>(
        find.descendant(of: find.byType(AppScreenShell), matching: find.byType(ConstrainedBox)).first,
      );
      expect(constrainedBox.constraints.maxWidth, equals(1200.0));
      final renderBox = tester.renderObject<RenderBox>(
        find.descendant(of: find.byType(AppScreenShell), matching: find.byType(ConstrainedBox)).first,
      );
      expect(renderBox.size.width, lessThanOrEqualTo(1200.0));
    });

    testWidgets('ProjectsPage centers and constrains maxWidth on 4K display', (tester) async {
      _setViewport(tester, ultraWideSize);
      await tester.pumpWidget(_buildViewportHarness(
        const ProjectsPage(),
        ultraWideSize,
      ));
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);
      final constrainedBox = tester.widget<ConstrainedBox>(
        find.descendant(of: find.byType(AppScreenShell), matching: find.byType(ConstrainedBox)).first,
      );
      expect(constrainedBox.constraints.maxWidth, equals(1200.0));
      final renderBox = tester.renderObject<RenderBox>(
        find.descendant(of: find.byType(AppScreenShell), matching: find.byType(ConstrainedBox)).first,
      );
      expect(renderBox.size.width, lessThanOrEqualTo(1200.0));
    });

    testWidgets('ExperiencePage centers and constrains maxWidth on 4K display', (tester) async {
      _setViewport(tester, ultraWideSize);
      await tester.pumpWidget(_buildViewportHarness(
        const ExperiencePage(),
        ultraWideSize,
      ));
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);
      final constrainedBox = tester.widget<ConstrainedBox>(
        find.descendant(of: find.byType(AppScreenShell), matching: find.byType(ConstrainedBox)).first,
      );
      expect(constrainedBox.constraints.maxWidth, equals(1600.0));
      final renderBox = tester.renderObject<RenderBox>(
        find.descendant(of: find.byType(AppScreenShell), matching: find.byType(ConstrainedBox)).first,
      );
      expect(renderBox.size.width, lessThanOrEqualTo(1600.0));
    });
  });

  group('Dialog & Modal Responsive Clamping Audit', () {
    testWidgets('ShortcutHelpDialog fits and is interactive on compact 320x568 screen', (tester) async {
      _setViewport(tester, const Size(320, 568));
      late BuildContext rootCtx;
      await tester.pumpWidget(_buildViewportHarness(
        Builder(builder: (ctx) {
          rootCtx = ctx;
          return const Center(child: Text('Home'));
        }),
        const Size(320, 568),
      ));

      unawaited(showShortcutHelpDialog(rootCtx));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Keyboard shortcuts'), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('showProjectCaseStudy opens and renders without overflow on 320x568 screen', (tester) async {
      _setViewport(tester, const Size(320, 568));
      final project = kProjects.first;
      late BuildContext rootCtx;
      await tester.pumpWidget(_buildViewportHarness(
        Builder(builder: (ctx) {
          rootCtx = ctx;
          return const Center(child: Text('Home'));
        }),
        const Size(320, 568),
      ));

      unawaited(showProjectCaseStudy(rootCtx, project: project, index: 0));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);
      expect(find.text(project.name), findsOneWidget);
    });
  });

  group('MobileAppBar Viewport Adaptation Audit', () {
    testWidgets('Switches to tight mode on 320px width without sub-badge', (tester) async {
      _setViewport(tester, const Size(320, 568));
      await tester.pumpWidget(_buildViewportHarness(
        MobileAppBar(onMenuPressed: () {}),
        const Size(320, 568),
      ));
      await tester.pumpAndSettle();

      expect(find.text('ABDALLAH'), findsOneWidget);
      // Sub-badge is hidden on compact screens
      expect(find.text('AVAILABLE'), findsNothing);
    });

    testWidgets('Displays sub-badge on wider phone (600px)', (tester) async {
      _setViewport(tester, const Size(600, 800));
      await tester.pumpWidget(_buildViewportHarness(
        MobileAppBar(onMenuPressed: () {}),
        const Size(600, 800),
      ));
      await tester.pumpAndSettle();

      expect(find.text('ABDALLAH'), findsOneWidget);
      expect(find.text('AVAILABLE'), findsOneWidget);
    });
  });
}
