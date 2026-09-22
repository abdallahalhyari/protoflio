import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/shared/widget/app_toast.dart';
import 'package:profile/theme/tokens.dart';

Widget _host({required Widget Function(BuildContext) child}) {
  return MaterialApp(
    home: Scaffold(
      body: Builder(builder: child),
    ),
  );
}

Future<void> _tapAndShow(WidgetTester tester) async {
  await tester.tap(find.text('go'));
  await tester.pump(); // schedule
  await tester.pump(const Duration(milliseconds: 400)); // snackbar enter
}

void main() {
  group('AppToast', () {
    testWidgets('ok status paints statusOk accent bar + check icon',
        (tester) async {
      await tester.pumpWidget(_host(
        child: (ctx) => ElevatedButton(
          onPressed: () => AppToast.show(
            ctx,
            message: 'Copied telemetry',
            status: ToastStatus.ok,
          ),
          child: const Text('go'),
        ),
      ));

      await _tapAndShow(tester);

      expect(find.text('Copied telemetry'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

      final accentBar = tester
          .widgetList<Container>(find.byType(Container))
          .where((c) => c.color == AppColors.statusOk);
      expect(accentBar, isNotEmpty);

      // Let the toast time out so no widgets leak.
      await tester.pumpAndSettle(AppMotion.toast + const Duration(seconds: 1));
    });

    testWidgets('critical status prefixes semantic label with Error',
        (tester) async {
      await tester.pumpWidget(_host(
        child: (ctx) => ElevatedButton(
          onPressed: () => AppToast.show(
            ctx,
            message: 'send failed',
            status: ToastStatus.critical,
          ),
          child: const Text('go'),
        ),
      ));

      await _tapAndShow(tester);

      expect(
          find.bySemanticsLabel(RegExp('Error: send failed')), findsOneWidget);

      await tester.pumpAndSettle(AppMotion.toast + const Duration(seconds: 1));
    });

    testWidgets('neutral status renders no accent bar + no default icon',
        (tester) async {
      await tester.pumpWidget(_host(
        child: (ctx) => ElevatedButton(
          onPressed: () => AppToast.show(
            ctx,
            message: 'Draft saved',
            status: ToastStatus.neutral,
          ),
          child: const Text('go'),
        ),
      ));

      await _tapAndShow(tester);

      expect(find.text('Draft saved'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsNothing);
      expect(find.byIcon(Icons.error_rounded), findsNothing);

      // Neutral emits no status prefix — semantic label is bare message.
      expect(find.bySemanticsLabel('Draft saved'), findsOneWidget);

      await tester.pumpAndSettle(AppMotion.toast + const Duration(seconds: 1));
    });

    testWidgets('back-to-back show collapses previous toast', (tester) async {
      await tester.pumpWidget(_host(
        child: (ctx) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => AppToast.show(ctx, message: 'first'),
              child: const Text('a'),
            ),
            ElevatedButton(
              onPressed: () => AppToast.show(ctx, message: 'second'),
              child: const Text('b'),
            ),
          ],
        ),
      ));

      await tester.tap(find.text('a'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('first'), findsOneWidget);

      await tester.tap(find.text('b'));
      await tester.pumpAndSettle();

      expect(find.text('first'), findsNothing);
      expect(find.text('second'), findsOneWidget);

      await tester.pumpAndSettle(AppMotion.toast + const Duration(seconds: 1));
    });
  });
}
