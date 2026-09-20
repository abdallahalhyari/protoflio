import 'package:flutter/services.dart';
import 'url_sync_service.dart';

UrlSyncService createUrlSyncService() => UrlSyncServiceStub();

class UrlSyncServiceStub extends UrlSyncService {
  @override
  void updateHash(String hash) {
    updateTitle(titleForHash(hash));
  }

  @override
  void updateTitle(String title) {
    try {
      SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(label: title),
      );
    } catch (_) {}
  }

  @override
  String? getInitialHash() => null;

  @override
  void Function() listenToHashChanges(
          void Function(String hash) onHashChange) =>
      () {};
}
