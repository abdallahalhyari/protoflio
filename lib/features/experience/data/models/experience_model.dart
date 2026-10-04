import 'package:profile/features/experience/domain/entities/experience.dart';

/// Data Transfer Object for [Experience], handling JSON parsing and serialization.
class ExperienceModel extends Experience {
  const ExperienceModel({
    required super.role,
    required super.company,
    required super.period,
    required super.highlights,
    super.websiteUrl,
    super.linkedinUrl,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      role: json['role'] as String,
      company: json['company'] as String,
      period: json['period'] as String,
      highlights: (json['highlights'] as List).map((e) => e as String).toList(),
      websiteUrl: json['websiteUrl'] as String?,
      linkedinUrl: json['linkedinUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'company': company,
      'period': period,
      'highlights': highlights,
      if (websiteUrl != null) 'websiteUrl': websiteUrl,
      if (linkedinUrl != null) 'linkedinUrl': linkedinUrl,
    };
  }
}
