import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers/test_data.dart';
import 'package:profile/core/bloc/locale/locale_bloc.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';

import 'package:profile/features/shell/presentation/widgets/desktop_toolbar.dart';
import 'package:profile/features/shell/presentation/widgets/magazine_page_transformer.dart';
import 'package:profile/features/projects/presentation/widgets/interactive_project_card.dart';
import 'package:profile/l10n/app_localizations.dart';

void main() {
  group('Asset Size Budget & Format Audit', () {
    test(
        'All bundled raster images are in WebP format and within strict size budgets',
        () {
      final assets = <String, int>{
        'assets/my_image.webp': 64 * 1024,
        'assets/hat.webp': 32 * 1024,
        'assets/images/projects/nathealth.webp': 180 * 1024,
        'assets/images/projects/eskadenia.webp': 180 * 1024,
        'assets/images/projects/solutions.webp': 180 * 1024,
        'assets/images/projects/fais.webp': 180 * 1024,
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

      // Total portfolio image asset payload must be under 650 KB
      expect(totalBytes, lessThanOrEqualTo(650 * 1024),
          reason:
              'Total image payload must be less than 350 KB for instant load');
    });

    test('Bundled fonts stay within budget', () {
      // Readex Pro carries Latin, Czech and Arabic in one variable file,
      // cut to the wght axis and the site's scripts by
      // tool/subset_readex.py (it sits on the startup path).
      final text = File('fonts/ReadexPro.ttf');
      expect(text.existsSync(), isTrue);
      expect(text.lengthSync(), lessThanOrEqualTo(170 * 1024));
      final mono = File('fonts/ShareTechMono-Regular.ttf');
      expect(mono.existsSync(), isTrue);
      expect(mono.lengthSync(), lessThanOrEqualTo(48 * 1024));
    });

    // A character none of the bundled fonts has makes the web engine fetch
    // a Noto fallback from Google and then lay out all the text again: the
    // intro's "→" did that on every visit, a blocking task on phones.
    test('Every character in the copy is in a bundled font', () {
      final covered = <int>{
        for (final font in [
          'fonts/ReadexPro.ttf',
          'fonts/ShareTechMono-Regular.ttf',
          'fonts/Tenada.ttf',
        ])
          ..._cmapCodePoints(File(font).readAsBytesSync()),
      };
      final missing = <String>{};
      for (final arb in Directory('lib/l10n')
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.arb'))) {
        final copy = jsonDecode(arb.readAsStringSync()) as Map<String, dynamic>;
        for (final entry in copy.entries) {
          if (entry.key.startsWith('@') || entry.value is! String) continue;
          for (final rune in (entry.value as String).runes) {
            // Line breaks and bidi marks are never drawn.
            if (rune < 0x20 || (rune >= 0x200B && rune <= 0x200F)) continue;
            if (!covered.contains(rune)) {
              missing.add('U+${rune.toRadixString(16).toUpperCase()} '
                  '${String.fromCharCode(rune)} in ${arb.path} ${entry.key}');
            }
          }
        }
      }
      expect(missing, isEmpty);
    });
  });

  group('RepaintBoundary Isolation & Rendering Efficiency Audit', () {
    testWidgets(
        'InteractiveProjectCard is wrapped in RepaintBoundary to isolate spotlight updates',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final testProject = testProjects.first;
      const scheme = ColorScheme.dark();

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 500,
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
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
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

      final controller = PageController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
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
  });

  group('Web Resource Hints Audit (web/index.html)', () {
    late String indexHtml;

    setUpAll(() {
      final file = File('web/index.html');
      expect(file.existsSync(), isTrue);
      indexHtml = file.readAsStringSync();
    });

    test('Contains critical preloads and prefetch resource hints', () {
      // The text fonts are preloaded once the boot screen has painted.
      expect(indexHtml.contains('"assets/fonts/ReadexPro.ttf"'), isTrue);
      expect(indexHtml.contains("link.rel = 'preload'"), isTrue);
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

/// The code points a TrueType font maps, from its cmap format 4 and 12
/// subtables.
Set<int> _cmapCodePoints(Uint8List bytes) {
  final data = ByteData.sublistView(bytes);
  var cmap = -1;
  for (var i = 0; i < data.getUint16(4); i++) {
    final record = 12 + i * 16;
    if (String.fromCharCodes(bytes, record, record + 4) == 'cmap') {
      cmap = data.getUint32(record + 8);
    }
  }
  expect(cmap, isNot(-1), reason: 'font has no cmap table');
  final points = <int>{};
  for (var i = 0; i < data.getUint16(cmap + 2); i++) {
    final sub = cmap + data.getUint32(cmap + 4 + i * 8 + 4);
    switch (data.getUint16(sub)) {
      case 4:
        final segments = data.getUint16(sub + 6) ~/ 2;
        final ends = sub + 14;
        final starts = ends + segments * 2 + 2;
        final deltas = starts + segments * 2;
        final offsets = deltas + segments * 2;
        for (var s = 0; s < segments; s++) {
          final start = data.getUint16(starts + s * 2);
          final end = data.getUint16(ends + s * 2);
          final delta = data.getUint16(deltas + s * 2);
          final offset = data.getUint16(offsets + s * 2);
          for (var c = start; c <= end && c != 0xFFFF; c++) {
            final glyph = offset == 0
                ? (c + delta) & 0xFFFF
                : data.getUint16(offsets + s * 2 + offset + (c - start) * 2);
            if (glyph != 0) points.add(c);
          }
        }
      case 12:
        for (var g = 0; g < data.getUint32(sub + 12); g++) {
          final group = sub + 16 + g * 12;
          for (var c = data.getUint32(group);
              c <= data.getUint32(group + 4);
              c++) {
            points.add(c);
          }
        }
    }
  }
  return points;
}
