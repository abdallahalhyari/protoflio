import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_data.dart';
import 'package:profile/features/experience/presentation/bloc/experience_timeline_bloc.dart';



void main() {
  group('ExperienceTimelineBloc', () {
    late ExperienceTimelineBloc bloc;

    setUp(() {
      bloc = ExperienceTimelineBloc(repository: TestExperienceRepository());
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state has default experiences and not visible', () {
      expect(bloc.state.isVisible, isFalse);
      expect(bloc.state.hoveredIndex, isNull);
      expect(bloc.state.selectedIndex, isNull);
      expect(bloc.state.experiences, equals(testExperience));
    });

    blocTest<ExperienceTimelineBloc, ExperienceTimelineState>(
      'emits updated visibility when ExperienceVisibilityChanged is added',
      build: () => ExperienceTimelineBloc(repository: TestExperienceRepository()),
      act: (b) => b.add(const ExperienceVisibilityChanged(true)),
      expect: () => [
        const ExperienceTimelineState(isVisible: true, experiences: testExperience),
      ],
    );

    blocTest<ExperienceTimelineBloc, ExperienceTimelineState>(
      'emits hoveredIndex when ExperienceNodeHovered is added',
      build: () => ExperienceTimelineBloc(repository: TestExperienceRepository()),
      act: (b) {
        b.add(const ExperienceNodeHovered(1));
        b.add(const ExperienceNodeHovered(null));
      },
      expect: () => [
        const ExperienceTimelineState(hoveredIndex: 1, experiences: testExperience),
        const ExperienceTimelineState(experiences: testExperience),
      ],
    );

    blocTest<ExperienceTimelineBloc, ExperienceTimelineState>(
      'toggles selectedIndex when ExperienceNodeSelected is added',
      build: () => ExperienceTimelineBloc(repository: TestExperienceRepository()),
      act: (b) {
        b.add(const ExperienceNodeSelected(0));
        b.add(const ExperienceNodeSelected(0)); // deselect
      },
      expect: () => [
        const ExperienceTimelineState(selectedIndex: 0, experiences: testExperience),
        const ExperienceTimelineState(experiences: testExperience),
      ],
    );

    blocTest<ExperienceTimelineBloc, ExperienceTimelineState>(
      'navigates with keyboard direction events correctly',
      build: () => ExperienceTimelineBloc(repository: TestExperienceRepository()),
      act: (b) {
        b.add(const ExperienceKeyboardNavigated(1)); // moves to 0
        b.add(const ExperienceKeyboardNavigated(1)); // moves to 1
        b.add(const ExperienceKeyboardNavigated(-1)); // moves to 0
      },
      expect: () => [
        const ExperienceTimelineState(selectedIndex: 0, experiences: testExperience),
        const ExperienceTimelineState(selectedIndex: 1, experiences: testExperience),
        const ExperienceTimelineState(selectedIndex: 0, experiences: testExperience),
      ],
    );
  });
}
