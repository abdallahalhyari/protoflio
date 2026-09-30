import 'package:equatable/equatable.dart';

abstract class ExperienceTimelineEvent extends Equatable {
  const ExperienceTimelineEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when the section enters viewport.
class ExperienceVisibilityChanged extends ExperienceTimelineEvent {
  final bool isVisible;

  const ExperienceVisibilityChanged(this.isVisible);

  @override
  List<Object?> get props => [isVisible];
}

/// Triggered when the cursor hovers over an experience node.
class ExperienceNodeHovered extends ExperienceTimelineEvent {
  final int? index;

  const ExperienceNodeHovered(this.index);

  @override
  List<Object?> get props => [index];
}

/// Triggered when an experience node is clicked or expanded.
class ExperienceNodeSelected extends ExperienceTimelineEvent {
  final int? index;

  const ExperienceNodeSelected(this.index);

  @override
  List<Object?> get props => [index];
}

/// Triggered by keyboard shortcuts (Arrow keys) to cycle nodes.
class ExperienceKeyboardNavigated extends ExperienceTimelineEvent {
  final int direction; // -1 for previous, +1 for next

  const ExperienceKeyboardNavigated(this.direction);

  @override
  List<Object?> get props => [direction];
}
