import 'package:equatable/equatable.dart';
import 'package:profile/features/engineering/model/architecture_topic.dart';

class ArchitectureSimulatorState extends Equatable {
  final List<ArchitectureTopic> topics;
  final int selectedTopicIndex;
  final int currentStepIndex;

  const ArchitectureSimulatorState({
    required this.topics,
    this.selectedTopicIndex = 0,
    this.currentStepIndex = 0,
  });

  ArchitectureTopic get currentTopic => topics[selectedTopicIndex];
  int get totalSteps => currentTopic.diagramSteps.length;
  DiagramStep get currentStep =>
      currentTopic.diagramSteps[currentStepIndex.clamp(0, totalSteps - 1)];

  ArchitectureSimulatorState copyWith({
    List<ArchitectureTopic>? topics,
    int? selectedTopicIndex,
    int? currentStepIndex,
  }) {
    return ArchitectureSimulatorState(
      topics: topics ?? this.topics,
      selectedTopicIndex: selectedTopicIndex ?? this.selectedTopicIndex,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
    );
  }

  @override
  List<Object?> get props => [
        topics,
        selectedTopicIndex,
        currentStepIndex,
      ];
}
