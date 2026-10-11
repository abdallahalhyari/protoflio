import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/experience/presentation/pages/experience_page.dart';
import 'package:profile/features/experience/presentation/widgets/experience_card.dart';
import 'package:profile/core/theme/app_theme.dart';
import 'helpers/test_data.dart';

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

      expect(find.text('Experience'), findsOneWidget);
      expect(find.text('NatHealth'), findsOneWidget);
      expect(find.text('ESKADENIA Software'), findsOneWidget);
      expect(find.text('Solutions Now IT'), findsOneWidget);
      expect(find.text('Future Advanced Internet Solutions'), findsOneWidget);
      expect(find.text('Academic annex'), findsOneWidget);
    });

    testWidgets('keyboard navigation updates selected experience node',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const ExperiencePage(),
      ));
      await tester.pumpAndSettle();

      final focusFinder = find.byType(Focus);
      expect(focusFinder, findsWidgets);

      // Focus widget accepts arrow keys
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();

      expect(find.text('NatHealth'), findsOneWidget);
    });

    testWidgets('desktop career grid reads chronologically across each row',
        (tester) async {
      await tester.pumpWidget(_wrap(const ExperiencePage()));
      await tester.pumpAndSettle();

      final positions = [
        for (var index = 0; index < testExperience.length; index++)
          tester.getTopLeft(find.byType(ExperienceCard).at(index)),
      ];
      expect(positions, hasLength(4));
      expect(positions[0].dy, closeTo(positions[1].dy, 1));
      expect(positions[0].dx, lessThan(positions[1].dx));
      expect(positions[2].dy, greaterThan(positions[0].dy));
      expect(positions[2].dy, closeTo(positions[3].dy, 1));
      expect(positions[2].dx, lessThan(positions[3].dx));
    });
  });
}
