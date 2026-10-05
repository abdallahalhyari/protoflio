import 'package:equatable/equatable.dart';

class CaseStudyReaderState extends Equatable {
  final double progress;
  final bool showDock;
  final String? activeChapterId;

  const CaseStudyReaderState({
    this.progress = 0.0,
    this.showDock = false,
    this.activeChapterId,
  });

  CaseStudyReaderState copyWith({
    double? progress,
    bool? showDock,
    String? Function()? activeChapterId,
  }) {
    return CaseStudyReaderState(
      progress: progress ?? this.progress,
      showDock: showDock ?? this.showDock,
      activeChapterId:
          activeChapterId != null ? activeChapterId() : this.activeChapterId,
    );
  }

  @override
  List<Object?> get props => [progress, showDock, activeChapterId];
}
