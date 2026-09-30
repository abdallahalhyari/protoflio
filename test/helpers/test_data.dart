import 'package:flutter/material.dart';
import 'package:profile/features/projects/domain/entities/project.dart';
import 'package:profile/features/experience/domain/entities/experience.dart';
import 'package:profile/features/skills/domain/entities/skill.dart';
import 'package:profile/features/hats/model/hat_info.dart';

import 'package:profile/features/projects/domain/repositories/project_repository.dart';
import 'package:profile/features/experience/domain/repositories/experience_repository.dart';
import 'package:profile/features/skills/domain/repositories/skill_repository.dart';
import 'package:profile/features/hats/domain/repositories/hat_repository.dart';
import 'package:profile/shared/util/career_facts.dart';

final List<Project> testProjects = [
  for (int i = 0; i < 4; i++)
    Project(
      name: 'Project $i',
      company: 'Test Company',
      tagline: 'Tagline $i',
      highlights: ['Highlight 1', 'Highlight 2'],
      stack: ['Flutter', 'Dart'],
      role: 'Mobile Engineer',
      problem: 'Problem $i',
      solution: 'Solution $i',
      results: ['Result 1'],
      technicalDecisions: ['Decision 1'],
      lessonsLearned: 'Lessons $i',
    )
];

final List<Experience> testExperience = [
  for (int i = 0; i < 4; i++)
    Experience(
      role: 'Role $i',
      company: 'Test Company $i',
      period: '2020-2021',
      highlights: ['Did things'],
    )
];

final List<Skill> testSkills = [
  for (int i = 0; i < 20; i++)
    Skill(
      name: 'Skill $i',
      icon: Icons.code,
      level: 0.9,
    )
];

final List<HatInfo> testHats = [
  for (int i = 0; i < 5; i++)
    HatInfo(
      title: 'Hat $i',
      heroTag: 'test_hat_$i',
      image: 'assets/images/hats/test.png',
      color: Colors.blue,
      titleDesc: 'Desc',
      desc: 'Description',
    )
];

class TestProjectRepository implements ProjectRepository {
  @override
  List<Project> getProjects() => testProjects;

  @override
  Project? getProjectByIndex(int index) => (index >= 0 && index < testProjects.length) ? testProjects[index] : null;

  @override
  int getProjectCount() => testProjects.length;
}

class TestExperienceRepository implements ExperienceRepository {
  @override
  List<Experience> getExperiences() => testExperience;

  @override
  List<Education> getEducation() => [
    for (int i = 0; i < 2; i++)
      Education(degree: 'Degree $i', institution: 'Inst', period: '2020')
  ];

  @override
  List<String> getCertifications() => [
    for (int i = 0; i < 5; i++) 'Cert $i'
  ];

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
