import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/module/home/widget/mobile_app_bar.dart';

Widget _host(Widget child) {
  return MaterialApp(
    theme: ThemeData(brightness: Brightness.dark),
    home: Scaffold(
      appBar: null,
      body: SafeArea(child: child),
    ),
  );
}

void main() {
  testWidgets('renders monogram + AVAILABLE fallback when no section passed',
      (tester) async {
    await tester.pumpWidget(_host(MobileAppBar(onMenuPressed: () {})));
    expect(find.text('ABDALLAH'), findsOneWidget);
    expect(find.text('AVAILABLE'), findsOneWidget);
    // MENU pill always present.
    expect(find.text('MENU'), findsOneWidget);
  });

  testWidgets('renders live section badge when passed', (tester) async {
    await tester.pumpWidget(_host(MobileAppBar(
      onMenuPressed: () {},
      activeSectionLabel: 'Engineering',
      activeSectionIndex: 3,
      sectionCount: 7,
    )));
    expect(find.text('AVAILABLE'), findsNothing);
    expect(find.text('03 / 07'), findsOneWidget);
    expect(find.text('ENGINEERING'), findsOneWidget);
  });

  testWidgets('menu callback fires', (tester) async {
    int hits = 0;
    await tester.pumpWidget(_host(MobileAppBar(onMenuPressed: () => hits++)));
    await tester.tap(find.text('MENU'));
    await tester.pump(const Duration(milliseconds: 50));
    expect(hits, 1);
  });
}
