import 'package:profile/core/services/url_sync_service_stub.dart'
    if (dart.library.js_interop) 'url_sync_service_web.dart';

abstract class UrlSyncService {
  static UrlSyncService? _instance;
  static UrlSyncService get instance => _instance ??= createUrlSyncService();

  static const List<String> sectionHashes = [
    'home',
    'work',
    'engineering',
    'experience',
    'stack',
    'about',
    'contact',
  ];

  /// Section index for [hash]; a sub-route (`work/nathealth`) maps to its
  /// section, anything unknown to home.
  int hashToIndex(String hash) {
    final clean = hash.replaceAll('#', '').split('/').first.toLowerCase();
    final idx = sectionHashes.indexOf(clean);
    return idx != -1 ? idx : 0;
  }

  String indexToHash(int index) {
    if (index >= 0 && index < sectionHashes.length) {
      return sectionHashes[index];
    }
    return sectionHashes[0];
  }

  static const String baseTitle =
      'Abdallah Alhyari — Mobile Engineer: Flutter, Android, NFC';

  String titleForHash(String hash) {
    final clean = hash.replaceAll('#', '').toLowerCase();
    switch (clean) {
      case 'work':
        return 'Selected Work & Case Studies · Abdallah Alhyari';
      case 'work/nathealth':
        return 'NatHealth Smart-Card Case Study · Abdallah Alhyari';
      case 'work/eskadenia':
        return 'ESKADENIA Healthcare Case Study · Abdallah Alhyari';
      case 'work/solutions':
        return 'Solutions Now Loyalty Case Study · Abdallah Alhyari';
      case 'work/fais':
        return 'FAIS M-Commerce & Streaming Case Study · Abdallah Alhyari';
      case 'engineering':
        return 'Engineering & Systems Architecture · Abdallah Alhyari';
      case 'experience':
        return 'Experience & Career · Abdallah Alhyari';
      case 'stack':
        return 'Skills & Stack · Abdallah Alhyari';
      case 'about':
        return 'About · Abdallah Alhyari';
      case 'contact':
        return 'Contact & Recruiter Inquiries · Abdallah Alhyari';
      case 'home':
      default:
        return baseTitle;
    }
  }

  /// Replaces the current history entry's hash (no new Back step).
  void updateHash(String hash);

  /// Pushes a new history entry for [hash], so browser Back returns to the
  /// current one. Used for pages that should close on Back (case studies).
  void pushHash(String hash);

  /// Steps browser history back one entry.
  void back();
  void updateTitle(String title);
  String? getInitialHash();

  /// Registers [onHashChange] for future `hashchange` / `popstate` events.
  /// Returns a cancel callback the caller must invoke on dispose to detach
  /// the listener; safe to call multiple times.
  void Function() listenToHashChanges(void Function(String hash) onHashChange);
}
