import 'package:equatable/equatable.dart';

class CaseStudyReaderState extends Equatable {
  final double progress;
  final bool showDock;
  final String? activeChapterId;
  final bool isCompleted;

  const CaseStudyReaderState({
    this.progress = 0.0,
    this.showDock = false,
    this.activeChapterId,
    this.isCompleted = false,
  });

  CaseStudyReaderState copyWith({
    double? progress,
    bool? showDock,
    String? Function()? activeChapterId,
    bool? isCompleted,
  }) {
    return CaseStudyReaderState(
      progress: progress ?? this.progress,
      showDock: showDock ?? this.showDock,
      activeChapterId:
          activeChapterId != null ? activeChapterId() : this.activeChapterId,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [progress, showDock, activeChapterId, isCompleted];
}
