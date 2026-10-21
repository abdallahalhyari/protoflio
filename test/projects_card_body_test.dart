import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/theme/app_theme.dart';
import 'package:profile/features/projects/presentation/widgets/card/body/project_card_tech_chip.dart';
import 'package:profile/features/projects/presentation/widgets/card/body/project_card_outcome_line.dart';
import 'package:profile/features/projects/presentation/widgets/card/body/project_card_cta.dart';

Widget _wrap(Widget child,
    [Size size = const Size(1200, 900), bool scrollable = true]) {
  return MaterialApp(
    theme: AppTheme.dark(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: MediaQueryData(size: size),
      child: Scaffold(
        body: scrollable ? SingleChildScrollView(child: child) : child,
      ),
    ),
  );
}

void main() {
  group('Project Card Body Extractions Test Suite', () {
    testWidgets('CardTechTagChip renders its tag as a plain label',
        (tester) async {
      await tester.pumpWidget(_wrap(const CardTechTagChip(tag: 'Flutter')));
      await tester.pumpAndSettle();

      expect(find.text('Flutter'), findsOneWidget);
      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('CardOutcomeLine renders text and icon', (tester) async {
      await tester.pumpWidget(_wrap(
        CardOutcomeLine(
          text: 'Increased performance by 50%',
          scheme: AppTheme.dark().colorScheme,
          isDark: true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Increased performance by 50%'), findsOneWidget);
      expect(find.text('IMPACT'), findsOneWidget);
    });

    testWidgets('ReadCaseStudyCta renders correctly and responds to focus',
        (tester) async {
      bool tapped = false;
      bool focused = false;

      await tester.pumpWidget(_wrap(
        ReadCaseStudyCta(
          projectName: 'NatHealth',
          isDesktop: true,
          isDark: true,
          scheme: AppTheme.dark().colorScheme,
          isHovered: false,
          onTap: () => tapped = true,
          onFocusChange: (f) => focused = f,
        ),
      ));
      await tester.pumpAndSettle();

      final inkWell = find.byType(InkWell);
      expect(inkWell, findsOneWidget);

      tester.widget<InkWell>(inkWell).onFocusChange?.call(true);
      await tester.pumpAndSettle();
      expect(focused, isTrue);

      await tester.tap(inkWell);
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });
  });
}
