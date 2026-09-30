import 'package:equatable/equatable.dart';

abstract class SkillsFilterEvent extends Equatable {
  const SkillsFilterEvent();

  @override
  List<Object?> get props => [];
}

class SkillCategorySelected extends SkillsFilterEvent {
  final String category;

  const SkillCategorySelected(this.category);

  @override
  List<Object?> get props => [category];
}

class SkillSearchQueryChanged extends SkillsFilterEvent {
  final String query;

  const SkillSearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class SkillsFilterReset extends SkillsFilterEvent {
  const SkillsFilterReset();
}
