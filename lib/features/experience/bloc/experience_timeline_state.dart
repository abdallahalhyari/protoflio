import 'package:equatable/equatable.dart';
import '../model/experience.dart';
import '../data/experience_data.dart';

class ExperienceTimelineState extends Equatable {
  final bool isVisible;
  final int? hoveredIndex;
  final int? selectedIndex;
  final List<Experience> experiences;

  const ExperienceTimelineState({
    this.isVisible = false,
    this.hoveredIndex,
    this.selectedIndex,
    this.experiences = kExperience,
  });

  ExperienceTimelineState copyWith({
    bool? isVisible,
    int? Function()? hoveredIndex,
    int? Function()? selectedIndex,
    List<Experience>? experiences,
  }) {
    return ExperienceTimelineState(
      isVisible: isVisible ?? this.isVisible,
      hoveredIndex: hoveredIndex != null ? hoveredIndex() : this.hoveredIndex,
      selectedIndex: selectedIndex != null ? selectedIndex() : this.selectedIndex,
      experiences: experiences ?? this.experiences,
    );
  }

  @override
  List<Object?> get props => [isVisible, hoveredIndex, selectedIndex, experiences];
}
