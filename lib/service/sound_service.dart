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

  // Debounce identical page-turn sounds when the user rapid-flicks the
  // wheel or presses arrow keys — overlapping page-turn plays sound
  // clipped and messy. 180ms > single page-turn duration but < the
  // gap a deliberate user would produce.
  DateTime _lastPageTurnAt = DateTime.fromMillisecondsSinceEpoch(0);
  // Kept literal — semantics (audio debounce) don't map to any motion
  // token; matching against AppMotion.chipHover (a hover animation
  // duration) would misdirect future timing tweaks.
  static const Duration _pageTurnMinGap = Duration(milliseconds: 180);

  void playPageTurn() {
    if (!isEnabled.value) return;
    final now = DateTime.now();
    if (now.difference(_lastPageTurnAt) < _pageTurnMinGap) return;
    _lastPageTurnAt = now;
    try {
      if (kIsWeb) {
        playWebPageTurn();
      } else {
        HapticFeedback.selectionClick();
      }
    } catch (_) {}
  }
}
