import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/features/engineering/data/architecture_data.dart';
import 'package:profile/features/engineering/model/architecture_topic.dart';
import 'architecture_simulator_event.dart';
import 'architecture_simulator_state.dart';

class ArchitectureSimulatorBloc
    extends Bloc<ArchitectureSimulatorEvent, ArchitectureSimulatorState> {
  ArchitectureSimulatorBloc({List<ArchitectureTopic>? topics})
      : super(ArchitectureSimulatorState(
          topics: topics ?? kArchitectureTopics,
        )) {
    on<SimulatorTopicSelected>(_onTopicSelected);
    on<SimulatorStepSelected>(_onStepSelected);
  }

  void _onTopicSelected(
    SimulatorTopicSelected event,
    Emitter<ArchitectureSimulatorState> emit,
  ) {
    if (event.topicIndex == state.selectedTopicIndex) return;
    final clamped = event.topicIndex.clamp(0, state.topics.length - 1);
    emit(state.copyWith(
      selectedTopicIndex: clamped,
      currentStepIndex: 0,
    ));
  }

  void _onStepSelected(
    SimulatorStepSelected event,
    Emitter<ArchitectureSimulatorState> emit,
  ) {
    final clamped = event.stepIndex.clamp(0, state.totalSteps - 1);
    emit(state.copyWith(
      currentStepIndex: clamped,
    ));
  }
}
