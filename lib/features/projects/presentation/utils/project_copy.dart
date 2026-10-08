import 'package:profile/features/projects/domain/entities/project.dart';
import 'package:profile/l10n/app_localizations.dart';

String localizedProjectTagline(AppLocalizations loc, Project project) {
  return switch (project.company) {
    'NatHealth' => loc.projectTaglineNatHealth,
    'ESKADENIA Software' => loc.projectTaglineEskadenia,
    'Solutions Now IT' => loc.projectTaglineSolutions,
    'Future Advanced Internet Solutions' => loc.projectTaglineFais,
    _ => project.tagline,
  };
}

String? localizedProjectOutcome(AppLocalizations loc, Project project) {
  if (project.results == null || project.results!.isEmpty) return null;

  return switch (project.company) {
    'NatHealth' => loc.projectOutcomeNatHealth,
    'ESKADENIA Software' => loc.projectOutcomeEskadenia,
    'Solutions Now IT' => loc.projectOutcomeSolutions,
    'Future Advanced Internet Solutions' => loc.projectOutcomeFais,
    _ => project.results!.first,
  };
}

String localizedProjectDomain(AppLocalizations loc, String domain) {
  return switch (domain) {
    'ALL' => loc.projectDomainAll,
    'Healthcare & Smart Cards' => loc.projectDomainHealthcare,
    'Enterprise HIS & LMS' => loc.projectDomainEnterprise,
    'Fleet & Telematics' => loc.projectDomainFleet,
    'M-Commerce & Streaming' => loc.projectDomainCommerce,
    _ => domain,
  };
}

/// The one number a card leads with, taken from the case study. Null when
/// a project has no measured result to quote.
({String value, String label})? localizedProjectFigure(
    AppLocalizations loc, Project project) {
  return switch (project.company) {
    'NatHealth' => (
        value: loc.projectFigureValueNatHealth,
        label: loc.projectFigureLabelNatHealth,
      ),
    'ESKADENIA Software' => (
        value: loc.projectFigureValueEskadenia,
        label: loc.projectFigureLabelEskadenia,
      ),
    'Solutions Now IT' => (
        value: loc.projectFigureValueSolutions,
        label: loc.projectFigureLabelSolutions,
      ),
    _ => null,
  };
}
