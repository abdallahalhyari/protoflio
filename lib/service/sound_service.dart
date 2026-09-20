import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sound_service_web.dart' if (dart.library.io) 'sound_service_io.dart';

class SoundService {
  SoundService._();
  static final SoundService instance = SoundService._();

  static const String _prefsKey = 'soundEnabled';

  final ValueNotifier<bool> isEnabled = ValueNotifier<bool>(true);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool(_prefsKey);
    if (saved != null) {
      isEnabled.value = saved;
    }
  }

  static Future<void> _persist(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, value);
  }

  void toggle() {
    isEnabled.value = !isEnabled.value;
    unawaited(_persist(isEnabled.value));
    if (isEnabled.value) {
      playClick();
    }
  }

  void playClick({bool haptic = true}) {
    if (haptic) {
      try {
        HapticFeedback.lightImpact();
      } catch (_) {}
    }
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
  static const Duration _pageTurnMinGap = Duration(milliseconds: 180);

  void playPageTurn({bool haptic = true}) {
    final now = DateTime.now();
    if (now.difference(_lastPageTurnAt) < _pageTurnMinGap) return;
    _lastPageTurnAt = now;

    if (haptic) {
      try {
        HapticFeedback.selectionClick();
      } catch (_) {}
    }
    if (!isEnabled.value) return;
    try {
      if (kIsWeb) {
        playWebPageTurn();
      } else {
        SystemSound.play(SystemSoundType.click);
      }
    } catch (_) {}
  }

  void playSelection({bool haptic = true}) {
    if (haptic) {
      try {
        HapticFeedback.selectionClick();
      } catch (_) {}
    }
    if (!isEnabled.value) return;
    try {
      if (kIsWeb) {
        playWebClick();
      } else {
        SystemSound.play(SystemSoundType.click);
      }
    } catch (_) {}
  }

  void playSnap({bool haptic = true}) {
    if (haptic) {
      try {
        HapticFeedback.selectionClick();
      } catch (_) {}
    }
    if (!isEnabled.value) return;
    try {
      if (kIsWeb) {
        playWebClick();
      } else {
        SystemSound.play(SystemSoundType.click);
      }
    } catch (_) {}
  }
}
