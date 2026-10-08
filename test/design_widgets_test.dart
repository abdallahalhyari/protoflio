import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/widgets/apdu_trace_strip.dart';
import 'package:profile/shared/widgets/blueprint_callout.dart';
import 'package:profile/shared/widgets/code_excerpt.dart';
import 'package:profile/shared/widgets/spark_stat.dart';

Widget _host(Widget child) => MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  group('CodeExcerpt', () {
    testWidgets('renders line numbers and code', (tester) async {
      await tester.pumpWidget(_host(const CodeExcerpt(
        code: 'class Foo {\n  final int bar = 42;\n}',
        language: CodeLanguage.dart,
      )));

      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.textContaining('class'), findsWidgets);
    });

    testWidgets('header shows language label', (tester) async {
      await tester.pumpWidget(_host(const CodeExcerpt(
        code: 'val x = 1',
        language: CodeLanguage.kotlin,
      )));
      expect(find.text('kotlin'), findsOneWidget);
    });

    testWidgets('highlight range paints focus bar', (tester) async {
      await tester.pumpWidget(_host(const CodeExcerpt(
        code: 'a\nb\nc\nd',
        language: CodeLanguage.dart,
        highlight: (2, 3),
      )));

      // One line of code = one accent bar container (full width = 2 pixels).
      final focusBars =
          tester.widgetList<Container>(find.byType(Container)).where((c) {
        final cons = c.constraints?.maxWidth ?? 0;
        return cons == 2;
      });
      // Lines 2 and 3 have the focus bar visible; 1 and 4 use transparent.
      expect(focusBars.length, greaterThanOrEqualTo(4));
    });
  });

  group('ApduTraceStrip', () {
    testWidgets('renders status word label and bytes', (tester) async {
      await tester.pumpWidget(_host(const ApduTraceStrip(
        exchange: ApduExchange(
          command: ApduCommand(
              cla: 0x00, ins: 0xA4, p1: 0x04, p2: 0x00, data: [0xA0, 0x00]),
          response: ApduResponse(sw1: 0x90, sw2: 0x00),
          elapsed: Duration(microseconds: 3400),
          label: 'select',
        ),
      )));

      expect(find.text('select'), findsOneWidget);
      expect(find.text('9000'), findsOneWidget);
      expect(find.text('ok'), findsOneWidget);
      expect(find.textContaining('3.4 ms'), findsOneWidget);
    });

    testWidgets('error status word uses critical label', (tester) async {
      await tester.pumpWidget(_host(const ApduTraceStrip(
        exchange: ApduExchange(
          command: ApduCommand(cla: 0x00, ins: 0xA4, p1: 0x04, p2: 0x00),
          response: ApduResponse(sw1: 0x6A, sw2: 0x82),
          elapsed: Duration(microseconds: 1200),
        ),
      )));

      expect(find.text('6A82'), findsOneWidget);
      expect(find.text('error'), findsOneWidget);
    });

    testWidgets('byte tooltip exposes field name', (tester) async {
      await tester.pumpWidget(_host(const ApduTraceStrip(
        exchange: ApduExchange(
          command: ApduCommand(cla: 0x00, ins: 0xA4, p1: 0x04, p2: 0x00),
          response: ApduResponse(sw1: 0x90, sw2: 0x00),
          elapsed: Duration(microseconds: 1000),
        ),
      )));

      // The first byte (CLA) should carry its tooltip.
      final tooltip = tester
          .widgetList<Tooltip>(find.byType(Tooltip))
          .firstWhere((t) => t.message?.startsWith('CLA') ?? false);
      expect(tooltip.message, contains('class'));
    });
  });

  group('BlueprintCallout', () {
    testWidgets('number variant renders padded number', (tester) async {
      await tester.pumpWidget(_host(
        const SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            children: [
              Positioned(
                left: 10,
                top: 10,
                child: BlueprintCallout(
                  label: 'Encrypted at reader',
                  target: Offset(100, 60),
                  number: 3,
                ),
              ),
            ],
          ),
        ),
      ));

      expect(find.text('03'), findsOneWidget);
    });

    testWidgets('glyph variant renders character', (tester) async {
      await tester.pumpWidget(_host(
        const SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            children: [
              Positioned(
                left: 10,
                top: 10,
                child: BlueprintCallout(
                  label: 'Secure channel',
                  target: Offset(80, 40),
                  glyph: CalloutGlyph.diamond,
                ),
              ),
            ],
          ),
        ),
      ));

      expect(find.text('◆'), findsOneWidget);
    });
  });

  group('SparkStat', () {
    testWidgets('renders value, label, and delta text', (tester) async {
      await tester.pumpWidget(_host(const SparkStat(
        value: '128k',
        label: 'Downloads',
        samples: [100.0, 110.0, 125.0, 128.0],
      )));

      expect(find.text('128k'), findsOneWidget);
      expect(find.text('Downloads'), findsOneWidget);
      expect(find.textContaining('%'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);
    });

    testWidgets('inverted metric flips good-direction color', (tester) async {
      await tester.pumpWidget(_host(const SparkStat(
        value: '240 ms',
        label: 'Latency',
        samples: [320.0, 300.0, 260.0, 240.0],
        invertedGood: true,
      )));

      // Delta is downward and inverted-good → tealLight (ok).
      final deltaIcon =
          tester.widget<Icon>(find.byIcon(Icons.arrow_downward_rounded));
      expect(deltaIcon.color, AppColors.tealLight);
    });

    testWidgets('flat delta uses em-dash glyph', (tester) async {
      await tester.pumpWidget(_host(const SparkStat(
        value: '42',
        label: 'Ticks',
        samples: [100.0, 100.0, 100.0, 100.0],
      )));

      expect(find.text('—'), findsOneWidget);
      expect(find.byIcon(Icons.remove_rounded), findsOneWidget);
    });
  });
}
