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
    });

    blocTest<CaseStudyReaderBloc, CaseStudyReaderState>(
      'updates progress and dock visibility',
      build: CaseStudyReaderBloc.new,
      act: (b) {
        b.add(const CaseStudyScrollProgressUpdated(
            progress: 0.5, showDock: true));
        b.add(const CaseStudyScrollProgressUpdated(
            progress: 0.98, showDock: true));
      },
      expect: () => [
        const CaseStudyReaderState(progress: 0.5, showDock: true),
        const CaseStudyReaderState(progress: 0.98, showDock: true),
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
      build: CaseStudyReaderBloc.new,
      seed: () => const CaseStudyReaderState(progress: 0.8, showDock: true),
      act: (b) => b.add(const CaseStudyBackToTopRequested()),
      expect: () => [
        const CaseStudyReaderState(),
      ],
    );
  });
}
