import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/core/usecases/usecase.dart';
import 'package:profile/features/engineering/data/repositories/architecture_repository_impl.dart';
import 'package:profile/features/engineering/domain/entities/architecture_topic.dart';
import 'package:profile/features/engineering/domain/repositories/architecture_repository.dart';
import 'package:profile/features/engineering/domain/usecases/get_architecture_topics_usecase.dart';
import 'package:profile/features/engineering/presentation/bloc/architecture_simulator_event.dart';
import 'package:profile/features/engineering/presentation/bloc/architecture_simulator_state.dart';

class ArchitectureSimulatorBloc
    extends Bloc<ArchitectureSimulatorEvent, ArchitectureSimulatorState> {
  ArchitectureSimulatorBloc({
    List<ArchitectureTopic>? topics,
    ArchitectureRepository? repository,
  }) : super(ArchitectureSimulatorState(
          topics: topics ??
              (repository ?? const ArchitectureRepositoryImpl())
                  .getArchitectureTopics(),
        )) {
    _registerHandlers();
  }

  ArchitectureSimulatorBloc.withUseCase({
    required GetArchitectureTopicsUseCase getTopicsUseCase,
  }) : super(ArchitectureSimulatorState(
          topics: getTopicsUseCase(const NoParams()),
        )) {
    _registerHandlers();
  }

  void _registerHandlers() {
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
