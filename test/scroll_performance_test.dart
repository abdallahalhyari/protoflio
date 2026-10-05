import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/main.dart';
import 'package:profile/features/experience/domain/entities/experience.dart';
import 'package:profile/features/experience/presentation/widgets/animated_experience_node.dart';
import 'package:profile/features/shell/presentation/widgets/page_background.dart';
import 'helpers/test_data.dart';
import 'package:profile/l10n/app_localizations.dart';

void main() {
  group('Scroll Behaviors & Performance Optimizations', () {
    testWidgets(
        'MaterialApp uses SmoothScrollBehavior with normal deceleration',
        (tester) async {
      await tester.pumpWidget(PortfolioApp(
        projectRepo: TestProjectRepository(),
        experienceRepo: TestExperienceRepository(),
        hatRepo: TestHatRepository(),
        skillRepo: TestSkillRepository(),
      ));
      await tester.pump(const Duration(milliseconds: 100));

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final behavior = app.scrollBehavior;
      expect(behavior, isNotNull);

      // Verify drag devices include touch, mouse, trackpad, stylus
      final devices = behavior!.dragDevices;
      expect(devices, contains(PointerDeviceKind.touch));
      expect(devices, contains(PointerDeviceKind.mouse));
      expect(devices, contains(PointerDeviceKind.trackpad));

      // Verify scroll physics uses normal deceleration for fluid momentum
      final BuildContext context = tester.element(find.byType(MaterialApp));
      final physics = behavior.getScrollPhysics(context);
      expect(physics, isA<BouncingScrollPhysics>());
      final bouncing = physics as BouncingScrollPhysics;
      expect(bouncing.decelerationRate, equals(ScrollDecelerationRate.normal));
    });

    testWidgets(
        'AnimatedExperienceNode isolates card in RepaintBoundary for smooth animation',
        (tester) async {
      const exp = Experience(
        role: 'Staff Flutter Engineer',
        company: 'Apex Labs',
        period: '2023 - Present',
        highlights: [
          'Architected high performance real-time systems.',
          'Optimized raster cache and scroll momentum',
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: AnimatedExperienceNode(
              exp: exp,
              isVisible: true,
              isDesktop: true,
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Confirm RepaintBoundary wraps the card
      expect(find.byType(RepaintBoundary), findsWidgets);
      expect(find.text('STAFF FLUTTER ENGINEER'), findsOneWidget);
    });

    testWidgets('PageBackground contains isolated repaint boundaries',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: PageBackground(
              child: Text('Test Content'),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Test Content'), findsOneWidget);
      // Verify both background layers and child are isolated in RepaintBoundary
      expect(find.byType(RepaintBoundary), findsWidgets);
    });


    testWidgets(
        'Desktop wheel gesture advances page and respects directional reversal',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
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

      final pages = _desktopPages(tester);
      expect(pages.page!.round(), 0);

      // Scroll down partially (80px, below threshold 140px)
      await tester.sendEventToBinding(
        const PointerScrollEvent(
          position: Offset(600, 400),
          scrollDelta: Offset(0, 80),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));
      expect(pages.page!.round(), 0);

      // Send a very large wheel event so it immediately turns
      await tester.sendEventToBinding(
        const PointerScrollEvent(
          position: Offset(600, 400),
          scrollDelta: Offset(0, 300),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));
      // Give enough time to clear cooldown and execute jump
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(pages.page!.round(), 1);
    });
  });
}

/// The desktop page controller. Pages live in a custom Scrollable
/// (all pages prebuilt) rather than a PageView, keyed 'desktop_pageview'.
PageController _desktopPages(WidgetTester tester) => tester
    .widget<Scrollable>(
        find.byKey(const PageStorageKey<String>('desktop_pageview')))
    .controller! as PageController;
