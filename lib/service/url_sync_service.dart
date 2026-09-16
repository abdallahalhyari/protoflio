import 'url_sync_service_stub.dart'
    if (dart.library.js_interop) 'url_sync_service_web.dart';

abstract class UrlSyncService {
  static UrlSyncService? _instance;
  static UrlSyncService get instance => _instance ??= createUrlSyncService();

  static const List<String> sectionHashes = [
    'home',
    'experience',
    'work',
    'stack',
    'engineering',
    'about',
    'contact',
  ];

  int hashToIndex(String hash) {
    final clean = hash.replaceAll('#', '').toLowerCase();
    final idx = sectionHashes.indexOf(clean);
    return idx != -1 ? idx : 0;
  }

  String indexToHash(int index) {
    if (index >= 0 && index < sectionHashes.length) {
      return sectionHashes[index];
    }
    return sectionHashes[0];
  }

  void updateHash(String hash);
  String? getInitialHash();

  /// Registers [onHashChange] for future `hashchange` / `popstate` events.
  /// Returns a cancel callback the caller must invoke on dispose to detach
  /// the listener; safe to call multiple times.
  void Function() listenToHashChanges(void Function(String hash) onHashChange);
}
