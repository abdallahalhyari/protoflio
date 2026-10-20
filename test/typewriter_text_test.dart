import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/widgets/typewriter_text.dart';

Widget _host(Widget child, {bool reduceMotion = false}) {
  return MaterialApp(
    home: Scaffold(
      body: MediaQuery(
        data: MediaQueryData(
          accessibleNavigation: reduceMotion,
          disableAnimations: reduceMotion,
        ),
        child: child,
      ),
    ),
  );
}

void main() {
  testWidgets('TypewriterText types characters sequentially upon trigger',
      (tester) async {
    final controller = AnimationController(
      vsync: const TestVSync(),
      duration: AppMotion.coverEntrance,
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(_host(
      TypewriterText(
        text: 'Senior Flutter Architect',
        trigger: controller,
      ),
    ));

    // The cursor is a painted bar (WidgetSpan), never a glyph: no bundled
    // font has one, and a missing glyph pulls a fallback font on web.
    Finder cursor() => find.descendant(
          of: find.byType(TypewriterText),
          matching: find.byType(ColoredBox),
        );

    // Initially trigger is at 0.0, so typewriter has not started and cursor is not shown
    expect(cursor(), findsNothing);

    // Advance controller past trigger threshold (0.5)
    controller.value = 0.6;
    await tester.pump();
    await tester.pump(AppMotion.typewriterChar * 4);

    // Cursor is active, and no block glyph is ever rendered.
    expect(cursor(), findsOneWidget);
    expect(find.textContaining('\u258E'), findsNothing);

    // Settle animation
    await tester.pumpAndSettle();
    // After completion, cursor is dismissed and text is completed
    expect(cursor(), findsNothing);
    expect(find.text('Senior Flutter Architect'), findsOneWidget);
  });

  testWidgets('screen readers get the full sentence while typing',
      (tester) async {
    final handle = tester.ensureSemantics();
    final controller = AnimationController(
      vsync: const TestVSync(),
      duration: AppMotion.coverEntrance,
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(_host(
      TypewriterText(
        text: 'Senior Flutter Architect',
        trigger: controller,
      ),
    ));
    controller.value = 0.6;
    await tester.pump();
    await tester.pump(AppMotion.typewriterChar * 4);

    // Mid-typing: one node with the whole sentence, no partial prefix.
    expect(find.bySemanticsLabel('Senior Flutter Architect'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp(r'^Sen$')), findsNothing);

    await tester.pumpAndSettle();
    handle.dispose();
  });

  testWidgets(
      'TypewriterText respects reduceMotion and renders full text instantly',
      (tester) async {
    final controller = AnimationController(
      vsync: const TestVSync(),
      duration: AppMotion.coverEntrance,
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(_host(
      TypewriterText(
        text: 'Full Text Instantly',
        trigger: controller,
      ),
      reduceMotion: true,
    ));

    // Under reduce motion, text is immediately visible without needing trigger
    expect(find.text('Full Text Instantly'), findsOneWidget);
  });
}
