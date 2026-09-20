import 'package:flutter_bloc/flutter_bloc.dart';
import 'case_study_reader_event.dart';
import 'case_study_reader_state.dart';

export 'case_study_reader_event.dart';
export 'case_study_reader_state.dart';

class CaseStudyReaderBloc
    extends Bloc<CaseStudyReaderEvent, CaseStudyReaderState> {
  CaseStudyReaderBloc({String? initialChapterId})
      : super(CaseStudyReaderState(activeChapterId: initialChapterId)) {
    on<CaseStudyScrollProgressUpdated>(_onScrollProgressUpdated);
    on<CaseStudyChapterDetected>(_onChapterDetected);
    on<CaseStudyChapterJumpRequested>(_onChapterJumpRequested);
    on<CaseStudyBackToTopRequested>(_onBackToTopRequested);
  }

  void _onScrollProgressUpdated(
    CaseStudyScrollProgressUpdated event,
    Emitter<CaseStudyReaderState> emit,
  ) {
    final isCompleted = state.isCompleted || event.progress >= 0.95;
    emit(state.copyWith(
      progress: event.progress,
      showDock: event.showDock,
      isCompleted: isCompleted,
    ));
  }

  void _onChapterDetected(
    CaseStudyChapterDetected event,
    Emitter<CaseStudyReaderState> emit,
  ) {
    if (state.activeChapterId != event.chapterId) {
      emit(state.copyWith(activeChapterId: () => event.chapterId));
    }
  }

  void _onChapterJumpRequested(
    CaseStudyChapterJumpRequested event,
    Emitter<CaseStudyReaderState> emit,
  ) {
    emit(state.copyWith(activeChapterId: () => event.chapterId));
  }

  void _onBackToTopRequested(
    CaseStudyBackToTopRequested event,
    Emitter<CaseStudyReaderState> emit,
  ) {
    emit(state.copyWith(
      progress: 0.0,
      showDock: false,
    ));
  }
}
