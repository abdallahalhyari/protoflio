import 'package:profile/l10n/app_localizations.dart';

/// Display name for a skill category. The English names stay the keys
/// (filtering, counts and colours switch on them); only the label is
/// localized.
String skillCategoryLabel(AppLocalizations l10n, String category) {
  switch (category) {
    case 'ALL':
      return l10n.skillCatAll;
    case 'Domain Expertise':
      return l10n.skillCatDomain;
    case 'Mobile Systems':
      return l10n.skillCatMobile;
    case 'Security & Protocols':
      return l10n.skillCatSecurity;
    case 'Architecture & State':
      return l10n.skillCatArchitecture;
    case 'Cloud & Infrastructure':
      return l10n.skillCatCloud;
    case 'Languages & Comm':
      return l10n.skillCatLanguages;
    default:
      return category;
  }
}
