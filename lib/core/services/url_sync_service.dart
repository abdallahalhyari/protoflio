import 'package:profile/core/services/url_sync_service_stub.dart'
    if (dart.library.js_interop) 'url_sync_service_web.dart';

abstract class UrlSyncService {
  static UrlSyncService? _instance;
  static UrlSyncService get instance => _instance ??= createUrlSyncService();

  static const List<String> sectionHashes = [
    'home',
    'work',
    'experience',
    'stack',
    'engineering',
    'about',
    'contact',
  ];

  /// Section index for [hash]; a sub-route (`work/nathealth`) maps to its
  /// section, anything unknown to home. Supports canonical and alias slugs
  /// (#home, #experience, #projects, #skills, #engineering, #about, #contact).
  /// `#perspectives` is the old name for About (the Hats section it
  /// replaced) and still resolves there, so shared links keep working.
  int hashToIndex(String hash) {
    final clean = hash.replaceAll('#', '').split('/').first.toLowerCase();
    switch (clean) {
      case 'home':
        return 0;
      case 'work':
      case 'projects':
        return 1;
      case 'engineering':
        return 4;
      case 'experience':
        return 2;
      case 'stack':
      case 'skills':
        return 3;
      case 'about':
      case 'perspectives':
        return 5;
      case 'contact':
        return 6;
      default:
        final idx = sectionHashes.indexOf(clean);
        return idx != -1 ? idx : 0;
    }
  }

  String indexToHash(int index, {bool mobileLayout = true}) {
    if (index == 5 && !mobileLayout) return 'contact';
    if (index >= 0 && index < sectionHashes.length) {
      return sectionHashes[index];
    }
    return sectionHashes[0];
  }

  static const String baseTitle =
      'Abdallah Alhyari — Senior mobile engineer, Flutter & Android';

  String titleForHash(String hash) {
    final clean = hash.replaceAll('#', '').toLowerCase();
    switch (clean) {
      case 'work':
      case 'projects':
        return 'Work — Abdallah Alhyari';
      case 'work/nathealth':
        return 'NatHealth Mobile Suite — case study by Abdallah Alhyari';
      case 'work/eskadenia':
        return 'E-Learning & Healthcare Enterprise Suite — case study by Abdallah Alhyari';
      case 'work/solutions':
        return 'Loyalty Rewards & Ephemeral Social Media Apps — case study by Abdallah Alhyari';
      case 'work/fais':
        return 'M-Commerce & Media-Streaming Clients — case study by Abdallah Alhyari';
      case 'engineering':
        return 'Engineering — Abdallah Alhyari';
      case 'experience':
        return 'Experience — Abdallah Alhyari';
      case 'stack':
      case 'skills':
        return 'Skills — Abdallah Alhyari';
      case 'about':
      case 'perspectives':
        return 'About — Abdallah Alhyari';
      case 'contact':
        return 'Contact — Abdallah Alhyari';
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
