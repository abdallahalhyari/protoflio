import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers/test_data.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/features/projects/presentation/widgets/interactive_project_card.dart';
import 'package:profile/features/projects/presentation/widgets/nfc_architecture_diagram.dart';

import 'package:profile/features/projects/domain/repositories/project_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/features/projects/presentation/widgets/pipeline_topology_diagram.dart';
import 'package:profile/features/projects/presentation/pages/projects_page.dart';
import 'package:profile/features/projects/presentation/widgets/project_dossier_card.dart';
import 'package:profile/theme/app_theme.dart';

Widget _wrap(Widget child,
    [Size size = const Size(1200, 900), bool scrollable = true]) {
  return MaterialApp(
    theme: AppTheme.dark(),
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

      expect(find.text('PRODUCTION PIPELINE TOPOLOGY'), findsOneWidget);
      expect(find.text('NFC APDU'), findsOneWidget);
      expect(find.text('OFFLINE SQLITE'), findsOneWidget);
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

      expect(find.text('SYSTEM ARCHITECTURE TOPOLOGY'), findsOneWidget);
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
      expect(find.text('100% OFFLINE SLA'), findsOneWidget);
    });

    testWidgets('InteractiveProjectCard renders interactive tech stack chips',
        (tester) async {
      final project = testProjects.first;
      String? tappedTech;
      await tester.pumpWidget(_wrap(
        InteractiveProjectCard(
          project: project,
          index: 0,
          scheme: AppTheme.dark().colorScheme,
          isDesktop: true,
          onSelectTech: (t) => tappedTech = t,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Flutter'), findsOneWidget);
      await tester.tap(find.text('Flutter'));
      await tester.pumpAndSettle();
      expect(tappedTech, equals('Flutter'));
    });

    testWidgets('ProjectsPage domain filtering narrows cards and can be reset',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const ProjectsPage(),
        const Size(1200, 900),
        false,
      ));
      await tester.pumpAndSettle();

      // Initially all 4 projects
      expect(find.text('NatHealth Mobile Suite'), findsOneWidget);
      expect(find.text('E-Learning & Healthcare Enterprise Suite'),
          findsOneWidget);

      // Tap domain filter for Healthcare & Smart Cards
      final healthcareChip = find.text('HEALTHCARE & SMART CARDS');
      expect(healthcareChip, findsOneWidget);
      await tester.tap(healthcareChip);
      await tester.pumpAndSettle();

      // Only NatHealth should be visible
      expect(find.text('NatHealth Mobile Suite'), findsOneWidget);
      expect(
          find.text('E-Learning & Healthcare Enterprise Suite'), findsNothing);

      // Tap ALL to reset
      await tester.tap(find.text('ALL'));
      await tester.pumpAndSettle();

      expect(find.text('NatHealth Mobile Suite'), findsOneWidget);
      expect(find.text('E-Learning & Healthcare Enterprise Suite'),
          findsOneWidget);
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
        of: find.byWidgetPredicate((w) =>
            w is Semantics &&
            (w.properties.label?.startsWith('Read case study') ?? false)),
        matching: find.byType(InkWell),
      );
      expect(cta, findsOneWidget);
      tester.widget<InkWell>(cta).onFocusChange?.call(true);
      await tester.pump();

      // Card elevation and border should be highlighted
      final card = tester.widget<Card>(find.byType(Card));
      final shape = card.shape as RoundedRectangleBorder;
      expect(shape.side.width, equals(1.5));
    });

    testWidgets('ProjectsPage arrow key navigation changes domain filter',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const ProjectsPage(),
        const Size(1200, 900),
        false,
      ));
      await tester.pumpAndSettle();

      // Send arrow right event
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();

      // Should have switched to the next domain (Healthcare & Smart Cards)
      expect(find.text('NatHealth Mobile Suite'), findsOneWidget);
      expect(
          find.text('E-Learning & Healthcare Enterprise Suite'), findsNothing);
    });
  });
}
