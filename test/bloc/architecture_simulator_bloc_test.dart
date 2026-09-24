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
      expect(bloc.state.currentTopic.id, equals(kArchitectureTopics.first.id));
      await bloc.close();
    });

    test('SimulatorTopicSelected switches topic and resets active step to 0',
        () async {
      final bloc = ArchitectureSimulatorBloc();

      bloc.add(const SimulatorTopicSelected(1));
      await expectLater(
        bloc.stream,
        emits(predicate<ArchitectureSimulatorState>((state) =>
            state.selectedTopicIndex == 1 &&
            state.currentStepIndex == 0)),
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
  });
}
