import 'package:equatable/equatable.dart';

sealed class ArchitectureSimulatorEvent extends Equatable {
  const ArchitectureSimulatorEvent();

  @override
  List<Object?> get props => [];
}

class SimulatorTopicSelected extends ArchitectureSimulatorEvent {
  final int topicIndex;

  const SimulatorTopicSelected(this.topicIndex);

  @override
  List<Object?> get props => [topicIndex];
}
