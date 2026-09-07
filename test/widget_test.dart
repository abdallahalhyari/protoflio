import 'package:flutter_test/flutter_test.dart';

import 'package:profile/main.dart';

void main() {
  testWidgets('Portfolio smoke test - renders intro', (tester) async {
    await tester.pumpWidget(const PortfolioApp());
    await tester.pump();

    expect(find.textContaining('ABDALLAH'), findsWidgets);
    expect(find.text('Scroll Down'), findsOneWidget);
  });
}
