class Project {
  final String name;
  final String company;
  final String tagline;
  final List<String> highlights;
  final List<String> stack;
  final String? url;
  
  // Senior Case Study Fields
  final String? problem;
  final String? context;
  final String? role;
  final String? architecture;
  final String? challenges;
  final String? solution;
  final List<String>? results;
  final List<String>? technicalDecisions;
  final String? lessonsLearned;

  const Project({
    required this.name,
    required this.company,
    required this.tagline,
    required this.highlights,
    required this.stack,
    this.url,
    this.problem,
    this.context,
    this.role,
    this.architecture,
    this.challenges,
    this.solution,
    this.results,
    this.technicalDecisions,
    this.lessonsLearned,
  });
}

