import 'package:equatable/equatable.dart';

sealed class ProjectsFilterEvent extends Equatable {
  const ProjectsFilterEvent();

  @override
  List<Object?> get props => [];
}

class DomainFilterSelected extends ProjectsFilterEvent {
  final String domain;

  const DomainFilterSelected(this.domain);

  @override
  List<Object?> get props => [domain];
}

class TechFilterToggled extends ProjectsFilterEvent {
  final String tech;

  const TechFilterToggled(this.tech);

  @override
  List<Object?> get props => [tech];
}

class ProjectsFilterReset extends ProjectsFilterEvent {
  const ProjectsFilterReset();
}
