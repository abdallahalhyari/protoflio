import 'url_sync_service.dart';

UrlSyncService createUrlSyncService() => UrlSyncServiceStub();

class UrlSyncServiceStub extends UrlSyncService {
  @override
  void updateHash(String hash) {}

  @override
  String? getInitialHash() => null;

  @override
  void listenToHashChanges(void Function(String hash) onHashChange) {}
}
