import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';
import 'package:profile/core/bloc/theme/theme_event.dart';
import 'package:profile/core/services/sound_service.dart';

class DesktopKeyboardNav extends StatelessWidget {
  final Widget child;
  final FocusNode focusNode;
  final int pageCount;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final void Function(int) onGoTo;
  final VoidCallback onShowHelp;

  const DesktopKeyboardNav({
    super.key,
    required this.child,
    required this.focusNode,
    required this.pageCount,
    required this.onNext,
    required this.onPrev,
    required this.onGoTo,
    required this.onShowHelp,
  });

  KeyEventResult _handleKey(BuildContext context, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final modalRoute = ModalRoute.of(context);
    if (modalRoute != null && !modalRoute.isCurrent) {
      return KeyEventResult.ignored;
    }
    // Typing belongs to the text field: "5" in the skills search jumped to
    // Engineering, Space paged down. Modified keys stay the browser's
    // (Ctrl+1 switches tabs).
    if (_typingInField() || _modified()) return KeyEventResult.ignored;
    final k = event.logicalKey;

    // Hotkey: T toggles theme (Light / Dark)
    if (k == LogicalKeyboardKey.keyT) {
      SoundService.instance.playClick();
      context.read<ThemeBloc>().add(const ThemeModeToggled());
      return KeyEventResult.handled;
    }

    // Hotkey: M toggles sound effects on / off
    if (k == LogicalKeyboardKey.keyM) {
      SoundService.instance.toggle();
      return KeyEventResult.handled;
    }

    // Section Mnemonic Hotkeys: W, E, X, S, H, C
    if (k == LogicalKeyboardKey.keyW && pageCount > 1) {
      onGoTo(1);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.keyE && pageCount > 2) {
      onGoTo(2);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.keyX && pageCount > 3) {
      onGoTo(3);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.keyS && pageCount > 4) {
      onGoTo(4);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.keyH && pageCount > 5) {
      onGoTo(5);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.keyC && pageCount > 6) {
      onGoTo(6);
      return KeyEventResult.handled;
    }

    if (k == LogicalKeyboardKey.arrowDown ||
        k == LogicalKeyboardKey.pageDown ||
        k == LogicalKeyboardKey.space) {
      onNext();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowUp || k == LogicalKeyboardKey.pageUp) {
      onPrev();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.home) {
      onGoTo(0);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.end) {
      onGoTo(pageCount - 1);
      return KeyEventResult.handled;
    }
    final digit = _digitKeyToIndex(k);
    if (digit != null) {
      onGoTo(digit);
      return KeyEventResult.handled;
    }
    // "?" (Shift+/) or Slash — open the keyboard shortcut modal so
    // discoverability isn't limited to the tiny bottom-right hint chip.
    if (k == LogicalKeyboardKey.question || k == LogicalKeyboardKey.slash) {
      onShowHelp();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  static bool _typingInField() {
    final focused = FocusManager.instance.primaryFocus?.context;
    if (focused == null) return false;
    return focused.widget is EditableText ||
        focused.findAncestorWidgetOfExactType<EditableText>() != null;
  }

  static bool _modified() {
    final keys = HardwareKeyboard.instance;
    return keys.isControlPressed || keys.isMetaPressed || keys.isAltPressed;
  }

  int? _digitKeyToIndex(LogicalKeyboardKey k) {
    final id = k.keyId;
    final digitBase = LogicalKeyboardKey.digit1.keyId;
    if (id >= digitBase && id < digitBase + pageCount) return id - digitBase;
    final numBase = LogicalKeyboardKey.numpad1.keyId;
    if (id >= numBase && id < numBase + pageCount) return id - numBase;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      autofocus: true,
      onKeyEvent: (node, event) => _handleKey(context, event),
      child: child,
    );
  }
}
