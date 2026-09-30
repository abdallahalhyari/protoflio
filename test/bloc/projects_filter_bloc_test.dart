import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_data.dart';
import 'package:profile/features/projects/presentation/bloc/projects_filter_bloc.dart';
import 'package:profile/features/projects/presentation/bloc/projects_filter_event.dart';
import 'package:profile/features/projects/presentation/bloc/projects_filter_state.dart';



void main() {
  group('ProjectsFilterBloc Test Suite', () {
    test(
        'initial state contains all portfolio projects with ALL domain selected',
        () async {
      final bloc = ProjectsFilterBloc(repository: TestProjectRepository());
      expect(bloc.state.allProjects.length, equals(testProjects.length));
      expect(bloc.state.filteredProjects.length, equals(testProjects.length));
      expect(bloc.state.selectedDomain, equals('ALL'));
      expect(bloc.state.selectedTech, isNull);
      expect(bloc.state.hasActiveFilters, isFalse);
      expect(bloc.state.domainCounts['ALL'], equals(testProjects.length));
      await bloc.close();
    });

    test('DomainFilterSelected narrows projects to chosen enterprise domain',
        () async {
      final bloc = ProjectsFilterBloc(repository: TestProjectRepository());

      bloc.add(const DomainFilterSelected('Healthcare & Smart Cards'));
      await expectLater(
        bloc.stream,
        emits(predicate<ProjectsFilterState>((state) =>
            state.selectedDomain == 'Healthcare & Smart Cards' &&
            state.hasActiveFilters &&
            state.filteredProjects
                .every((p) => p.domain == 'Healthcare & Smart Cards'))),
      );

      await bloc.close();
    });

    test('TechFilterToggled filters projects and toggles off on secondary tap',
        () async {
      final bloc = ProjectsFilterBloc(repository: TestProjectRepository());

      // Toggle 'Flutter'
      bloc.add(const TechFilterToggled('Flutter'));
      await expectLater(
        bloc.stream,
        emits(predicate<ProjectsFilterState>((state) =>
            state.selectedTech == 'Flutter' &&
            state.filteredProjects.every((p) => p.stack.contains('Flutter')))),
      );

      // Toggle 'Flutter' again should deactivate filter
      bloc.add(const TechFilterToggled('Flutter'));
      await expectLater(
        bloc.stream,
        emits(predicate<ProjectsFilterState>((state) =>
            state.selectedTech == null &&
            state.filteredProjects.length == testProjects.length)),
      );

      await bloc.close();
    });

    test('ProjectsFilterReset clears all active domain and technology filters',
        () async {
      final bloc = ProjectsFilterBloc(repository: TestProjectRepository());

      bloc.add(const DomainFilterSelected('Fleet & Telematics'));
      await expectLater(
        bloc.stream,
        emits(predicate<ProjectsFilterState>(
            (state) => state.selectedDomain == 'Fleet & Telematics')),
      );

      bloc.add(const ProjectsFilterReset());
      await expectLater(
        bloc.stream,
        emits(predicate<ProjectsFilterState>((state) =>
            state.selectedDomain == 'ALL' &&
            state.selectedTech == null &&
            state.filteredProjects.length == testProjects.length)),
      );

      await bloc.close();
    });
  });
}
