import 'package:profile/core/usecases/usecase.dart';
import 'package:profile/features/skills/domain/entities/skill.dart';

class FilterSkillsParams {
  final List<Skill> allSkills;
  final String category;
  final String query;

  const FilterSkillsParams({
    required this.allSkills,
    required this.category,
    required this.query,
  });
}

class FilterSkillsUseCase implements UseCase<List<Skill>, FilterSkillsParams> {
  const FilterSkillsUseCase();

  @override
  List<Skill> call(FilterSkillsParams params) {
    var result = params.category == 'ALL'
        ? params.allSkills
        : params.allSkills.where((s) => s.category == params.category).toList();

    final words = params.query
        .toLowerCase()
        .split(RegExp(r'[\s,]+'))
        .where((w) => w.isNotEmpty)
        .toList();

    if (words.isNotEmpty) {
      result = result.where((s) {
        final haystack = [
          s.name,
          s.category,
          s.description,
          s.provenIn,
          ...s.tags,
        ].join(' ').toLowerCase();
        return words.every(haystack.contains);
      }).toList();
    }

    return result;
  }

  Map<String, int> computeCategoryCounts(List<Skill> skills) {
    final counts = <String, int>{'ALL': skills.length};
    for (final skill in skills) {
      counts[skill.category] = (counts[skill.category] ?? 0) + 1;
    }
    return Map.unmodifiable(counts);
  }
}
