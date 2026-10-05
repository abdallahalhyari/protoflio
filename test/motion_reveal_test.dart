import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/intro/widget/hero/hero_wordmark.dart';
import 'package:profile/shared/widget/masthead_reveal.dart';
import 'package:profile/shared/widget/section_masthead.dart';
import 'package:profile/theme/app_theme.dart';

Widget _masthead() => const SectionMasthead(
      kicker: 'FEATURE 02 · CAREER TRAJECTORY',
      title: 'EXPERIENCE',
      subtitle: 'Multi-year development',
      isDesktop: true,
      badgeLabel: '4 ROLES',
    );

Widget _app(Widget body, {bool reduceMotion = false}) => MaterialApp(
      theme: AppTheme.dark(),
      home: MediaQuery(
        data: MediaQueryData(
          size: const Size(1200, 900),
          disableAnimations: reduceMotion,
        ),
        child: Scaffold(body: body),
      ),
    );

/// The title's reveal clip: its FractionalTranslation is 1 (hidden below
/// the mask) before the reveal and gone once it has played.
Finder _titleShift() => find.descendant(
      of: find.byType(MastheadReveal),
      matching: find.byType(FractionalTranslation),
    );

void main() {
  group('Section masthead reveal', () {
    testWidgets('plays when the header is in view and ends at rest',
        (tester) async {
      await tester.pumpWidget(_app(_masthead()));
      await tester.pump(); // post-frame visibility check
      await tester.pump(const Duration(milliseconds: 100));
      expect(_titleShift(), findsOneWidget, reason: 'mid-reveal');

      await tester.pumpAndSettle();
      expect(_titleShift(), findsNothing, reason: 'at rest, no wrappers');
      expect(find.text('EXPERIENCE'), findsOneWidget);
    });

    testWidgets('waits until the header is scrolled into view', (tester) async {
      final controller = ScrollController();
      await tester.pumpWidget(_app(SingleChildScrollView(
        controller: controller,
        child: Column(
          children: [const SizedBox(height: 2000), _masthead()],
        ),
      )));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      final hidden =
          tester.widget<FractionalTranslation>(_titleShift()).translation;
      expect(hidden, const Offset(0, 1), reason: 'not played off-screen');

      controller.jumpTo(1600);
      await tester.pump();
      await tester.pumpAndSettle();
      expect(_titleShift(), findsNothing, reason: 'played once scrolled to');
    });

    testWidgets('reduced motion shows the finished header immediately',
        (tester) async {
      await tester.pumpWidget(_app(_masthead(), reduceMotion: true));
      expect(_titleShift(), findsNothing);
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('the title stays a header for screen readers while hidden',
        (tester) async {
      final semantics = tester.ensureSemantics();
      final controller = ScrollController();
      await tester.pumpWidget(_app(SingleChildScrollView(
        controller: controller,
        child: Column(
          children: [const SizedBox(height: 2000), _masthead()],
        ),
      )));
      await tester.pump();
      controller.jumpTo(1600);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      // Kicker and subtitle are still faded out, the title still below
      // its mask, yet all of them are announced.
      expect(find.bySemanticsLabel('FEATURE 02 · CAREER TRAJECTORY'),
          findsOneWidget);
      expect(find.bySemanticsLabel('EXPERIENCE'), findsOneWidget);
      expect(find.bySemanticsLabel('Multi-year development'), findsOneWidget);
      await tester.pumpAndSettle();
      semantics.dispose();
    });
  });

  group('Hero wordmark sheen', () {
    test('rests on the plain three-stop gradient', () {
      final g = heroWordmarkGradient(isDark: true);
      expect(g.stops, [0.0, 0.55, 1.0]);
    });

    test('mid-sheen carries a bright band with ordered stops', () {
      final g = heroWordmarkGradient(isDark: true, sheen: 0.5);
      final stops = g.stops!;
      for (var i = 1; i < stops.length; i++) {
        expect(stops[i], greaterThanOrEqualTo(stops[i - 1]));
      }
      expect(stops.first, greaterThanOrEqualTo(0));
      expect(stops.last, lessThanOrEqualTo(1));
      final brightest =
          g.colors.map((c) => c.a).reduce((a, b) => a > b ? a : b);
      expect(brightest, greaterThan(0.9));
    });

    test('the band starts and ends off the wordmark', () {
      for (final t in [0.0, 1.0]) {
        final g = heroWordmarkGradient(isDark: true, sheen: t);
        final brightest =
            g.colors.map((c) => c.a).reduce((a, b) => a > b ? a : b);
        expect(brightest, lessThan(0.6), reason: 'sheen=$t');
      }
    });
  });

  test('the boot screen waits for the app, with a first-frame fallback', () {
    final html = File('web/index.html').readAsStringSync();
    expect(html, contains('window.portfolioReady = dismissBootLoader'));
    expect(html, contains('setTimeout(dismissBootLoader, 6000)'));
    // While it waits, its loops are frozen so they don't compete with
    // Flutter's first frames for the main thread.
    expect(html, contains("l.classList.add('settled')"));
    expect(html,
        contains('#boot-loader.settled * { animation-play-state: paused; }'));
  });
}
