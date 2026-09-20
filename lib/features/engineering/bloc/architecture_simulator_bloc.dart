import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/features/engineering/data/architecture_data.dart';
import 'package:profile/features/engineering/model/architecture_topic.dart';
import 'architecture_simulator_event.dart';
import 'architecture_simulator_state.dart';

class ArchitectureSimulatorBloc
    extends Bloc<ArchitectureSimulatorEvent, ArchitectureSimulatorState> {
  Timer? _ticker;

  ArchitectureSimulatorBloc({List<ArchitectureTopic>? topics})
      : super(ArchitectureSimulatorState(
          topics: topics ?? kArchitectureTopics,
        )) {
    on<SimulatorTopicSelected>(_onTopicSelected);
    on<SimulatorStepSelected>(_onStepSelected);
    on<SimulatorNextStepRequested>(_onNextStepRequested);
    on<SimulatorPreviousStepRequested>(_onPreviousStepRequested);
    on<SimulatorAutoPlayToggled>(_onAutoPlayToggled);
    on<SimulatorResetRequested>(_onResetRequested);
    on<SimulatorTick>(_onTick);
  }

  void _onTopicSelected(
    SimulatorTopicSelected event,
    Emitter<ArchitectureSimulatorState> emit,
  ) {
    if (event.topicIndex == state.selectedTopicIndex) return;
    _stopTimer();
    final clamped = event.topicIndex.clamp(0, state.topics.length - 1);
    emit(state.copyWith(
      selectedTopicIndex: clamped,
      currentStepIndex: 0,
      isPlaying: false,
    ));
  }

  void _onStepSelected(
    SimulatorStepSelected event,
    Emitter<ArchitectureSimulatorState> emit,
  ) {
    _stopTimer();
    final clamped = event.stepIndex.clamp(0, state.totalSteps - 1);
    emit(state.copyWith(
      currentStepIndex: clamped,
      isPlaying: false,
    ));
  }

  void _onNextStepRequested(
    SimulatorNextStepRequested event,
    Emitter<ArchitectureSimulatorState> emit,
  ) {
    final nextIndex = (state.currentStepIndex + 1) % state.totalSteps;
    emit(state.copyWith(currentStepIndex: nextIndex));
  }

  void _onPreviousStepRequested(
    SimulatorPreviousStepRequested event,
    Emitter<ArchitectureSimulatorState> emit,
  ) {
    _stopTimer();
    final prevIndex =
        (state.currentStepIndex - 1 + state.totalSteps) % state.totalSteps;
    emit(state.copyWith(
      currentStepIndex: prevIndex,
      isPlaying: false,
    ));
  }

  void _onAutoPlayToggled(
    SimulatorAutoPlayToggled event,
    Emitter<ArchitectureSimulatorState> emit,
  ) {
    if (state.isPlaying) {
      _stopTimer();
      emit(state.copyWith(isPlaying: false));
    } else {
      _startTimer();
      emit(state.copyWith(isPlaying: true));
    }
  }

  void _onResetRequested(
    SimulatorResetRequested event,
    Emitter<ArchitectureSimulatorState> emit,
  ) {
    _stopTimer();
    emit(state.copyWith(
      currentStepIndex: 0,
      isPlaying: false,
    ));
  }

  void _onTick(
    SimulatorTick event,
    Emitter<ArchitectureSimulatorState> emit,
  ) {
    if (!state.isPlaying) return;
    final nextIndex = (state.currentStepIndex + 1) % state.totalSteps;
    emit(state.copyWith(currentStepIndex: nextIndex));
  }

  void _startTimer() {
    _stopTimer();
    _ticker = Timer.periodic(const Duration(milliseconds: 2200), (_) {
      add(const SimulatorTick());
    });
  }

  void _stopTimer() {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  Future<void> close() {
    _stopTimer();
    return super.close();
  }
}
