import 'package:flutter/foundation.dart';
import 'package:profile/l10n/app_localizations.dart';

/// Lets other sections open a specific About tab without importing the
/// About page itself, which is loaded lazily. The page consumes the request
/// when it mounts or changes.
final ValueNotifier<int?> aboutTabRequest = ValueNotifier<int?>(null);

/// Tab indexes on the About & Contact page.
abstract final class AboutTabs {
  static const int profile = 0;
  static const int playground = 1;
  static const int contact = 2;
}

/// The desktop section's one name, "About & Contact": the top nav item
/// and the page heading both use it, so they cannot drift apart.
String aboutAndContactLabel(AppLocalizations l) =>
    '${l.navAbout} & ${l.navContact}';
