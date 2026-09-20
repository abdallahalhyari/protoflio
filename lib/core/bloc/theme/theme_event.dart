import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ThemeStarted extends ThemeEvent {
  const ThemeStarted();
}

class ThemeModeToggled extends ThemeEvent {
  const ThemeModeToggled();
}

class ThemeModeChanged extends ThemeEvent {
  final ThemeMode mode;

  const ThemeModeChanged(this.mode);

  @override
  List<Object?> get props => [mode];
}

class ThemeAccentUpdated extends ThemeEvent {
  final int sectionIndex;

  const ThemeAccentUpdated(this.sectionIndex);

  @override
  List<Object?> get props => [sectionIndex];
}

class ThemeAccentUpdatedFromHash extends ThemeEvent {
  final String hash;

  const ThemeAccentUpdatedFromHash(this.hash);

  @override
  List<Object?> get props => [hash];
}
