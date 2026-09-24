import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/engineering/data/architecture_data.dart';
import 'package:profile/features/engineering/widget/architecture_details_card.dart';
import 'package:profile/features/engineering/widget/architecture_diagram_card.dart';
import 'package:profile/features/engineering/widget/architecture_inspect_modal.dart';
import 'package:profile/features/engineering/widget/architecture_topic_tabs.dart';
import 'package:profile/features/engineering/widget/engineering_header.dart';
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
  group('Engineering Widgets Test Suite', () {
    testWidgets('EngineeringHeader renders title, subtitle, and badge',
        (tester) async {
      await tester.pumpWidget(_wrap(const EngineeringHeader(isDesktop: true)));
      await tester.pumpAndSettle();

      expect(find.text('FEATURE 03 · SYSTEMS ARCHITECTURE'), findsOneWidget);
      expect(find.text('ENGINEERING EXPERTISE'), findsOneWidget);
      expect(find.text('4 ARCHITECTURES'), findsOneWidget);
    });

    testWidgets(
        'ArchitectureTopicTabs renders all topics and triggers selection',
        (tester) async {
      int selected = 0;
      await tester.pumpWidget(_wrap(
        StatefulBuilder(
          builder: (context, setState) {
            return ArchitectureTopicTabs(
              topics: kArchitectureTopics,
              selectedIndex: selected,
              onSelectTopic: (i) => setState(() => selected = i),
              isDesktop: true,
            );
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('CLEAN MOBILE ARCHITECTURE'), findsOneWidget);
      expect(
          find.textContaining('OFFLINE-FIRST SYNCHRONIZATION'), findsOneWidget);

      await tester.tap(find.textContaining('OFFLINE-FIRST SYNCHRONIZATION'));
      await tester.pumpAndSettle();

      expect(selected, 1);
    });

    testWidgets('ArchitectureDiagramCard renders flowchart tiers',
        (tester) async {
      final topic = kArchitectureTopics.first;
      await tester.pumpWidget(_wrap(
        SizedBox(
          height: 600,
          child: ArchitectureDiagramCard(topic: topic, isDesktop: true),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('ARCHITECTURE FLOWCHART'), findsOneWidget);
      expect(find.text('${topic.diagramSteps.length} TIERS'), findsOneWidget);
      expect(find.text(topic.diagramSteps.first.title), findsWidgets);
    });

    testWidgets('ArchitectureDetailsCard renders summary and safeguards',
        (tester) async {
      final topic = kArchitectureTopics[1]; // Offline-First
      await tester.pumpWidget(_wrap(
        SizedBox(
          height: 600,
          child: ArchitectureDetailsCard(topic: topic, isDesktop: true),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text(topic.title), findsOneWidget);
      expect(find.text('ARCHITECTURAL RATIONALE (WHY THIS CHOICE)'),
          findsOneWidget);
      expect(find.text('KEY IMPLEMENTATION SAFEGUARDS'), findsOneWidget);
      expect(find.text(topic.summary), findsOneWidget);
    });

    testWidgets(
        'showArchitectureInspectModal opens dialog and renders InteractiveViewer',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final topic = kArchitectureTopics.first;

      await tester.pumpWidget(_wrap(
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                showArchitectureInspectModal(
                  context,
                  topic: topic,
                  currentStep: 0,
                  onStepChanged: (_) {},
                );
              },
              child: const Text('OPEN MODAL'),
            );
          },
        ),
      ));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.text('OPEN MODAL'));
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('INSPECT BLUEPRINT // ZOOM & SIMULATE'), findsOneWidget);
      expect(find.byType(InteractiveViewer), findsOneWidget);
    });
  });
}
