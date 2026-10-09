import 'package:flutter/foundation.dart';

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
