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

  static const String baseTitle =
      'Abdallah Alhyari — Senior Flutter & Android Engineer';

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
        return 'Systems Architecture & Engineering · Abdallah Alhyari';
      case 'experience':
        return 'Career Trajectory & Roles · Abdallah Alhyari';
      case 'stack':
        return 'Architectural Mastery & Skills · Abdallah Alhyari';
      case 'about':
        return 'Perspectives & Roles · Abdallah Alhyari';
      case 'contact':
        return 'Contact & Recruiter Inquiries · Abdallah Alhyari';
      case 'home':
      default:
        return baseTitle;
    }
  }

  void updateHash(String hash);
  void updateTitle(String title);
  String? getInitialHash();

  /// Registers [onHashChange] for future `hashchange` / `popstate` events.
  /// Returns a cancel callback the caller must invoke on dispose to detach
  /// the listener; safe to call multiple times.
  void Function() listenToHashChanges(void Function(String hash) onHashChange);
}
