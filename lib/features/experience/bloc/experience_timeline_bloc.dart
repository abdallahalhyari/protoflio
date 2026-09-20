import 'package:flutter_bloc/flutter_bloc.dart';
import 'experience_timeline_event.dart';
import 'experience_timeline_state.dart';

export 'experience_timeline_event.dart';
export 'experience_timeline_state.dart';

class ExperienceTimelineBloc
    extends Bloc<ExperienceTimelineEvent, ExperienceTimelineState> {
  ExperienceTimelineBloc({bool initialVisibility = false})
      : super(ExperienceTimelineState(isVisible: initialVisibility)) {
    on<ExperienceVisibilityChanged>(_onVisibilityChanged);
    on<ExperienceNodeHovered>(_onNodeHovered);
    on<ExperienceNodeSelected>(_onNodeSelected);
    on<ExperienceKeyboardNavigated>(_onKeyboardNavigated);
  }

  void _onVisibilityChanged(
    ExperienceVisibilityChanged event,
    Emitter<ExperienceTimelineState> emit,
  ) {
    if (state.isVisible != event.isVisible) {
      emit(state.copyWith(isVisible: event.isVisible));
    }
  }

  void _onNodeHovered(
    ExperienceNodeHovered event,
    Emitter<ExperienceTimelineState> emit,
  ) {
    if (state.hoveredIndex != event.index) {
      emit(state.copyWith(hoveredIndex: () => event.index));
    }
  }

  void _onNodeSelected(
    ExperienceNodeSelected event,
    Emitter<ExperienceTimelineState> emit,
  ) {
    final nextSelected =
        state.selectedIndex == event.index ? null : event.index;
    emit(state.copyWith(selectedIndex: () => nextSelected));
  }

  void _onKeyboardNavigated(
    ExperienceKeyboardNavigated event,
    Emitter<ExperienceTimelineState> emit,
  ) {
    final total = state.experiences.length;
    if (total == 0) return;

    final current = state.selectedIndex ?? (event.direction > 0 ? -1 : total);
    final next = (current + event.direction).clamp(0, total - 1);
    emit(state.copyWith(selectedIndex: () => next));
  }
}
