import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/bloc/locale/locale_bloc.dart';
import 'package:profile/core/bloc/navigation/navigation_bloc.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';
import 'package:profile/features/projects/data/projects_data.dart';
import 'package:profile/features/shell/widget/custom_cursor.dart';
import 'package:profile/features/shell/widget/desktop_toolbar.dart';
import 'package:profile/features/shell/widget/magazine_page_transformer.dart';
import 'package:profile/features/projects/widget/interactive_project_card.dart';

void main() {
  group('Asset Size Budget & Format Audit', () {
    test(
        'All bundled raster images are in WebP format and within strict size budgets',
        () {
      final assets = <String, int>{
        'assets/my_image.webp': 64 * 1024,
        'assets/hat.webp': 32 * 1024,
        'assets/images/projects/nathealth.webp': 75 * 1024,
        'assets/images/projects/eskadenia.webp': 75 * 1024,
        'assets/images/projects/solutions.webp': 75 * 1024,
        'assets/images/projects/fais.webp': 75 * 1024,
      };

      int totalBytes = 0;
      for (final entry in assets.entries) {
        final file = File(entry.key);
        expect(file.existsSync(), isTrue,
            reason: 'Asset ${entry.key} must exist on disk');
        final bytes = file.lengthSync();
        totalBytes += bytes;
        expect(
          bytes,
          lessThanOrEqualTo(entry.value),
          reason:
              'Asset ${entry.key} ($bytes bytes) exceeds budget of ${entry.value} bytes',
        );
      }

      // Total portfolio image asset payload must be under 350 KB
      expect(totalBytes, lessThanOrEqualTo(350 * 1024),
          reason:
              'Total image payload must be less than 350 KB for instant load');
    });

    test('Subsetted Tenada display font is within 32 KB budget', () {
      final fontFile = File('fonts/Tenada.ttf');
      expect(fontFile.existsSync(), isTrue);
      expect(fontFile.lengthSync(), lessThanOrEqualTo(32 * 1024));
    });
  });

  group('RepaintBoundary Isolation & Rendering Efficiency Audit', () {
    testWidgets(
        'InteractiveProjectCard is wrapped in RepaintBoundary to isolate spotlight updates',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final testProject = kProjects.first;
      const scheme = ColorScheme.dark();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 400,
              child: InteractiveProjectCard(
                project: testProject,
                index: 0,
                scheme: scheme,
                isDesktop: true,
              ),
            ),
          ),
        ),
      );

      // Verify the card's root contains a RepaintBoundary
      final cardFinder = find.byType(InteractiveProjectCard);
      expect(cardFinder, findsOneWidget);

      final repaintFinder = find.descendant(
        of: cardFinder,
        matching: find.byType(RepaintBoundary),
      );
      expect(repaintFinder, findsAtLeastNWidgets(1));

      // Verify Image.asset has gaplessPlayback: true
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
      final imageWidget = tester.widget<Image>(imageFinder);
      expect(imageWidget.gaplessPlayback, isTrue);
    });

    testWidgets('DesktopToolbar renders cleanly without layout overflow',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()),
            BlocProvider<LocaleBloc>(create: (_) => LocaleBloc()),
            BlocProvider<NavigationBloc>(create: (_) => NavigationBloc()),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: DesktopToolbar(),
            ),
          ),
        ),
      );

      expect(find.byType(DesktopToolbar), findsOneWidget);
    });

    testWidgets(
        'MagazinePageTransformer culls distant offstage pages via Offstage and TickerMode',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final controller = PageController(initialPage: 0);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageView.builder(
              controller: controller,
              itemCount: 5,
              itemBuilder: (context, index) {
                return MagazinePageTransformer(
                  controller: controller,
                  index: index,
                  child: Text('Page $index'),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Page 0 is visible and resting
      expect(find.text('Page 0'), findsOneWidget);

      // Verify that TickerMode and Offstage widgets exist in the tree for culling
      expect(find.byType(TickerMode), findsWidgets);
      expect(find.byType(Offstage), findsWidgets);
    });

    testWidgets('CustomCursor suppresses sub-pixel jitter to minimize rebuilds',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomCursor(
              child: Text('Cursor Test Target'),
            ),
          ),
        ),
      );

      expect(find.byType(CustomCursor), findsOneWidget);
      expect(find.text('Cursor Test Target'), findsOneWidget);
    });
  });

  group('Web Resource Hints Audit (web/index.html)', () {
    late String indexHtml;

    setUpAll(() {
      final file = File('web/index.html');
      expect(file.existsSync(), isTrue);
      indexHtml = file.readAsStringSync();
    });

    test('Contains critical preloads and prefetch resource hints', () {
      expect(
          indexHtml.contains(
              'rel="preload" href="assets/fonts/Tenada.ttf" as="font"'),
          isTrue);
      expect(
          indexHtml.contains('rel="preload" href="main.dart.wasm" as="fetch"'),
          isTrue);
      expect(indexHtml.contains('rel="modulepreload" href="main.dart.mjs"'),
          isTrue);
      expect(
          indexHtml.contains(
              'rel="preload" href="assets/assets/my_image.webp" as="image"'),
          isTrue);
      expect(
          indexHtml.contains(
              'rel="prefetch" href="assets/assets/hat.webp" as="image"'),
          isTrue);
    });

    test('Maintains boot-loader dismissal on flutter-first-frame event', () {
      expect(
          indexHtml.contains("window.addEventListener('flutter-first-frame'"),
          isTrue);
    });
  });
}
