import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/shared/widgets/viewport_ticker_gate.dart';

/// Reads the nearest enclosing TickerMode flag so the test can assert the
/// gate toggled it.
class _TickerProbe extends StatelessWidget {
  const _TickerProbe({required this.onBuild});
  final void Function(bool enabled) onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild(TickerMode.valuesOf(context).enabled);
    return const SizedBox(height: 300);
  }
}

void main() {
  testWidgets('enables tickers while on screen, disables when scrolled away',
      (tester) async {
    final enabledLog = <bool>[];
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: 600,
          // SingleChildScrollView keeps the gate built off-screen (no lazy
          // culling), so the probe can observe TickerMode after it scrolls
          // out — a ListView would unmount it past the cache extent.
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              children: [
                ViewportTickerGate(
                  child: _TickerProbe(onBuild: enabledLog.add),
                ),
                const SizedBox(height: 2000),
              ],
            ),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    // On first layout the gate is on screen → tickers enabled.
    expect(enabledLog.last, isTrue);

    // Jump far past the gate + its margin.
    controller.jumpTo(1500);
    await tester.pumpAndSettle();
    expect(enabledLog.last, isFalse);

    // Jump back to the top → re-enabled.
    controller.jumpTo(0);
    await tester.pumpAndSettle();
    expect(enabledLog.last, isTrue);
  });

  testWidgets('defaults to enabled with no enclosing scrollable',
      (tester) async {
    bool? enabled;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ViewportTickerGate(
          child: _TickerProbe(onBuild: (e) => enabled = e),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    expect(enabled, isTrue);
  });
}
