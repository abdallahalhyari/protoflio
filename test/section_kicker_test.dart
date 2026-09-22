import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/shared/widget/section_kicker.dart';
import 'package:profile/theme/tokens.dart';

Widget _host(Widget child) =>
    MaterialApp(home: Scaffold(body: Center(child: child)));

void main() {
  group('SectionKicker', () {
    testWidgets('label-only renders no rule + no number', (tester) async {
      await tester.pumpWidget(_host(const SectionKicker(label: 'INTRO')));

      expect(find.text('INTRO'), findsOneWidget);
      // Only the Text widget renders; no accent bar Container.
      expect(find.byType(Container), findsNothing);
    });

    testWidgets('numbered variant renders number before label', (tester) async {
      await tester.pumpWidget(_host(
        const SectionKicker(number: '01', label: 'INTRODUCTION'),
      ));

      expect(find.text('01'), findsOneWidget);
      expect(find.text('INTRODUCTION'), findsOneWidget);

      // Number's text comes before label in the row.
      final numberRect = tester.getRect(find.text('01'));
      final labelRect = tester.getRect(find.text('INTRODUCTION'));
      expect(numberRect.left, lessThan(labelRect.left));
    });

    testWidgets('leading rule sits before label', (tester) async {
      await tester.pumpWidget(_host(
        const SectionKicker(label: 'WORK', rule: KickerRule.leading),
      ));

      final ruleFinder = find.byType(Container);
      expect(ruleFinder, findsOneWidget);
      final ruleRect = tester.getRect(ruleFinder);
      final labelRect = tester.getRect(find.text('WORK'));
      expect(ruleRect.right, lessThanOrEqualTo(labelRect.left));
    });

    testWidgets('trailing rule sits after label', (tester) async {
      await tester.pumpWidget(_host(
        const SectionKicker(label: 'END', rule: KickerRule.trailing),
      ));

      final ruleRect = tester.getRect(find.byType(Container));
      final labelRect = tester.getRect(find.text('END'));
      expect(ruleRect.left, greaterThanOrEqualTo(labelRect.right));
    });

    testWidgets('rule uses hairline radius', (tester) async {
      await tester.pumpWidget(_host(
        const SectionKicker(label: 'X', rule: KickerRule.leading),
      ));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius,
          BorderRadius.circular(AppRadius.hairline));
    });

    testWidgets('semantics announces number + label as header',
        (tester) async {
      await tester.pumpWidget(_host(
        const SectionKicker(number: '02', label: 'WORK'),
      ));

      final semantics = tester.getSemantics(find.byType(SectionKicker));
      expect(semantics.label, '02 WORK');
    });
  });
}
