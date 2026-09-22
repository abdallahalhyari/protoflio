import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/shared/widget/status_badge.dart';
import 'package:profile/theme/tokens.dart';

Widget _host(Widget child) => MaterialApp(home: Scaffold(body: Center(child: child)));

void main() {
  group('StatusBadge', () {
    testWidgets('dot variant renders single circle with status color',
        (tester) async {
      await tester.pumpWidget(_host(
        const StatusBadge.dot(status: BadgeStatus.critical),
      ));

      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);

      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
      expect(decoration.color, AppColors.statusCritical);
    });

    testWidgets('dotLabel variant renders dot + labeled text', (tester) async {
      await tester.pumpWidget(_host(
        const StatusBadge.dotLabel(
          status: BadgeStatus.ok,
          label: 'HEALTHY',
        ),
      ));

      expect(find.text('HEALTHY'), findsOneWidget);
      final text = tester.widget<Text>(find.text('HEALTHY'));
      expect(text.style?.color, AppColors.statusOk);
      expect(text.style?.fontFamily, AppTypography.monoFont);
    });

    testWidgets('pill variant applies tinted background + border',
        (tester) async {
      await tester.pumpWidget(_host(
        const StatusBadge.pill(
          status: BadgeStatus.warn,
          label: 'DEGRADED',
        ),
      ));

      final container = tester
          .widgetList<Container>(find.byType(Container))
          .firstWhere((c) => c.decoration is BoxDecoration &&
              (c.decoration as BoxDecoration).border != null);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color?.a, closeTo(0.14, 0.01));
      expect(decoration.borderRadius, BorderRadius.circular(AppRadius.pill));
      expect(find.text('DEGRADED'), findsOneWidget);
    });

    testWidgets('semantic label combines role + label for screen readers',
        (tester) async {
      await tester.pumpWidget(_host(
        const StatusBadge.dotLabel(
          status: BadgeStatus.critical,
          label: 'send failed',
        ),
      ));

      final semantics = tester.getSemantics(find.byType(StatusBadge));
      expect(semantics.label, contains('Critical'));
      expect(semantics.label, contains('send failed'));
    });

    testWidgets('dot-only variant still announces role fallback',
        (tester) async {
      await tester.pumpWidget(_host(
        const StatusBadge.dot(status: BadgeStatus.ok),
      ));

      final semantics = tester.getSemantics(find.byType(StatusBadge));
      expect(semantics.label, 'OK');
    });

    testWidgets('md size uses larger dot + caption font', (tester) async {
      await tester.pumpWidget(_host(
        const StatusBadge.dotLabel(
          status: BadgeStatus.info,
          label: 'READY',
          size: BadgeSize.md,
        ),
      ));

      final dot = tester.widgetList<Container>(find.byType(Container)).first;
      expect(dot.constraints?.maxWidth, 10);
      expect(dot.constraints?.maxHeight, 10);

      final text = tester.widget<Text>(find.text('READY'));
      expect(text.style?.fontSize, AppTypography.caption);
    });
  });
}
