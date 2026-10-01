import 'package:equatable/equatable.dart';
import 'package:profile/features/experience/domain/entities/experience.dart';

class ExperienceTimelineState extends Equatable {
  final bool isVisible;
  final int? selectedIndex;
  final List<Experience> experiences;

  const ExperienceTimelineState({
    this.isVisible = false,
    this.selectedIndex,
    this.experiences = const [],
  });

  ExperienceTimelineState copyWith({
    bool? isVisible,
    int? Function()? selectedIndex,
    List<Experience>? experiences,
  }) {
    return ExperienceTimelineState(
      isVisible: isVisible ?? this.isVisible,
      selectedIndex:
          selectedIndex != null ? selectedIndex() : this.selectedIndex,
      experiences: experiences ?? this.experiences,
    );
  }

  @override
  List<Object?> get props => [isVisible, selectedIndex, experiences];
}
