import 'package:profile/features/projects/domain/entities/project.dart';
import 'package:profile/features/experience/domain/entities/experience.dart';
import 'package:profile/features/skills/domain/entities/skill.dart';
import 'package:profile/features/hats/model/hat_info.dart';

import 'package:profile/features/projects/domain/repositories/project_repository.dart';
import 'package:profile/features/experience/domain/repositories/experience_repository.dart';
import 'package:profile/features/skills/domain/repositories/skill_repository.dart';
import 'package:profile/features/hats/domain/repositories/hat_repository.dart';
import 'package:profile/shared/util/career_facts.dart';

import 'real_data.dart';

// The real shipped data (assets/data/*.json). Tests assert on real titles,
// counts, company links and hero images, so placeholders here made them
// test a different portfolio than the one users see.
final List<Project> testProjects = RealProjectRepository().getProjects();
final List<Experience> testExperience =
    RealExperienceRepository().getExperiences();
final List<Skill> testSkills = RealSkillRepository().getSkills();
final List<HatInfo> testHats = RealHatRepository().getHats();

class TestProjectRepository implements ProjectRepository {
  @override
  List<Project> getProjects() => testProjects;

  @override
  Project? getProjectByIndex(int index) =>
      (index >= 0 && index < testProjects.length) ? testProjects[index] : null;

  @override
  int getProjectCount() => testProjects.length;
}

class TestExperienceRepository implements ExperienceRepository {
  @override
  List<Experience> getExperiences() => testExperience;

  @override
  List<Education> getEducation() => RealExperienceRepository().getEducation();

  @override
  List<String> getCertifications() =>
      RealExperienceRepository().getCertifications();

  @override
  int getYearsOfExperience() => CareerFacts.yearsOfExperience();
}

class TestSkillRepository implements SkillRepository {
  @override
  List<Skill> getSkills() => testSkills;

  @override
  int getSkillCount() => testSkills.length;
}

class TestHatRepository implements HatRepository {
  @override
  List<HatInfo> getHats() => testHats;

  @override
  int getHatCount() => testHats.length;
}
