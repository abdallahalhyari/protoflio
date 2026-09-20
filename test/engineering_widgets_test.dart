import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/module/home/data/architecture_data.dart';
import 'package:profile/module/home/widget/engineering/architecture_details_card.dart';
import 'package:profile/module/home/widget/engineering/architecture_diagram_card.dart';
import 'package:profile/module/home/widget/engineering/architecture_inspect_modal.dart';
import 'package:profile/module/home/widget/engineering/architecture_topic_tabs.dart';
import 'package:profile/module/home/widget/engineering/engineering_header.dart';
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
    testWidgets('EngineeringHeader renders title, subtitle, and badge', (tester) async {
      await tester.pumpWidget(_wrap(const EngineeringHeader(isDesktop: true)));
      await tester.pumpAndSettle();

      expect(find.text('FEATURE 03 · SYSTEMS ARCHITECTURE'), findsOneWidget);
      expect(find.text('ENGINEERING EXPERTISE'), findsOneWidget);
      expect(find.text('4 ARCHITECTURES'), findsOneWidget);
    });

    testWidgets('ArchitectureTopicTabs renders all topics and triggers selection', (tester) async {
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
      expect(find.textContaining('OFFLINE-FIRST SYNCHRONIZATION'), findsOneWidget);

      await tester.tap(find.textContaining('OFFLINE-FIRST SYNCHRONIZATION'));
      await tester.pumpAndSettle();

      expect(selected, 1);
    });

    testWidgets('ArchitectureDiagramCard renders flowchart tiers', (tester) async {
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

    testWidgets('ArchitectureDetailsCard renders summary and safeguards', (tester) async {
      final topic = kArchitectureTopics[1]; // Offline-First
      await tester.pumpWidget(_wrap(
        SizedBox(
          height: 600,
          child: ArchitectureDetailsCard(topic: topic, isDesktop: true),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text(topic.title), findsOneWidget);
      expect(find.text('ARCHITECTURAL RATIONALE (WHY THIS CHOICE)'), findsOneWidget);
      expect(find.text('KEY IMPLEMENTATION SAFEGUARDS'), findsOneWidget);
      expect(find.text(topic.summary), findsOneWidget);
    });

    testWidgets('ArchitectureDiagramCard renders simulator bar and telemetry strip when callbacks provided', (tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final topic = kArchitectureTopics[2]; // NFC APDU
      int activeStep = 0;
      bool playToggled = false;

      await tester.pumpWidget(_wrap(
        StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: 900,
              child: ArchitectureDiagramCard(
                topic: topic,
                isDesktop: true,
                activeStepIndex: activeStep,
                isPlaying: false,
                onPreviousStep: () => setState(() => activeStep = (activeStep - 1).clamp(0, topic.diagramSteps.length - 1)),
                onNextStep: () => setState(() => activeStep = (activeStep + 1).clamp(0, topic.diagramSteps.length - 1)),
                onTogglePlay: () => playToggled = true,
                onResetStep: () => setState(() => activeStep = 0),
                onSelectStep: (s) => setState(() => activeStep = s),
              ),
            );
          },
        ),
      ));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('STEP 1 / 4'), findsOneWidget);
      expect(find.text('NEXT'), findsOneWidget);
      expect(find.text('TELEMETRY BUFFER // DISCOVERY'), findsOneWidget);
      expect(find.textContaining('SW_9000_NO_ERROR'), findsNothing);

      // Advance to step 3 (COMMAND CHAIN)
      await tester.tap(find.text('NEXT'));
      await tester.pump(const Duration(milliseconds: 100));
      expect(activeStep, 1);

      await tester.tap(find.text('NEXT'));
      await tester.pump(const Duration(milliseconds: 100));
      expect(activeStep, 2);

      // Verify Step 3 telemetry displays ISO-7816 APDU command
      expect(find.text('STEP 3 / 4'), findsOneWidget);
      expect(find.text('TELEMETRY BUFFER // COMMAND CHAIN'), findsOneWidget);
      expect(find.text('SW_9000_NO_ERROR'), findsOneWidget);

      // Test play toggle
      await tester.tap(find.text('AUTO'));
      await tester.pump(const Duration(milliseconds: 100));
      expect(playToggled, isTrue);
    });

    testWidgets('showArchitectureInspectModal opens dialog and renders InteractiveViewer', (tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final topic = kArchitectureTopics.first;
      int changedStep = 0;

      await tester.pumpWidget(_wrap(
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                showArchitectureInspectModal(
                  context,
                  topic: topic,
                  currentStep: 0,
                  onStepChanged: (s) => changedStep = s,
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

      await tester.tap(find.text('NEXT'));
      await tester.pump(const Duration(milliseconds: 100));
      expect(changedStep, 1);
    });
  });
}
