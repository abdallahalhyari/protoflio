import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/case_study/bloc/case_study_reader_bloc.dart';

void main() {
  group('CaseStudyReaderBloc', () {
    late CaseStudyReaderBloc bloc;

    setUp(() {
      bloc = CaseStudyReaderBloc(initialChapterId: 'overview');
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state sets initial active chapter and default progress', () {
      expect(bloc.state.progress, 0.0);
      expect(bloc.state.showDock, isFalse);
      expect(bloc.state.activeChapterId, 'overview');
      expect(bloc.state.isCompleted, isFalse);
    });

    blocTest<CaseStudyReaderBloc, CaseStudyReaderState>(
      'updates progress, dock visibility, and completion flag',
      build: () => CaseStudyReaderBloc(),
      act: (b) {
        b.add(const CaseStudyScrollProgressUpdated(
            progress: 0.5, showDock: true));
        b.add(const CaseStudyScrollProgressUpdated(
            progress: 0.98, showDock: true));
      },
      expect: () => [
        const CaseStudyReaderState(
            progress: 0.5, showDock: true, isCompleted: false),
        const CaseStudyReaderState(
            progress: 0.98, showDock: true, isCompleted: true),
      ],
    );

    blocTest<CaseStudyReaderBloc, CaseStudyReaderState>(
      'updates active chapter when new chapter is detected or jump requested',
      build: () => CaseStudyReaderBloc(initialChapterId: 'ch1'),
      act: (b) {
        b.add(const CaseStudyChapterDetected('ch2'));
        b.add(const CaseStudyChapterJumpRequested('ch3'));
      },
      expect: () => [
        const CaseStudyReaderState(activeChapterId: 'ch2'),
        const CaseStudyReaderState(activeChapterId: 'ch3'),
      ],
    );

    blocTest<CaseStudyReaderBloc, CaseStudyReaderState>(
      'resets progress and dock on back to top requested',
      build: () => CaseStudyReaderBloc(),
      seed: () => const CaseStudyReaderState(progress: 0.8, showDock: true),
      act: (b) => b.add(const CaseStudyBackToTopRequested()),
      expect: () => [
        const CaseStudyReaderState(progress: 0.0, showDock: false),
      ],
    );
  });
}
