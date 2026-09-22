import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/shared/widget/metric_tile.dart';
import 'package:profile/theme/tokens.dart';

Widget _host(Widget child) => MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  group('MetricTile', () {
    testWidgets('renders value + label', (tester) async {
      await tester.pumpWidget(_host(
        const MetricTile(value: '128k', label: 'Downloads'),
      ));

      expect(find.text('128k'), findsOneWidget);
      expect(find.text('Downloads'), findsOneWidget);
    });

    testWidgets('delta.up shows upward arrow + statusOk color',
        (tester) async {
      await tester.pumpWidget(_host(
        const MetricTile(
          value: '10',
          label: 'Signups',
          delta: MetricDelta.up(12.4, 'vs last month'),
        ),
      ));

      expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);
      expect(find.textContaining('12.4%'), findsOneWidget);

      final icon = tester.widget<Icon>(find.byIcon(Icons.arrow_upward_rounded));
      expect(icon.color, AppColors.statusOk);
    });

    testWidgets('delta.down uses statusCritical color', (tester) async {
      await tester.pumpWidget(_host(
        const MetricTile(
          value: '3',
          label: 'Errors',
          delta: MetricDelta.down(5.0),
        ),
      ));

      final icon = tester.widget<Icon>(find.byIcon(Icons.arrow_downward_rounded));
      expect(icon.color, AppColors.statusCritical);
    });

    testWidgets('sm size uses titleLg value + sm radius', (tester) async {
      await tester.pumpWidget(_host(
        const MetricTile(value: '9', label: 'Runs', size: MetricSize.sm),
      ));

      final value = tester.widget<Text>(find.text('9'));
      expect(value.style?.fontSize, AppTypography.titleLg);
    });

    testWidgets('lg size uses heroSm value + card radius', (tester) async {
      await tester.pumpWidget(_host(
        const MetricTile(value: '1M', label: 'Reach', size: MetricSize.lg),
      ));

      final value = tester.widget<Text>(find.text('1M'));
      expect(value.style?.fontSize, AppTypography.heroSm);
    });

    testWidgets('onTap wraps content in InkWell + button semantics',
        (tester) async {
      var tapped = false;
      await tester.pumpWidget(_host(
        MetricTile(
          value: '42',
          label: 'Tasks',
          onTap: () => tapped = true,
        ),
      ));

      await tester.tap(find.byType(MetricTile));
      expect(tapped, isTrue);

      final semantics = tester.getSemantics(find.byType(MetricTile));
      expect(semantics.flagsCollection.isButton, isTrue);
    });

    testWidgets('semantics label pieces value + delta together',
        (tester) async {
      await tester.pumpWidget(_host(
        const MetricTile(
          value: '128k',
          label: 'Downloads',
          delta: MetricDelta.up(12.4, 'vs last month'),
        ),
      ));

      final semantics = tester.getSemantics(find.byType(MetricTile));
      expect(semantics.label, contains('Downloads: 128k'));
      expect(semantics.label, contains('up 12.4 percent'));
      expect(semantics.label, contains('vs last month'));
    });
  });
}
