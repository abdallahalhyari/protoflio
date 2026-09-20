import 'package:equatable/equatable.dart';
import '../model/skill.dart';

class SkillsFilterState extends Equatable {
  final List<Skill> allSkills;
  final String selectedCategory;
  final String searchQuery;
  final List<Skill> filteredSkills;
  final Map<String, int> categoryCounts;

  const SkillsFilterState({
    required this.allSkills,
    this.selectedCategory = 'ALL',
    this.searchQuery = '',
    required this.filteredSkills,
    required this.categoryCounts,
  });

  bool get hasActiveFilter => selectedCategory != 'ALL' || searchQuery.isNotEmpty;

  SkillsFilterState copyWith({
    List<Skill>? allSkills,
    String? selectedCategory,
    String? searchQuery,
    List<Skill>? filteredSkills,
    Map<String, int>? categoryCounts,
  }) {
    return SkillsFilterState(
      allSkills: allSkills ?? this.allSkills,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      filteredSkills: filteredSkills ?? this.filteredSkills,
      categoryCounts: categoryCounts ?? this.categoryCounts,
    );
  }

  @override
  List<Object?> get props => [
        allSkills,
        selectedCategory,
        searchQuery,
        filteredSkills,
        categoryCounts,
      ];
}
