import 'package:equatable/equatable.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ThemeModeToggled extends ThemeEvent {
  const ThemeModeToggled();
}

/// The section now on screen; its accent becomes the theme seed.
class ThemeAccentUpdated extends ThemeEvent {
  final int sectionIndex;

  const ThemeAccentUpdated(this.sectionIndex);

  @override
  List<Object?> get props => [sectionIndex];
}
