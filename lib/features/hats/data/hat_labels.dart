import 'package:profile/l10n/app_localizations.dart';

/// Display name for a perspective ("hat"). The English title stays the key
/// (hero tags, widget keys); only the label is localized.
String hatTitleLabel(AppLocalizations l10n, String title) {
  switch (title) {
    case 'Thinking':
      return l10n.hatThinking;
    case 'Communicating':
      return l10n.hatCommunicating;
    case 'Sorting':
      return l10n.hatSorting;
    case 'Building':
      return l10n.hatBuilding;
    case 'Fixing':
      return l10n.hatFixing;
    case 'Compassion':
      return l10n.hatCompassion;
    default:
      return title;
  }
}
