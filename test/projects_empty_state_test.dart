import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/theme/app_theme.dart';
import 'package:profile/features/projects/presentation/widgets/projects_empty_state.dart';
import 'package:profile/features/projects/presentation/bloc/projects_filter_bloc.dart';
import 'package:profile/features/projects/domain/repositories/project_repository.dart';
import 'helpers/test_data.dart';
import 'package:profile/l10n/app_localizations.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.dark(),
    home: RepositoryProvider<ProjectRepository>(
      create: (_) => TestProjectRepository(),
      child: BlocProvider<ProjectsFilterBloc>(
        create: (context) =>
            ProjectsFilterBloc(repository: context.read<ProjectRepository>()),
        child: Scaffold(body: child),
      ),
    ),
  );
}

void main() {
  group('ProjectsEmptyState Test Suite', () {
    testWidgets('Renders all text and buttons', (tester) async {
      await tester.pumpWidget(_wrap(
        ProjectsEmptyState(
          scheme: AppTheme.dark().colorScheme,
          isDesktop: true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('NO CASE STUDIES MATCHED'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.text('RESET FILTERS'), findsOneWidget);
    });

    testWidgets('Tapping Reset button resets filters in BLoC', (tester) async {
      await tester.pumpWidget(_wrap(
        ProjectsEmptyState(
          scheme: AppTheme.dark().colorScheme,
          isDesktop: true,
        ),
      ));
      await tester.pumpAndSettle();

      // Retrieve the bloc from the context
      final BuildContext context =
          tester.element(find.byType(ProjectsEmptyState));
      final bloc = context.read<ProjectsFilterBloc>();

      // We assume it's initially with no filters if no event was fired.
      // So tapping reset should fire ProjectsFilterReset.
      await tester.tap(find.text('RESET FILTERS'));
      await tester.pumpAndSettle();

      // Since it resets, selectedDomain should be 'ALL' and activeTechFilters should be empty.
      expect(bloc.state.selectedDomain, equals('ALL'));
      expect(bloc.state.selectedTech, isNull);
    });
  });
}
