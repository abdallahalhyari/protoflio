import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/shared/widgets/in_view_trigger.dart';

/// Counts how often its entrance was started.
class _Probe extends StatefulWidget {
  const _Probe({required this.onPlay});

  final VoidCallback onPlay;

  @override
  State<_Probe> createState() => _ProbeState();
}

class _ProbeState extends State<_Probe> with InViewTrigger {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    playWhenInView(widget.onPlay);
  }

  @override
  Widget build(BuildContext context) => const SizedBox(height: 120);
}

Widget _app(Widget body) => MaterialApp(
      home: MediaQuery(
        data: const MediaQueryData(size: Size(1200, 900)),
        child: Scaffold(body: body),
      ),
    );

void main() {
  group('InViewTrigger', () {
    testWidgets('plays once when mounted in view', (tester) async {
      var plays = 0;
      await tester.pumpWidget(_app(_Probe(onPlay: () => plays++)));
      await tester.pump();
      expect(plays, 1);
      await tester.pump(const Duration(seconds: 1));
      expect(plays, 1);
    });

    testWidgets('waits until scrolled into view, then plays once',
        (tester) async {
      var plays = 0;
      final controller = ScrollController();
      await tester.pumpWidget(_app(SingleChildScrollView(
        controller: controller,
        child: Column(children: [
          const SizedBox(height: 2000),
          _Probe(onPlay: () => plays++),
        ]),
      )));
      await tester.pump();
      expect(plays, 0, reason: 'mounted off screen');

      controller.jumpTo(1000);
      await tester.pump();
      expect(plays, 0, reason: 'still below the fold');

      controller.jumpTo(1500);
      await tester.pump();
      expect(plays, 1);

      controller.jumpTo(0);
      await tester.pump();
      controller.jumpTo(1500);
      await tester.pump();
      expect(plays, 1, reason: 'never replays');
    });

    testWidgets('follows nested scrollables (page turner around a section)',
        (tester) async {
      var plays = 0;
      final pages = PageController();
      await tester.pumpWidget(_app(PageView(
        controller: pages,
        scrollDirection: Axis.vertical,
        children: [
          const SizedBox.expand(),
          SingleChildScrollView(child: _Probe(onPlay: () => plays++)),
        ],
      )));
      await tester.pump();
      expect(plays, 0, reason: 'next page is off screen');

      pages.jumpToPage(1);
      await tester.pump();
      expect(plays, 1);
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
