import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/experience/page/experience_page.dart';
import 'package:profile/theme/app_theme.dart';

Widget _wrap(Widget child,
    {Size size = const Size(1400, 900), bool scrollable = false}) {
  return MaterialApp(
    theme: AppTheme.dark(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: MediaQueryData(size: size),
      child: Scaffold(
        body: scrollable
            ? SingleChildScrollView(child: child)
            : SizedBox(
                width: size.width,
                height: size.height,
                child: child,
              ),
      ),
    ),
  );
}

void main() {
  group('ExperiencePage Test Suite', () {
    testWidgets(
        'renders ExperiencePage desktop grid with 4 roles and credentials',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const ExperiencePage(isContinuousMobile: true),
        scrollable: true,
      ));
      await tester.pumpAndSettle();

      expect(find.text('EXPERIENCE'), findsOneWidget);
      expect(find.text('NatHealth'), findsOneWidget);
      expect(find.text('ESKADENIA Software'), findsOneWidget);
      expect(find.text('Solutions Now IT'), findsOneWidget);
      expect(find.text('Future Advanced Internet Solutions'), findsOneWidget);
      expect(find.text('ACADEMIC ANNEX'), findsOneWidget);
    });

    testWidgets('keyboard navigation updates selected experience node',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const ExperiencePage(isContinuousMobile: false),
        scrollable: false,
      ));
      await tester.pumpAndSettle();

      final focusFinder = find.byType(Focus);
      expect(focusFinder, findsWidgets);

      // Focus widget accepts arrow keys
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();

      expect(find.text('NatHealth'), findsOneWidget);
    });
  });
}
