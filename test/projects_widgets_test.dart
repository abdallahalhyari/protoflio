import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers/test_data.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/features/projects/presentation/widgets/interactive_project_card.dart';
import 'package:profile/features/projects/presentation/widgets/card/body/project_card_cta.dart';
import 'package:profile/features/projects/presentation/widgets/nfc_architecture_diagram.dart';

import 'package:profile/features/projects/domain/repositories/project_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/features/projects/presentation/widgets/pipeline_topology_diagram.dart';
import 'package:profile/features/projects/presentation/pages/projects_page.dart';
import 'package:profile/features/projects/presentation/widgets/project_dossier_card.dart';
import 'package:profile/core/theme/app_theme.dart';

Widget _wrap(Widget child,
    [Size size = const Size(1200, 900),
    bool scrollable = true,
    Locale? locale]) {
  return MaterialApp(
    theme: AppTheme.dark(),
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: MediaQueryData(size: size),
      child: RepositoryProvider<ProjectRepository>(
        create: (_) => TestProjectRepository(),
        child: Scaffold(
          body: scrollable ? SingleChildScrollView(child: child) : child,
        ),
      ),
    ),
  );
}

void main() {
  group('Projects Widgets Test Suite', () {
    testWidgets('PipelineTopologyDiagram renders pipeline topology stages',
        (tester) async {
      final project = testProjects.first; // NatHealth
      await tester.pumpWidget(_wrap(
        PipelineTopologyDiagram(
          project: project,
          isDesktop: true,
          isDark: true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Production pipeline topology'), findsOneWidget);
      expect(find.text('NFC APDU'), findsOneWidget);
      expect(find.text('Offline SQLite'), findsOneWidget);
    });

    testWidgets('NfcArchitectureDiagram renders full node topology',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const NfcArchitectureDiagram(
          isDesktop: true,
          isDark: true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('System architecture topology'), findsOneWidget);
      expect(find.textContaining('NFC Hardware'), findsOneWidget);
      expect(find.textContaining('APDU Channel'), findsOneWidget);
      expect(find.textContaining('Clean Arch'), findsOneWidget);
      expect(find.textContaining('Offline Queue'), findsOneWidget);
      expect(find.textContaining('TPA Backend'), findsOneWidget);
    });

    testWidgets('ProjectDossierCard renders label and content', (tester) async {
      await tester.pumpWidget(_wrap(
        const ProjectDossierCard(
          label: 'CORE PROBLEM',
          value: 'Offline medical sync failure under low network bandwidth.',
          accentColor: Colors.red,
          isDesktop: true,
          isDark: true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('CORE PROBLEM'), findsOneWidget);
      expect(
          find.text(
              'Offline medical sync failure under low network bandwidth.'),
          findsOneWidget);
      expect(find.byIcon(Icons.api_rounded), findsOneWidget);
    });

    testWidgets('ProjectHighlightRow formats prefix and body', (tester) async {
      await tester.pumpWidget(_wrap(
        const ProjectHighlightRow(
          highlight: 'SECURITY: Keystore backed JWT encryption',
          isDesktop: true,
          isDark: true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('SECURITY:'), findsOneWidget);
      expect(find.textContaining('Keystore backed JWT encryption'),
          findsOneWidget);
      expect(find.textContaining('§'), findsOneWidget);
    });

    testWidgets(
        'InteractiveProjectCard renders company website and linkedin quick-link buttons',
        (tester) async {
      final project = testProjects.first;
      await tester.pumpWidget(_wrap(
        InteractiveProjectCard(
          project: project,
          index: 0,
          scheme: AppTheme.dark().colorScheme,
          isDesktop: true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(
          find.byTooltip('Visit NatHealth official website'), findsOneWidget);
      expect(find.byTooltip('View NatHealth on LinkedIn'), findsOneWidget);
      expect(find.text('in'), findsOneWidget);
      expect(find.text('100% Offline SLA'), findsOneWidget);
    });

    testWidgets('InteractiveProjectCard shows the full case and every tag',
        (tester) async {
      final project = testProjects.first;
      await tester.pumpWidget(_wrap(
        InteractiveProjectCard(
          project: project,
          index: 0,
          scheme: AppTheme.dark().colorScheme,
          isDesktop: true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Problem'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);
      expect(find.text('My role'), findsOneWidget);
      for (final tag in project.stack) {
        expect(find.text(tag), findsOneWidget);
      }
      // No hidden-tags counter like '+3'.
      expect(find.textContaining(RegExp(r'^\+\d+$')), findsNothing);
    });

    testWidgets('ProjectsPage desktop shows all four projects two per row',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(_wrap(
        const ProjectsPage(),
        const Size(1200, 900),
        false,
      ));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('projects_grid')), findsOneWidget);
      final cards = find.byType(InteractiveProjectCard);
      expect(cards, findsNWidgets(4));

      final r0 = tester.getRect(cards.at(0));
      final r1 = tester.getRect(cards.at(1));
      final r2 = tester.getRect(cards.at(2));
      // Same row, equal height; next row below.
      expect(r0.top, r1.top);
      expect(r0.height, r1.height);
      expect(r1.left, greaterThan(r0.right));
      expect(r2.top, greaterThan(r0.bottom));
      expect(tester.takeException(), isNull);
    });

    testWidgets('ProjectsPage mobile stacks the projects in one column',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(_wrap(
        const ProjectsPage(),
        const Size(390, 844),
        false,
      ));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('projects_list')), findsOneWidget);
      final cards = find.byType(InteractiveProjectCard);
      final first = tester.getRect(cards.at(0));
      final second = tester.getRect(cards.at(1));
      expect(second.left, first.left);
      expect(second.top, greaterThan(first.bottom));
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'InteractiveProjectCard activates focus styling when keyboard focused',
        (tester) async {
      final project = testProjects.first;
      await tester.pumpWidget(_wrap(
        InteractiveProjectCard(
          project: project,
          index: 0,
          scheme: AppTheme.dark().colorScheme,
          isDesktop: true,
        ),
      ));
      await tester.pumpAndSettle();

      // Keyboard focus lands on the card's "Read case study" control (the
      // card-wide InkWell is pointer-only).
      final cta = find.descendant(
        of: find.byType(ReadCaseStudyCta),
        matching: find.byType(InkWell),
      );
      expect(cta, findsOneWidget);
      tester.widget<InkWell>(cta).onFocusChange?.call(true);
      await tester.pump();

      // Card elevation and border should be highlighted
      final container = tester.widget<AnimatedContainer>(
        find
            .descendant(
              of: find.byType(InteractiveProjectCard),
              matching: find.byType(AnimatedContainer),
            )
            .first,
      );
      final decoration = container.decoration as BoxDecoration;
      final border = decoration.border as Border;
      expect(border.top.width, equals(1.5));
    });
  });
}
