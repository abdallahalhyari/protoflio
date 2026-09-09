import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sound_service_web.dart' if (dart.library.io) 'sound_service_io.dart';

class SoundService {
  SoundService._();
  static final SoundService instance = SoundService._();

  final ValueNotifier<bool> isEnabled = ValueNotifier<bool>(true);

  void toggle() {
    isEnabled.value = !isEnabled.value;
    if (isEnabled.value) {
      playClick();
    }
  }

  void playClick() {
    if (!isEnabled.value) return;
    try {
      if (kIsWeb) {
        playWebClick();
      } else {
        SystemSound.play(SystemSoundType.click);
      }
    } catch (_) {}
  }

  void playPageTurn() {
    if (!isEnabled.value) return;
    try {
      if (kIsWeb) {
        playWebPageTurn();
      } else {
        HapticFeedback.selectionClick();
      }
    } catch (_) {}
  }
}
