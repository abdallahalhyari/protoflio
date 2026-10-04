import 'package:profile/features/experience/data/datasources/experience_local_data_source.dart';
import 'package:profile/features/experience/domain/entities/experience.dart';
import 'package:profile/features/experience/domain/repositories/experience_repository.dart';
import 'package:profile/shared/utils/career_facts.dart';

class LocalExperienceRepository implements ExperienceRepository {
  final ExperienceLocalDataSource dataSource;
  List<Experience> _experiences = [];
  List<Education> _education = [];
  List<String> _certifications = [];

  LocalExperienceRepository([ExperienceLocalDataSource? dataSource])
      : dataSource = dataSource ?? const ExperienceLocalDataSourceImpl();

  Future<void> load() async {
    final bundle = await dataSource.getBundledExperienceData();
    _experiences = bundle.experiences;
    _education = bundle.education;
    _certifications = bundle.certifications;
  }

  @override
  List<Experience> getExperiences() => _experiences;

  @override
  List<Education> getEducation() => _education;

  @override
  List<String> getCertifications() => _certifications;

  @override
  int getYearsOfExperience() => CareerFacts.yearsOfExperience();
}
