import 'package:flutter/foundation.dart';

/// Lets other sections open a specific About tab (0 Profile, 1 Under the
/// hood, 2 Playground) without importing the About page itself, which is
/// loaded lazily. The page consumes the request when it mounts or changes.
final ValueNotifier<int?> aboutTabRequest = ValueNotifier<int?>(null);
