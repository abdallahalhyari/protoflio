import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/module/home/data/projects_data.dart';
import 'package:profile/module/home/widget/projects/nfc_architecture_diagram.dart';
import 'package:profile/module/home/widget/projects/pipeline_topology_diagram.dart';
import 'package:profile/module/home/widget/projects/project_dossier_card.dart';
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
  group('Projects Widgets Test Suite', () {
    testWidgets('PipelineTopologyDiagram renders pipeline topology stages', (tester) async {
      final project = kProjects.first; // NatHealth
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

    testWidgets('NfcArchitectureDiagram renders full node topology', (tester) async {
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
      expect(find.text('Offline medical sync failure under low network bandwidth.'), findsOneWidget);
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
      expect(find.textContaining('Keystore backed JWT encryption'), findsOneWidget);
      expect(find.textContaining('§'), findsOneWidget);
    });
  });
}
