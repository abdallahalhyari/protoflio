import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/shared/widgets/scroll_reveal.dart';

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
  testWidgets('ScrollReveal displays child directly under reduceMotion',
      (tester) async {
    await tester.pumpWidget(_host(
      const ScrollReveal(
        child: Text('Revealed Content'),
      ),
      reduceMotion: true,
    ));

    expect(find.text('Revealed Content'), findsOneWidget);
  });

  testWidgets('ScrollReveal triggers animation and settles cleanly',
      (tester) async {
    await tester.pumpWidget(_host(
      const SingleChildScrollView(
        child: ScrollReveal(
          child: Text('Scroll Target'),
        ),
      ),
    ));

    await tester.pumpAndSettle();
    expect(find.text('Scroll Target'), findsOneWidget);
  });

  testWidgets('ScrollReveal.stagger creates delayed staggered reveal',
      (tester) async {
    await tester.pumpWidget(_host(
      SingleChildScrollView(
        child: Column(
          children: [
            ScrollReveal.stagger(
              index: 0,
              child: const Text('Item 0'),
            ),
            ScrollReveal.stagger(
              index: 1,
              child: const Text('Item 1'),
            ),
          ],
        ),
      ),
    ));

    await tester.pumpAndSettle();
    expect(find.text('Item 0'), findsOneWidget);
    expect(find.text('Item 1'), findsOneWidget);
  });
}
