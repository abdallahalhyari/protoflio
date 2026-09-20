import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/shared/widget/editorial_chip.dart';

Widget _host(Widget child, {Brightness brightness = Brightness.dark}) {
  return MaterialApp(
    theme: ThemeData(brightness: brightness),
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  testWidgets('renders label + icon', (tester) async {
    await tester.pumpWidget(_host(
      const EditorialChip(label: 'HELLO', icon: Icons.star),
    ));
    expect(find.text('HELLO'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('fires onTap when interactive', (tester) async {
    int taps = 0;
    await tester.pumpWidget(_host(
      EditorialChip(label: 'TAP', onTap: () => taps++),
    ));
    await tester.tap(find.text('TAP'));
    await tester.pumpAndSettle();
    expect(taps, 1);
  });

  testWidgets('no InkWell when non-interactive', (tester) async {
    await tester.pumpWidget(_host(const EditorialChip(label: 'STATIC')));
    expect(find.byType(InkWell), findsNothing);
  });

  testWidgets('renders trailing slot', (tester) async {
    await tester.pumpWidget(_host(
      const EditorialChip(
        label: 'GO',
        trailing: Icon(Icons.arrow_forward, size: 12),
      ),
    ));
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
  });

  testWidgets('all tone × variant combos render without exception',
      (tester) async {
    for (final variant in ChipVariant.values) {
      for (final tone in ChipTone.values) {
        await tester.pumpWidget(_host(
          EditorialChip(label: 'X', tone: tone, variant: variant),
        ));
        expect(find.text('X'), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    }
  });

  testWidgets('dense produces tighter padding', (tester) async {
    await tester.pumpWidget(_host(
      const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          EditorialChip(label: 'NORMAL'),
          SizedBox(width: 8),
          EditorialChip(label: 'DENSE', dense: true),
        ],
      ),
    ));
    final normal = tester.getSize(find.text('NORMAL'));
    final dense = tester.getSize(find.text('DENSE'));
    // Dense uses editorialSm (9.5) vs editorial (10.5).
    expect(dense.height < normal.height, isTrue);
  });
}
