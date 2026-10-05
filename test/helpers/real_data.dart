import 'dart:convert';
import 'dart:io';

import 'package:profile/features/experience/data/models/education_model.dart';
import 'package:profile/features/experience/data/models/experience_model.dart';
import 'package:profile/features/experience/domain/entities/experience.dart';
import 'package:profile/features/experience/domain/repositories/experience_repository.dart';
import 'package:profile/features/hats/data/models/hat_info_model.dart';
import 'package:profile/features/hats/domain/repositories/hat_repository.dart';
import 'package:profile/features/hats/domain/entities/hat_info.dart';
import 'package:profile/features/projects/data/models/project_model.dart';
import 'package:profile/features/projects/domain/entities/project.dart';
import 'package:profile/features/projects/domain/repositories/project_repository.dart';
import 'package:profile/features/skills/data/models/skill_model.dart';
import 'package:profile/features/skills/domain/entities/skill.dart';
import 'package:profile/features/skills/domain/repositories/skill_repository.dart';
import 'package:profile/shared/utils/career_facts.dart';

/// Repositories backed by the real `assets/data/*.json`, read synchronously
/// so widget tests see the content the site ships (titles, counts, company
/// links, hero images) instead of placeholders.
List<dynamic> _json(String name) =>
    jsonDecode(File('assets/data/$name.json').readAsStringSync())
        as List<dynamic>;

class RealProjectRepository implements ProjectRepository {
  final List<Project> _items = _json('projects')
      .map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
      .toList();
  @override
  List<Project> getProjects() => _items;
  @override
  Project? getProjectByIndex(int index) =>
      index >= 0 && index < _items.length ? _items[index] : null;
  @override
  int getProjectCount() => _items.length;
}

class RealExperienceRepository implements ExperienceRepository {
  final List<Experience> _exp = _json('experience')
      .map((e) => ExperienceModel.fromJson(e as Map<String, dynamic>))
      .toList();
  final List<Education> _edu = _json('education')
      .map((e) => EducationModel.fromJson(e as Map<String, dynamic>))
      .toList();
  final List<String> _certs =
      _json('certifications').map((e) => e as String).toList();
  @override
  List<Experience> getExperiences() => _exp;
  @override
  List<Education> getEducation() => _edu;
  @override
  List<String> getCertifications() => _certs;
  @override
  int getYearsOfExperience() => CareerFacts.yearsOfExperience();
}

class RealSkillRepository implements SkillRepository {
  final List<Skill> _items = _json('skills')
      .map((e) => SkillModel.fromJson(e as Map<String, dynamic>))
      .toList();
  @override
  List<Skill> getSkills() => _items;
  @override
  int getSkillCount() => _items.length;
}

class RealHatRepository implements HatRepository {
  final List<HatInfo> _items = _json('hats')
      .map((e) => HatInfoModel.fromJson(e as Map<String, dynamic>))
      .toList();
  @override
  List<HatInfo> getHats() => _items;
  @override
  int getHatCount() => _items.length;
}
