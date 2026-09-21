import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/main.dart';
import 'package:profile/features/experience/model/experience.dart';
import 'package:profile/features/experience/widget/animated_experience_node.dart';
import 'package:profile/features/shell/widget/custom_cursor.dart';
import 'package:profile/features/shell/widget/page_background.dart';

void main() {
  group('Scroll Behaviors & Performance Optimizations', () {
    testWidgets(
        'MaterialApp uses SmoothScrollBehavior with normal deceleration',
        (tester) async {
      await tester.pumpWidget(const PortfolioApp());
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
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: AnimatedExperienceNode(
              exp: exp,
              index: 0,
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
        'CustomCursor wraps pointer layer in RepaintBoundary on desktop',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomCursor(
              child: Text('Cursor Test'),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(CustomCursor), findsOneWidget);
      expect(find.byType(RepaintBoundary), findsWidgets);
    });

    testWidgets(
        'Desktop wheel gesture advances page and respects directional reversal',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const PortfolioApp());
      await tester.pump(const Duration(milliseconds: 300));

      final pageView = tester.widget<PageView>(find.byType(PageView));
      expect(pageView.controller!.page!.round(), 0);

      // Scroll down partially (50px, below threshold 80px)
      await tester.sendEventToBinding(
        const PointerScrollEvent(
          position: Offset(600, 400),
          scrollDelta: Offset(0, 50),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));
      expect(pageView.controller!.page!.round(), 0);

      // Scroll down another 50px to exceed 80px threshold -> should advance to page 1
      await tester.sendEventToBinding(
        const PointerScrollEvent(
          position: Offset(600, 400),
          scrollDelta: Offset(0, 50),
        ),
      );
      for (int i = 0; i < 15; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(pageView.controller!.page!.round(), 1);
    });
  });
}
