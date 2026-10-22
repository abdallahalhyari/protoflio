import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/engineering/presentation/bloc/architecture_simulator_bloc.dart';
import 'package:profile/features/engineering/presentation/bloc/architecture_simulator_event.dart';
import 'package:profile/features/engineering/presentation/bloc/architecture_simulator_state.dart';
import 'package:profile/features/engineering/data/datasources/architecture_data.dart';

void main() {
  group('ArchitectureSimulatorBloc Test Suite', () {
    test('initial state defaults to the first architecture topic', () async {
      final bloc = ArchitectureSimulatorBloc();
      expect(bloc.state.topics.length, equals(kArchitectureTopics.length));
      expect(bloc.state.selectedTopicIndex, equals(0));
      expect(bloc.state.currentTopic.id, equals(kArchitectureTopics.first.id));
      await bloc.close();
    });

    test('SimulatorTopicSelected switches topic', () async {
      final bloc = ArchitectureSimulatorBloc();

      bloc.add(const SimulatorTopicSelected(1));
      await expectLater(
        bloc.stream,
        emits(predicate<ArchitectureSimulatorState>(
            (state) => state.selectedTopicIndex == 1)),
      );

      await bloc.close();
    });
  });
}
