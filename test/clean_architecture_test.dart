import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/di/injection.dart';
import 'package:profile/core/usecases/usecase.dart';
import 'package:profile/features/contact/domain/repositories/contact_repository.dart';
import 'package:profile/features/contact/domain/usecases/format_inquiry_message_usecase.dart';
import 'package:profile/features/contact/domain/usecases/get_inquiry_tracks_usecase.dart';
import 'package:profile/features/engineering/domain/repositories/architecture_repository.dart';
import 'package:profile/features/engineering/domain/usecases/get_architecture_topics_usecase.dart';
import 'package:profile/features/experience/domain/repositories/experience_repository.dart';
import 'package:profile/features/experience/domain/usecases/get_career_facts_usecase.dart';
import 'package:profile/features/experience/domain/usecases/get_education_usecase.dart';
import 'package:profile/features/experience/domain/usecases/get_experiences_usecase.dart';
import 'package:profile/features/hats/domain/repositories/hat_repository.dart';
import 'package:profile/features/hats/domain/usecases/get_hats_usecase.dart';
import 'package:profile/features/projects/domain/repositories/project_repository.dart';
import 'package:profile/features/projects/domain/usecases/filter_projects_usecase.dart';
import 'package:profile/features/projects/domain/usecases/get_projects_usecase.dart';
import 'package:profile/features/skills/domain/repositories/skill_repository.dart';
import 'package:profile/features/skills/domain/usecases/filter_skills_usecase.dart';
import 'package:profile/features/skills/domain/usecases/get_skills_usecase.dart';

import 'helpers/real_data.dart';

void main() {
  group('Clean Architecture - ServiceLocator & DI', () {
    setUp(() {
      ServiceLocator.instance.reset();
      ServiceLocator.instance.setup();
    });

    test('registers all repositories and use cases', () {
      expect(ServiceLocator.instance.isRegistered<ProjectRepository>(), isTrue);
      expect(
          ServiceLocator.instance.isRegistered<ExperienceRepository>(), isTrue);
      expect(ServiceLocator.instance.isRegistered<SkillRepository>(), isTrue);
      expect(ServiceLocator.instance.isRegistered<HatRepository>(), isTrue);
      expect(ServiceLocator.instance.isRegistered<ArchitectureRepository>(),
          isTrue);
      expect(ServiceLocator.instance.isRegistered<ContactRepository>(), isTrue);

      expect(
          ServiceLocator.instance.isRegistered<GetProjectsUseCase>(), isTrue);
      expect(ServiceLocator.instance.isRegistered<FilterProjectsUseCase>(),
          isTrue);
      expect(ServiceLocator.instance.isRegistered<GetSkillsUseCase>(), isTrue);
      expect(
          ServiceLocator.instance.isRegistered<FilterSkillsUseCase>(), isTrue);
      expect(ServiceLocator.instance.isRegistered<GetExperiencesUseCase>(),
          isTrue);
      expect(
          ServiceLocator.instance.isRegistered<GetEducationUseCase>(), isTrue);
      expect(ServiceLocator.instance.isRegistered<GetCareerFactsUseCase>(),
          isTrue);
      expect(ServiceLocator.instance.isRegistered<GetHatsUseCase>(), isTrue);
      expect(
          ServiceLocator.instance.isRegistered<GetArchitectureTopicsUseCase>(),
          isTrue);
      expect(ServiceLocator.instance.isRegistered<GetInquiryTracksUseCase>(),
          isTrue);
      expect(
          ServiceLocator.instance.isRegistered<FormatInquiryMessageUseCase>(),
          isTrue);
    });
  });

  group('Clean Architecture - Projects Domain UseCases', () {
    final realProjects = RealProjectRepository().getProjects();

    test('FilterProjectsUseCase filters by domain', () {
      const useCase = FilterProjectsUseCase();
      final filtered = useCase(FilterProjectsParams(
        allProjects: realProjects,
        domain: realProjects.first.domain,
      ));
      expect(
          filtered.every((p) => p.domain == realProjects.first.domain), isTrue);
    });

    test('FilterProjectsUseCase filters by tech stack', () {
      const useCase = FilterProjectsUseCase();
      const tech = 'Flutter';
      final filtered = useCase(FilterProjectsParams(
        allProjects: realProjects,
        domain: 'ALL',
        tech: tech,
      ));
      expect(filtered.every((p) => p.stack.contains(tech)), isTrue);
    });

    test('FilterProjectsUseCase computes domain counts accurately', () {
      const useCase = FilterProjectsUseCase();
      final counts = useCase.computeDomainCounts(realProjects);
      expect(counts['ALL'], realProjects.length);
      expect(counts.values.reduce((a, b) => a + b), realProjects.length * 2);
    });

    test('GetProjectsUseCase retrieves projects from repository', () {
      final repo = RealProjectRepository();
      final useCase = GetProjectsUseCase(repo);
      final result = useCase(const NoParams());
      expect(result.length, repo.getProjects().length);
    });
  });

  group('Clean Architecture - Skills Domain UseCases', () {
    final realSkills = RealSkillRepository().getSkills();

    test('FilterSkillsUseCase filters by category', () {
      const useCase = FilterSkillsUseCase();
      final firstCategory = realSkills.first.category;
      final filtered = useCase(FilterSkillsParams(
        allSkills: realSkills,
        category: firstCategory,
        query: '',
      ));
      expect(filtered.every((s) => s.category == firstCategory), isTrue);
    });

    test('FilterSkillsUseCase handles recruiter multi-word search queries', () {
      const useCase = FilterSkillsUseCase();
      final filtered = useCase(FilterSkillsParams(
        allSkills: realSkills,
        category: 'ALL',
        query: 'flutter architecture',
      ));
      for (final skill in filtered) {
        final haystack = [
          skill.name,
          skill.category,
          skill.description,
          skill.provenIn,
          ...skill.tags,
        ].join(' ').toLowerCase();
        expect(haystack.contains('flutter'), isTrue);
        expect(haystack.contains('architecture'), isTrue);
      }
    });

    test('GetSkillsUseCase retrieves skills from repository', () {
      final repo = RealSkillRepository();
      final useCase = GetSkillsUseCase(repo);
      final result = useCase(const NoParams());
      expect(result.length, repo.getSkills().length);
    });
  });

  group('Clean Architecture - Experience & Hats UseCases', () {
    test(
        'GetExperiencesUseCase, GetEducationUseCase, GetCareerFactsUseCase execute cleanly',
        () {
      final repo = RealExperienceRepository();
      final expUseCase = GetExperiencesUseCase(repo);
      final eduUseCase = GetEducationUseCase(repo);
      final factsUseCase = GetCareerFactsUseCase(repo);

      expect(expUseCase(const NoParams()).length, repo.getExperiences().length);
      expect(eduUseCase(const NoParams()).length, repo.getEducation().length);
      expect(factsUseCase(const NoParams()), repo.getYearsOfExperience());
    });

    test('GetHatsUseCase retrieves perspectives', () {
      final repo = RealHatRepository();
      final useCase = GetHatsUseCase(repo);
      expect(useCase(const NoParams()).length, repo.getHats().length);
      expect(useCase.getHatCount(), repo.getHatCount());
    });
  });

  group('Clean Architecture - Engineering Feature', () {
    test(
        'ArchitectureRepository and GetArchitectureTopicsUseCase return topics',
        () {
      final useCase =
          ServiceLocator.instance.isRegistered<GetArchitectureTopicsUseCase>()
              ? ServiceLocator.instance.get<GetArchitectureTopicsUseCase>()
              : GetArchitectureTopicsUseCase(
                  ServiceLocator.instance.get<ArchitectureRepository>());
      final topics = useCase(const NoParams());
      expect(topics, isNotEmpty);
      expect(topics.first.title, isNotEmpty);
    });
  });

  group('Clean Architecture - Contact Feature', () {
    test(
        'GetInquiryTracksUseCase retrieves tracks with complete default subjects and bodies',
        () {
      final contactRepo = ServiceLocator.instance.get<ContactRepository>();
      final useCase = GetInquiryTracksUseCase(contactRepo);
      final tracks = useCase(const NoParams());
      expect(tracks, isNotEmpty);
      expect(tracks.first.title, 'Role Opportunity');
      expect(tracks.first.subject, contains('Senior Mobile Engineer'));
    });

    test(
        'FormatInquiryMessageUseCase formats sender header and message cleanly',
        () {
      const useCase = FormatInquiryMessageUseCase();
      final formatted = useCase(const FormatInquiryParams(
        name: 'Jane Doe',
        company: 'Acme Corp',
        body: 'Let us connect!',
      ));
      expect(formatted, contains('FROM: Jane Doe (Acme Corp)'));
      expect(formatted, contains('---'));
      expect(formatted, contains('Let us connect!'));
    });
  });
}
