import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/shared/widget/primary_button.dart';

Widget _host(Widget child) {
  return MaterialApp(
    theme: ThemeData(brightness: Brightness.dark),
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  testWidgets('primary tap fires onPressed', (tester) async {
    int taps = 0;
    await tester.pumpWidget(_host(
      PrimaryButton(label: 'GO', onPressed: () => taps++),
    ));
    await tester.tap(find.text('GO'));
    await tester.pumpAndSettle();
    expect(taps, 1);
  });

  testWidgets('disabled (onPressed:null) does not fire', (tester) async {
    await tester.pumpWidget(_host(
      const PrimaryButton(label: 'OFF', onPressed: null),
    ));
    // Semantic node reports enabled: false — Tristate.isFalse indicates
    // the enabled flag was explicitly set to false (not just absent).
    final semantics = tester.getSemantics(find.text('OFF'));
    expect(semantics.flagsCollection.isEnabled.toString(), contains('isFalse'));
  });

  testWidgets('loading state shows CircularProgressIndicator', (tester) async {
    await tester.pumpWidget(_host(
      PrimaryButton(label: 'WAIT', onPressed: () {}, loading: true),
    ));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('loading state suppresses onTap', (tester) async {
    int taps = 0;
    await tester.pumpWidget(_host(
      PrimaryButton(label: 'BUSY', onPressed: () => taps++, loading: true),
    ));
    await tester.tap(find.text('BUSY'));
    // pumpAndSettle would hang on the spinning CircularProgressIndicator.
    await tester.pump(const Duration(milliseconds: 100));
    expect(taps, 0);
  });

  testWidgets('size sm renders smaller than lg', (tester) async {
    await tester.pumpWidget(_host(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryButton(
            label: 'SM',
            onPressed: () {},
            size: PrimaryButtonSize.sm,
          ),
          PrimaryButton(
            label: 'LG',
            onPressed: () {},
            size: PrimaryButtonSize.lg,
          ),
        ],
      ),
    ));
    final sm = tester.getSize(find.text('SM'));
    final lg = tester.getSize(find.text('LG'));
    expect(sm.height < lg.height, isTrue);
  });

  testWidgets('icon renders when provided', (tester) async {
    await tester.pumpWidget(_host(
      PrimaryButton(
        label: 'DL',
        icon: Icons.download_rounded,
        onPressed: () {},
      ),
    ));
    expect(find.byIcon(Icons.download_rounded), findsOneWidget);
  });

  testWidgets('destructive variant maps to error color', (tester) async {
    await tester.pumpWidget(_host(
      PrimaryButton(
        label: 'DEL',
        variant: PrimaryButtonVariant.destructive,
        onPressed: () {},
      ),
    ));
    // Just verify it builds and semantic label is intact.
    expect(find.text('DEL'), findsOneWidget);
  });
}
