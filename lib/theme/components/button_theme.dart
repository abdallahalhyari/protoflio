import 'package:flutter/material.dart';

class AppButtonTheme {
  AppButtonTheme._();

  static WidgetStateProperty<Color?> _overlay(ColorScheme scheme) {
    return WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.pressed)) {
        return scheme.primary.withValues(alpha: 0.24);
      }
      if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
        return scheme.primary.withValues(alpha: 0.12);
      }
      return null;
    });
  }

  static WidgetStateProperty<BorderSide?> _focusBorder(ColorScheme scheme) {
    return WidgetStateProperty.resolveWith<BorderSide?>((states) {
      if (states.contains(WidgetState.focused)) {
        return BorderSide(color: scheme.primary, width: 2);
      }
      return null;
    });
  }

  static ButtonStyle style(ColorScheme scheme) {
    return ButtonStyle(
      side: _focusBorder(scheme),
      overlayColor: _overlay(scheme),
    );
  }

  static IconButtonThemeData iconTheme(ColorScheme scheme) {
    return IconButtonThemeData(
      style: ButtonStyle(
        overlayColor: _overlay(scheme),
      ),
    );
  }
}
