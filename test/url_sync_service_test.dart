import 'package:flutter_test/flutter_test.dart';
import 'package:profile/service/url_sync_service.dart';

void main() {
  final svc = UrlSyncService.instance;

  group('UrlSyncService.hashToIndex', () {
    test('exact match returns index', () {
      expect(svc.hashToIndex('home'), 0);
      expect(svc.hashToIndex('experience'), 1);
      expect(svc.hashToIndex('work'), 2);
      expect(svc.hashToIndex('stack'), 3);
      expect(svc.hashToIndex('engineering'), 4);
      expect(svc.hashToIndex('about'), 5);
      expect(svc.hashToIndex('contact'), 6);
    });

    test('leading hash stripped', () {
      expect(svc.hashToIndex('#contact'), 6);
      expect(svc.hashToIndex('##contact'), 6);
    });

    test('case-insensitive', () {
      expect(svc.hashToIndex('CONTACT'), 6);
      expect(svc.hashToIndex('Work'), 2);
    });

    test('unknown fragment falls back to home (0)', () {
      expect(svc.hashToIndex('unknown'), 0);
      expect(svc.hashToIndex(''), 0);
      expect(svc.hashToIndex('#'), 0);
    });
  });

  group('UrlSyncService.indexToHash', () {
    test('every valid index maps back to a section', () {
      for (int i = 0; i < UrlSyncService.sectionHashes.length; i++) {
        final hash = svc.indexToHash(i);
        expect(hash, UrlSyncService.sectionHashes[i]);
        expect(svc.hashToIndex(hash), i);
      }
    });

    test('out-of-range index clamps to home', () {
      expect(svc.indexToHash(-1), 'home');
      expect(svc.indexToHash(999), 'home');
    });
  });
}
