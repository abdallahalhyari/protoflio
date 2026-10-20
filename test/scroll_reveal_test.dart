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

  testWidgets('child state survives a parent rebuild after the reveal',
      (tester) async {
    await tester.pumpWidget(const _RebuildHost());
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('n='));
    await tester.pump();
    expect(find.text('n=1'), findsOneWidget);

    // A non-const parent rebuild used to remount the revealed child.
    tester.state<_RebuildHostState>(find.byType(_RebuildHost)).bump();
    await tester.pump();
    expect(find.text('n=1'), findsOneWidget);
  });

  testWidgets('unrevealed content stays in the semantics tree', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        // SingleChildScrollView builds everything (a ListView would cull
        // the item past its cache extent and say nothing about the reveal).
        body: SingleChildScrollView(
          child: Column(
            children: const [
              SizedBox(height: 2000),
              ScrollReveal(child: Text('Below the fold')),
            ],
          ),
        ),
      ),
    ));
    await tester.pump();
    expect(find.bySemanticsLabel('Below the fold'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('plays immediately with no scrollable ancestor', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        // Far below the viewport and nothing to scroll it into view.
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 3000,
              left: 0,
              child: ScrollReveal(child: Text('Unscrollable')),
            ),
          ],
        ),
      ),
    ));
    await tester.pumpAndSettle();
    final opacity = tester.widget<Opacity>(find.ancestor(
      of: find.text('Unscrollable'),
      matching: find.byType(Opacity),
    ));
    expect(opacity.opacity, 1.0);
  });
}

class _Counter extends StatefulWidget {
  const _Counter();
  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int n = 0;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => setState(() => n++),
        child: Text('n=$n'),
      );
}

class _RebuildHost extends StatefulWidget {
  const _RebuildHost();
  @override
  State<_RebuildHost> createState() => _RebuildHostState();
}

class _RebuildHostState extends State<_RebuildHost> {
  int _tick = 0;
  void bump() => setState(() => _tick++);

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Text('tick=$_tick'),
              // Deliberately non-const so the reveal wrapper rebuilds.
              // ignore: prefer_const_constructors
              ScrollReveal(child: const _Counter()),
            ],
          ),
        ),
      );
}
