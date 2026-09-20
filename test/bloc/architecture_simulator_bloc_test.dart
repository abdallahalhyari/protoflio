import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/engineering/bloc/architecture_simulator_bloc.dart';
import 'package:profile/features/engineering/bloc/architecture_simulator_event.dart';
import 'package:profile/features/engineering/bloc/architecture_simulator_state.dart';
import 'package:profile/features/engineering/data/architecture_data.dart';

void main() {
  group('ArchitectureSimulatorBloc Test Suite', () {
    test('initial state defaults to first architecture topic at step 0',
        () async {
      final bloc = ArchitectureSimulatorBloc();
      expect(bloc.state.topics.length, equals(kArchitectureTopics.length));
      expect(bloc.state.selectedTopicIndex, equals(0));
      expect(bloc.state.currentStepIndex, equals(0));
      expect(bloc.state.isPlaying, isFalse);
      expect(bloc.state.currentTopic.id, equals(kArchitectureTopics.first.id));
      await bloc.close();
    });

    test('SimulatorTopicSelected switches topic and resets active step to 0',
        () async {
      final bloc = ArchitectureSimulatorBloc();

      // Switch to topic 1
      bloc.add(const SimulatorTopicSelected(1));
      await expectLater(
        bloc.stream,
        emits(predicate<ArchitectureSimulatorState>((state) =>
            state.selectedTopicIndex == 1 &&
            state.currentStepIndex == 0 &&
            state.isPlaying == false)),
      );

      await bloc.close();
    });

    test('SimulatorStepSelected updates pipeline execution step', () async {
      final bloc = ArchitectureSimulatorBloc();

      bloc.add(const SimulatorStepSelected(2));
      await expectLater(
        bloc.stream,
        emits(predicate<ArchitectureSimulatorState>(
            (state) => state.currentStepIndex == 2)),
      );

      await bloc.close();
    });

    test(
        'SimulatorNextStepRequested and SimulatorPreviousStepRequested step through pipeline',
        () async {
      final bloc = ArchitectureSimulatorBloc();

      bloc.add(const SimulatorNextStepRequested());
      await expectLater(
        bloc.stream,
        emits(predicate<ArchitectureSimulatorState>(
            (state) => state.currentStepIndex == 1)),
      );

      bloc.add(const SimulatorNextStepRequested());
      await expectLater(
        bloc.stream,
        emits(predicate<ArchitectureSimulatorState>(
            (state) => state.currentStepIndex == 2)),
      );

      bloc.add(const SimulatorPreviousStepRequested());
      await expectLater(
        bloc.stream,
        emits(predicate<ArchitectureSimulatorState>(
            (state) => state.currentStepIndex == 1)),
      );

      await bloc.close();
    });

    test('SimulatorAutoPlayToggled activates and deactivates simulator loop',
        () async {
      final bloc = ArchitectureSimulatorBloc();

      bloc.add(const SimulatorAutoPlayToggled());
      await expectLater(
        bloc.stream,
        emits(predicate<ArchitectureSimulatorState>(
            (state) => state.isPlaying == true)),
      );

      bloc.add(const SimulatorAutoPlayToggled());
      await expectLater(
        bloc.stream,
        emits(predicate<ArchitectureSimulatorState>(
            (state) => state.isPlaying == false)),
      );

      await bloc.close();
    });

    test('SimulatorResetRequested resets step to 0 and pauses execution',
        () async {
      final bloc = ArchitectureSimulatorBloc();

      bloc.add(const SimulatorStepSelected(3));
      await expectLater(
        bloc.stream,
        emits(predicate<ArchitectureSimulatorState>(
            (state) => state.currentStepIndex == 3)),
      );

      bloc.add(const SimulatorResetRequested());
      await expectLater(
        bloc.stream,
        emits(predicate<ArchitectureSimulatorState>((state) =>
            state.currentStepIndex == 0 && state.isPlaying == false)),
      );

      await bloc.close();
    });
  });
}
