import 'package:profile/features/contact/data/datasources/contact_local_data_source.dart';
import 'package:profile/features/contact/data/repositories/contact_repository_impl.dart';
import 'package:profile/features/contact/domain/repositories/contact_repository.dart';
import 'package:profile/features/contact/domain/usecases/format_inquiry_message_usecase.dart';
import 'package:profile/features/contact/domain/usecases/get_inquiry_tracks_usecase.dart';
import 'package:profile/features/engineering/data/repositories/architecture_repository_impl.dart';
import 'package:profile/features/engineering/domain/repositories/architecture_repository.dart';
import 'package:profile/features/engineering/domain/usecases/get_architecture_topics_usecase.dart';
import 'package:profile/features/experience/data/datasources/experience_local_data_source.dart';
import 'package:profile/features/experience/data/repositories/local_experience_repository.dart';
import 'package:profile/features/experience/domain/repositories/experience_repository.dart';
import 'package:profile/features/experience/domain/usecases/get_career_facts_usecase.dart';
import 'package:profile/features/experience/domain/usecases/get_education_usecase.dart';
import 'package:profile/features/experience/domain/usecases/get_experiences_usecase.dart';
import 'package:profile/features/hats/data/datasources/hat_local_data_source.dart';
import 'package:profile/features/hats/data/repositories/local_hat_repository.dart';
import 'package:profile/features/hats/domain/repositories/hat_repository.dart';
import 'package:profile/features/hats/domain/usecases/get_hats_usecase.dart';
import 'package:profile/features/projects/data/datasources/project_local_data_source.dart';
import 'package:profile/features/projects/data/repositories/local_project_repository.dart';
import 'package:profile/features/projects/domain/repositories/project_repository.dart';
import 'package:profile/features/projects/domain/usecases/filter_projects_usecase.dart';
import 'package:profile/features/projects/domain/usecases/get_projects_usecase.dart';
import 'package:profile/features/skills/data/datasources/skill_local_data_source.dart';
import 'package:profile/features/skills/data/repositories/local_skill_repository.dart';
import 'package:profile/features/skills/domain/repositories/skill_repository.dart';
import 'package:profile/features/skills/domain/usecases/filter_skills_usecase.dart';
import 'package:profile/features/skills/domain/usecases/get_skills_usecase.dart';

/// Lightweight, zero-dependency pure Dart Service Locator container.
class ServiceLocator {
  ServiceLocator._();
  static final ServiceLocator instance = ServiceLocator._();

  final Map<Type, dynamic> _registry = {};

  void register<T>(T instance) {
    _registry[T] = instance;
  }

  T get<T>() {
    final entry = _registry[T];
    if (entry == null) {
      throw StateError('ServiceLocator: No registration found for type $T');
    }
    return entry as T;
  }

  bool isRegistered<T>() => _registry.containsKey(T);

  void reset() {
    _registry.clear();
  }

  void setup() {
    // 1. Data Sources
    register<ProjectLocalDataSource>(const ProjectLocalDataSourceImpl());
    register<ExperienceLocalDataSource>(const ExperienceLocalDataSourceImpl());
    register<SkillLocalDataSource>(const SkillLocalDataSourceImpl());
    register<HatLocalDataSource>(const HatLocalDataSourceImpl());
    register<ContactLocalDataSource>(const ContactLocalDataSourceImpl());

    // 2. Repositories
    register<ProjectRepository>(
      LocalProjectRepository(get<ProjectLocalDataSource>()),
    );
    register<ExperienceRepository>(
      LocalExperienceRepository(get<ExperienceLocalDataSource>()),
    );
    register<SkillRepository>(
      LocalSkillRepository(get<SkillLocalDataSource>()),
    );
    register<HatRepository>(
      LocalHatRepository(get<HatLocalDataSource>()),
    );
    register<ArchitectureRepository>(
      const ArchitectureRepositoryImpl(),
    );
    register<ContactRepository>(
      ContactRepositoryImpl(get<ContactLocalDataSource>()),
    );

    // 3. Domain Use Cases
    register<GetProjectsUseCase>(
      GetProjectsUseCase(get<ProjectRepository>()),
    );
    register<FilterProjectsUseCase>(
      const FilterProjectsUseCase(),
    );
    register<GetSkillsUseCase>(
      GetSkillsUseCase(get<SkillRepository>()),
    );
    register<FilterSkillsUseCase>(
      const FilterSkillsUseCase(),
    );
    register<GetExperiencesUseCase>(
      GetExperiencesUseCase(get<ExperienceRepository>()),
    );
    register<GetEducationUseCase>(
      GetEducationUseCase(get<ExperienceRepository>()),
    );
    register<GetCareerFactsUseCase>(
      GetCareerFactsUseCase(get<ExperienceRepository>()),
    );
    register<GetHatsUseCase>(
      GetHatsUseCase(get<HatRepository>()),
    );
    register<GetArchitectureTopicsUseCase>(
      GetArchitectureTopicsUseCase(get<ArchitectureRepository>()),
    );
    register<GetInquiryTracksUseCase>(
      GetInquiryTracksUseCase(get<ContactRepository>()),
    );
    register<FormatInquiryMessageUseCase>(
      const FormatInquiryMessageUseCase(),
    );
  }
}
