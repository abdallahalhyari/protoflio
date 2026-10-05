import 'package:profile/l10n/app_localizations.dart';

/// Display name for an architecture topic. The detailed write-ups stay in
/// English; the topic names (tabs and headings) are localized.
String architectureTopicLabel(AppLocalizations l10n, String title) {
  switch (title) {
    case 'Clean Mobile Architecture':
      return l10n.archTopicClean;
    case 'Offline-First Synchronization':
      return l10n.archTopicOffline;
    case 'ISO-7816 Smart-Card & NFC Pipeline':
      return l10n.archTopicNfc;
    case 'Hardware-Backed Keystore & JWT Lifecycle':
      return l10n.archTopicKeystore;
    case 'Reactive State Management (BLoC)':
      return l10n.archTopicState;
    default:
      return title;
  }
}
