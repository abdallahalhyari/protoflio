class Project {
  final String name;
  final String company;
  final String tagline;
  final List<String> highlights;
  final List<String> stack;
  final String? url;
  final String? linkedinUrl;

  // Senior Case Study Fields
  final String? problem;
  final String? context;
  final String? role;
  final String? architecture;
  final String? solution;
  final List<String>? results;
  final List<String>? technicalDecisions;
  final String? lessonsLearned;
  final String? heroImagePath;
  final bool hasArchitectureDiagram;

  // Domain & Production Metrics
  final String domain;
  final String? metricBadge;

  const Project({
    required this.name,
    required this.company,
    required this.tagline,
    required this.highlights,
    required this.stack,
    this.domain = 'Enterprise Mobile',
    this.metricBadge,
    this.url,
    this.linkedinUrl,
    this.problem,
    this.context,
    this.role,
    this.architecture,
    this.solution,
    this.results,
    this.technicalDecisions,
    this.lessonsLearned,
    this.heroImagePath,
    this.hasArchitectureDiagram = false,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
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
