import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/experience/bloc/experience_timeline_bloc.dart';
import 'package:profile/features/experience/data/experience_data.dart';

void main() {
  group('ExperienceTimelineBloc', () {
    late ExperienceTimelineBloc bloc;

    setUp(() {
      bloc = ExperienceTimelineBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state has default experiences and not visible', () {
      expect(bloc.state.isVisible, isFalse);
      expect(bloc.state.hoveredIndex, isNull);
      expect(bloc.state.selectedIndex, isNull);
      expect(bloc.state.experiences, equals(kExperience));
    });

    blocTest<ExperienceTimelineBloc, ExperienceTimelineState>(
      'emits updated visibility when ExperienceVisibilityChanged is added',
      build: () => ExperienceTimelineBloc(),
      act: (b) => b.add(const ExperienceVisibilityChanged(true)),
      expect: () => [
        const ExperienceTimelineState(isVisible: true),
      ],
    );

    blocTest<ExperienceTimelineBloc, ExperienceTimelineState>(
      'emits hoveredIndex when ExperienceNodeHovered is added',
      build: () => ExperienceTimelineBloc(),
      act: (b) {
        b.add(const ExperienceNodeHovered(1));
        b.add(const ExperienceNodeHovered(null));
      },
      expect: () => [
        const ExperienceTimelineState(hoveredIndex: 1),
        const ExperienceTimelineState(hoveredIndex: null),
      ],
    );

    blocTest<ExperienceTimelineBloc, ExperienceTimelineState>(
      'toggles selectedIndex when ExperienceNodeSelected is added',
      build: () => ExperienceTimelineBloc(),
      act: (b) {
        b.add(const ExperienceNodeSelected(0));
        b.add(const ExperienceNodeSelected(0)); // deselect
      },
      expect: () => [
        const ExperienceTimelineState(selectedIndex: 0),
        const ExperienceTimelineState(selectedIndex: null),
      ],
    );

    blocTest<ExperienceTimelineBloc, ExperienceTimelineState>(
      'navigates with keyboard direction events correctly',
      build: () => ExperienceTimelineBloc(),
      act: (b) {
        b.add(const ExperienceKeyboardNavigated(1)); // moves to 0
        b.add(const ExperienceKeyboardNavigated(1)); // moves to 1
        b.add(const ExperienceKeyboardNavigated(-1)); // moves to 0
      },
      expect: () => [
        const ExperienceTimelineState(selectedIndex: 0),
        const ExperienceTimelineState(selectedIndex: 1),
        const ExperienceTimelineState(selectedIndex: 0),
      ],
    );
  });
}
