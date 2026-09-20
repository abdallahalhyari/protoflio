import 'package:equatable/equatable.dart';

abstract class CaseStudyReaderEvent extends Equatable {
  const CaseStudyReaderEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when the case study scroll offset changes.
class CaseStudyScrollProgressUpdated extends CaseStudyReaderEvent {
  final double progress;
  final bool showDock;

  const CaseStudyScrollProgressUpdated({
    required this.progress,
    required this.showDock,
  });

  @override
  List<Object?> get props => [progress, showDock];
}

/// Triggered when the viewport crosses into a new chapter.
class CaseStudyChapterDetected extends CaseStudyReaderEvent {
  final String chapterId;

  const CaseStudyChapterDetected(this.chapterId);

  @override
  List<Object?> get props => [chapterId];
}

/// Triggered when the reader clicks a chapter navigation chip.
class CaseStudyChapterJumpRequested extends CaseStudyReaderEvent {
  final String chapterId;

  const CaseStudyChapterJumpRequested(this.chapterId);

  @override
  List<Object?> get props => [chapterId];
}

/// Triggered when the reader taps "Back to Top".
class CaseStudyBackToTopRequested extends CaseStudyReaderEvent {
  const CaseStudyBackToTopRequested();
}
