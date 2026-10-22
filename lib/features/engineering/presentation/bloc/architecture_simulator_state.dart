import 'package:equatable/equatable.dart';
import 'package:profile/features/engineering/domain/entities/architecture_topic.dart';

class ArchitectureSimulatorState extends Equatable {
  final List<ArchitectureTopic> topics;
  final int selectedTopicIndex;

  const ArchitectureSimulatorState({
    required this.topics,
    this.selectedTopicIndex = 0,
  });

  ArchitectureTopic get currentTopic => topics[selectedTopicIndex];

  ArchitectureSimulatorState copyWith({
    List<ArchitectureTopic>? topics,
    int? selectedTopicIndex,
  }) {
    return ArchitectureSimulatorState(
      topics: topics ?? this.topics,
      selectedTopicIndex: selectedTopicIndex ?? this.selectedTopicIndex,
    );
  }

  @override
  List<Object?> get props => [
        topics,
        selectedTopicIndex,
      ];
}
