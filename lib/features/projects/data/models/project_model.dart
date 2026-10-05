import 'package:profile/features/projects/domain/entities/project.dart';

/// Data Transfer Object for [Project], handling JSON serialization and deserialization.
class ProjectModel extends Project {
  const ProjectModel({
    required super.name,
    required super.company,
    required super.tagline,
    required super.highlights,
    required super.stack,
    super.domain = 'Enterprise Mobile',
    super.metricBadge,
    super.url,
    super.linkedinUrl,
    super.problem,
    super.context,
    super.role,
    super.architecture,
    super.solution,
    super.results,
    super.technicalDecisions,
    super.lessonsLearned,
    super.heroImagePath,
    super.hasArchitectureDiagram = false,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      name: json['name'] as String,
      company: json['company'] as String,
      tagline: json['tagline'] as String,
      highlights: (json['highlights'] as List).map((e) => e as String).toList(),
      stack: (json['stack'] as List).map((e) => e as String).toList(),
      domain: json['domain'] as String? ?? 'Enterprise Mobile',
      metricBadge: json['metricBadge'] as String?,
      url: json['url'] as String?,
      linkedinUrl: json['linkedinUrl'] as String?,
      problem: json['problem'] as String?,
      context: json['context'] as String?,
      role: json['role'] as String?,
      architecture: json['architecture'] as String?,
      solution: json['solution'] as String?,
      results: (json['results'] as List?)?.map((e) => e as String).toList(),
      technicalDecisions: (json['technicalDecisions'] as List?)
          ?.map((e) => e as String)
          .toList(),
      lessonsLearned: json['lessonsLearned'] as String?,
      heroImagePath: json['heroImagePath'] as String?,
      hasArchitectureDiagram: json['hasArchitectureDiagram'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'company': company,
      'tagline': tagline,
      'highlights': highlights,
      'stack': stack,
      'domain': domain,
      if (metricBadge != null) 'metricBadge': metricBadge,
      if (url != null) 'url': url,
      if (linkedinUrl != null) 'linkedinUrl': linkedinUrl,
      if (problem != null) 'problem': problem,
      if (context != null) 'context': context,
      if (role != null) 'role': role,
      if (architecture != null) 'architecture': architecture,
      if (solution != null) 'solution': solution,
      if (results != null) 'results': results,
      if (technicalDecisions != null) 'technicalDecisions': technicalDecisions,
      if (lessonsLearned != null) 'lessonsLearned': lessonsLearned,
      if (heroImagePath != null) 'heroImagePath': heroImagePath,
      'hasArchitectureDiagram': hasArchitectureDiagram,
    };
  }
}
