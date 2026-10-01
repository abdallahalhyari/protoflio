import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/experience/domain/repositories/experience_repository.dart';
import 'package:profile/features/hats/domain/repositories/hat_repository.dart';
import 'package:profile/features/projects/domain/repositories/project_repository.dart';
import 'package:profile/features/skills/domain/repositories/skill_repository.dart';

import 'helpers/real_data.dart';

/// Every widget test gets the real portfolio repositories above whatever it
/// pumps, the way `main.dart` provides them above MaterialApp. A test that
/// wraps its own RepositoryProvider overrides these (nearest provider wins).
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  _RepositoryTestBinding();
  await testMain();
}

class _RepositoryTestBinding extends AutomatedTestWidgetsFlutterBinding {
  final _projects = RealProjectRepository();
  final _experience = RealExperienceRepository();
  final _skills = RealSkillRepository();
  final _hats = RealHatRepository();

  @override
  Widget wrapWithDefaultView(Widget rootWidget) => super.wrapWithDefaultView(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<ProjectRepository>.value(value: _projects),
            RepositoryProvider<ExperienceRepository>.value(value: _experience),
            RepositoryProvider<SkillRepository>.value(value: _skills),
            RepositoryProvider<HatRepository>.value(value: _hats),
          ],
          child: rootWidget,
        ),
      );
}
