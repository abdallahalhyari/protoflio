import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/engineering/data/datasources/architecture_data.dart';
import 'package:profile/features/engineering/presentation/widgets/architecture_details.dart';
import 'package:profile/features/engineering/presentation/widgets/layer_stack.dart';
import 'package:profile/features/engineering/presentation/widgets/architecture_topic_tabs.dart';
import 'package:profile/features/engineering/presentation/widgets/engineering_header.dart';
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
  group('Engineering Widgets Test Suite', () {
    testWidgets('EngineeringHeader renders title, subtitle, and badge',
        (tester) async {
      await tester.pumpWidget(_wrap(const EngineeringHeader(isDesktop: true)));
      await tester.pumpAndSettle();

      expect(
          find.text(
              'The architectures behind my mobile suites: layers, offline sync, NFC and token security.'),
          findsOneWidget);
      expect(find.text('Engineering'), findsOneWidget);
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
            );
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('Clean architecture'), findsOneWidget);
      expect(find.textContaining('Offline-first sync'), findsOneWidget);

      await tester.tap(find.textContaining('Offline-first sync'));
      await tester.pumpAndSettle();

      expect(selected, 1);
    });

    testWidgets('LayerStack lists every layer, in order, and is not a control',
        (tester) async {
      final topic = kArchitectureTopics.first;
      await tester.pumpWidget(_wrap(LayerStack(topic: topic)));
      await tester.pumpAndSettle();

      final tops = [
        for (final step in topic.diagramSteps)
          tester.getTopLeft(find.text(step.title)).dy,
      ];
      expect(tops, orderedEquals([...tops]..sort()));
      // No per-layer timing figures: they weren't measurements.
      expect(find.text('Latency target'), findsNothing);
      // Layers are read, not picked: nothing in the stack takes taps.
      expect(
        find.descendant(
            of: find.byType(LayerStack), matching: find.byType(InkWell)),
        findsNothing,
      );
      expect(
        find.descendant(
            of: find.byType(LayerStack),
            matching: find.byType(GestureDetector)),
        findsNothing,
      );
    });

    testWidgets('ArchitectureDetails states why, the cost and where it ran',
        (tester) async {
      final topic = kArchitectureTopics[1]; // Offline-first sync
      await tester.pumpWidget(_wrap(ArchitectureDetails(topic: topic)));
      await tester.pumpAndSettle();

      // The heading is the topic's display name.
      expect(find.text('Offline-first sync'), findsOneWidget);
      expect(find.text(topic.summary), findsOneWidget);
      expect(find.text('Why this choice'), findsOneWidget);
      expect(find.text('What it costs'), findsOneWidget);
      expect(find.text(topic.cost), findsOneWidget);
      expect(find.text('Safeguards'), findsOneWidget);
      expect(find.text('Used at'), findsOneWidget);
      expect(find.text(topic.usedAt), findsOneWidget);
      // There is no playground to send anyone to, so no demo button.
      expect(find.textContaining('demos'), findsNothing);
      expect(find.byType(OutlinedButton), findsNothing);
    });

    test('every topic separates its cost from why it was chosen', () {
      for (final topic in kArchitectureTopics) {
        expect(topic.cost, isNotEmpty, reason: topic.id);
        expect(topic.whyChosen, isNot(contains('The cost')), reason: topic.id);
      }
    });
  });
}
