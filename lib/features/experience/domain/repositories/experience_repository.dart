import 'package:profile/features/experience/domain/entities/experience.dart';

abstract class ExperienceRepository {
  /// Returns all experience nodes available in the portfolio.
  List<Experience> getExperiences();

  /// Returns the number of years of experience.
  int getYearsOfExperience();

  /// Returns education nodes.
  List<Education> getEducation();

  /// Returns certifications.
  List<String> getCertifications();
}
