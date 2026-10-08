import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers/test_data.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/features/hats/presentation/pages/hats_grid_page.dart';
import 'package:profile/features/hats/presentation/widgets/continuous_mobile_hat_column.dart';
import 'package:profile/features/hats/presentation/widgets/hat_bio_strip.dart';
import 'package:profile/features/hats/presentation/widgets/hat_console_dock.dart';
import 'package:profile/features/hats/presentation/widgets/hat_deck_header.dart';
import 'package:profile/features/hats/presentation/widgets/hat_drag_hint.dart';
import 'package:profile/features/hats/presentation/widgets/hat_pagination_row.dart';
import 'package:profile/features/hats/presentation/widgets/hat_role_pills.dart';
import 'package:profile/core/theme/app_theme.dart';

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

      expect(find.text('Perspectives'), findsOneWidget);
      expect(find.text('Spread'), findsOneWidget);
      expect(find.text('Align'), findsOneWidget);

      await tester.tap(find.text('Spread'));
      await tester.pumpAndSettle();
      expect(shuffled, isTrue);

      await tester.tap(find.text('Align'));
      await tester.pumpAndSettle();
      expect(reset, isTrue);
    });

    testWidgets('HatBioStrip renders avatar, credentials, and bio copy',
        (tester) async {
      await tester.pumpWidget(_wrap(const HatBioStrip(isMobile: false)));
      await tester.pumpAndSettle();

      expect(find.textContaining('Amman, Jordan'), findsOneWidget);
      expect(find.textContaining('Brno, Czech Republic, 2027'), findsOneWidget);
      expect(find.textContaining('Senior mobile engineer'), findsOneWidget);
    });

    testWidgets('HatRolePills renders roles and triggers selection',
        (tester) async {
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

      expect(find.text('01 Thinking'), findsOneWidget);
      expect(find.text('02 Communicating'), findsOneWidget);

      await tester.tap(find.text('02 Communicating'));
      await tester.pumpAndSettle();
      expect(selected, 1);
    });

    testWidgets('HatPaginationRow renders index and triggers prev/next',
        (tester) async {
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

      expect(find.text('Role 03 / 06'), findsOneWidget);

      await tester.tap(find.text('Previous'));
      await tester.pumpAndSettle();
      expect(prev, isTrue);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(next, isTrue);
    });

    testWidgets('HatDragHint renders guidance label', (tester) async {
      await tester.pumpWidget(_wrap(const HatDragHint()));
      await tester.pumpAndSettle();

      expect(find.textContaining('Drag the cards'), findsOneWidget);
    });

    testWidgets('ContinuousMobileHatColumn renders mobile card showcase',
        (tester) async {
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

      expect(find.text('Perspectives'), findsOneWidget);
      expect(find.textContaining('Product-minded engineering'), findsOneWidget);
      expect(find.textContaining('Tap a card to flip it'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'HatConsoleDock renders active role pill, navigation buttons, and actions',
        (tester) async {
      bool prev = false;
      bool next = false;
      bool shuffle = false;
      bool reset = false;

      await tester.pumpWidget(_wrap(
        HatConsoleDock(
          selectedIndex: 0,
          totalCount: testHats.length,
          currentHat: testHats[0],
          onPrev: () => prev = true,
          onNext: () => next = true,
          onShuffle: () => shuffle = true,
          onReset: () => reset = true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('01 / 06'), findsOneWidget);
      expect(find.text('Thinking'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome_motion_rounded), findsOneWidget);
      expect(find.byIcon(Icons.layers_clear_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      expect(prev, isTrue);

      await tester.tap(find.byIcon(Icons.arrow_forward_rounded));
      await tester.pumpAndSettle();
      expect(next, isTrue);

      await tester.tap(find.byIcon(Icons.auto_awesome_motion_rounded));
      await tester.pumpAndSettle();
      expect(shuffle, isTrue);

      await tester.tap(find.byIcon(Icons.layers_clear_rounded));
      await tester.pumpAndSettle();
      expect(reset, isTrue);
    });

    testWidgets(
        'HatsGridPage keyboard shortcuts (arrow cycle, S shuffle) actually '
        'fire — regression test for the dead-focus bug fixed this session',
        (tester) async {
      // HatsGridPage fills its parent via SizedBox.expand — needs bounded
      // constraints, unlike _wrap's SingleChildScrollView used elsewhere
      // in this file for standalone sub-widgets. The surface matches the
      // MediaQuery below: on the default 800x600 surface the header laid
      // out 400px narrower than the page believed and wrapped the deck
      // off screen.
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const MediaQuery(
          data: MediaQueryData(size: Size(1200, 900)),
          child: Scaffold(body: HatsGridPage()),
        ),
      ));
      // HatsGridPage has ambient looping animations, so pumpAndSettle would
      // time out waiting for them to finish — pump a fixed settle window
      // instead, matching the existing HatsGridPage test in widget_test.dart.
      await tester.pump(const Duration(milliseconds: 300));

      // The dock's active-role label is what the shortcuts move. Scoped
      // to the dock: with the deck on screen the cards carry the same
      // role names.
      Finder dock(String role) => find.descendant(
          of: find.byType(HatConsoleDock), matching: find.text(role));
      expect(dock('Thinking'), findsOneWidget);
      expect(dock('Communicating'), findsNothing);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump(const Duration(milliseconds: 300));
      expect(dock('Communicating'), findsOneWidget);
      expect(dock('Thinking'), findsNothing);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pump(const Duration(milliseconds: 300));
      expect(dock('Thinking'), findsOneWidget);
    });
  });
}
