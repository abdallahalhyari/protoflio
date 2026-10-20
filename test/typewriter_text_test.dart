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

    // Initially trigger is at 0.0, so typewriter has not started and cursor is not shown
    expect(find.textContaining('▎'), findsNothing);

    // Advance controller past trigger threshold (0.5)
    controller.value = 0.6;
    await tester.pump();
    await tester.pump(AppMotion.typewriterChar * 4);

    // Cursor is active
    expect(find.textContaining('▎'), findsOneWidget);

    // Settle animation
    await tester.pumpAndSettle();
    // After completion, cursor is dismissed and text is completed
    expect(find.textContaining('▎'), findsNothing);
    expect(find.text('Senior Flutter Architect'), findsOneWidget);
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
