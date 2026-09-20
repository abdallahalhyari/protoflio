import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/hats/data/hats_data.dart';
import 'package:profile/features/hats/widget/continuous_mobile_hat_column.dart';
import 'package:profile/features/hats/widget/hat_bio_strip.dart';
import 'package:profile/features/hats/widget/hat_console_dock.dart';
import 'package:profile/features/hats/widget/hat_deck_header.dart';
import 'package:profile/features/hats/widget/hat_drag_hint.dart';
import 'package:profile/features/hats/widget/hat_pagination_row.dart';
import 'package:profile/features/hats/widget/hat_role_pills.dart';
import 'package:profile/theme/app_theme.dart';

Widget _wrap(Widget child, [Size size = const Size(1200, 900)]) {
  return MaterialApp(
    theme: AppTheme.dark(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: MediaQueryData(size: size),
      child: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );
}

void main() {
  group('Hats Widgets Test Suite', () {
    testWidgets('HatDeckHeader renders title and deck actions', (tester) async {
      bool shuffled = false;
      bool reset = false;
      await tester.pumpWidget(_wrap(
        HatDeckHeader(
          isMobile: false,
          onShuffle: () => shuffled = true,
          onReset: () => reset = true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('ARCHITECTURAL PERSPECTIVES'), findsOneWidget);
      expect(find.text('SPREAD'), findsOneWidget);
      expect(find.text('ALIGN'), findsOneWidget);

      await tester.tap(find.text('SPREAD'));
      await tester.pumpAndSettle();
      expect(shuffled, isTrue);

      await tester.tap(find.text('ALIGN'));
      await tester.pumpAndSettle();
      expect(reset, isTrue);
    });

    testWidgets('HatBioStrip renders avatar, credentials, and bio copy', (tester) async {
      await tester.pumpWidget(_wrap(const HatBioStrip(isMobile: false)));
      await tester.pumpAndSettle();

      expect(find.textContaining('AMMAN · JORDAN'), findsOneWidget);
      expect(find.textContaining('BRNO · CZECH REPUBLIC · 2027'), findsOneWidget);
      expect(find.textContaining('Senior mobile engineer'), findsOneWidget);
    });

    testWidgets('HatRolePills renders roles and triggers selection', (tester) async {
      int selected = 0;
      await tester.pumpWidget(_wrap(
        StatefulBuilder(
          builder: (context, setState) {
            return HatRolePills(
              selectedIndex: selected,
              isDesktop: true,
              onSelectRole: (i) => setState(() => selected = i),
            );
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('01 THINKING'), findsOneWidget);
      expect(find.text('02 COMMUNICATING'), findsOneWidget);

      await tester.tap(find.text('02 COMMUNICATING'));
      await tester.pumpAndSettle();
      expect(selected, 1);
    });

    testWidgets('HatPaginationRow renders index and triggers prev/next', (tester) async {
      bool prev = false;
      bool next = false;
      await tester.pumpWidget(_wrap(
        HatPaginationRow(
          selectedIndex: 2,
          totalCount: 6,
          onPrev: () => prev = true,
          onNext: () => next = true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('ROLE 03 / 06'), findsOneWidget);

      await tester.tap(find.text('PREV'));
      await tester.pumpAndSettle();
      expect(prev, isTrue);

      await tester.tap(find.text('NEXT'));
      await tester.pumpAndSettle();
      expect(next, isTrue);
    });

    testWidgets('HatDragHint renders guidance label', (tester) async {
      await tester.pumpWidget(_wrap(const HatDragHint()));
      await tester.pumpAndSettle();

      expect(find.textContaining('DRAG THE CARDS'), findsOneWidget);
    });

    testWidgets('ContinuousMobileHatColumn renders mobile card showcase', (tester) async {
      await tester.pumpWidget(_wrap(
        ContinuousMobileHatColumn(
          selectedHatIndex: 0,
          onSelectRole: (_) {},
          onNextRole: () {},
          onPrevRole: () {},
          onCardTap: () {},
        ),
        const Size(400, 800),
      ));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('FEATURE 06 · 6 ROLES'), findsOneWidget);
      expect(find.text('ARCHITECTURAL PERSPECTIVES'), findsOneWidget);
      expect(find.textContaining('TAP CARD TO FLIP'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('HatConsoleDock renders active role pill, navigation buttons, and actions', (tester) async {
      bool prev = false;
      bool next = false;
      bool shuffle = false;
      bool reset = false;

      await tester.pumpWidget(_wrap(
        HatConsoleDock(
          selectedIndex: 0,
          totalCount: kHats.length,
          currentHat: kHats[0],
          onPrev: () => prev = true,
          onNext: () => next = true,
          onShuffle: () => shuffle = true,
          onReset: () => reset = true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('01 / 06'), findsOneWidget);
      expect(find.text('THINKING'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome_motion_rounded), findsOneWidget);
      expect(find.byIcon(Icons.layers_clear_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      expect(prev, isTrue);

      await tester.tap(find.byIcon(Icons.arrow_forward_rounded));
      await tester.pumpAndSettle();
      expect(next, isTrue);

      await tester.tap(find.byIcon(Icons.auto_awesome_motion_rounded));
      await tester.pumpAndSettle();
      expect(shuffle, isTrue);

      await tester.tap(find.byIcon(Icons.layers_clear_outlined));
      await tester.pumpAndSettle();
      expect(reset, isTrue);
    });
  });
}
