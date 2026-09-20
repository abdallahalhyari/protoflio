import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:profile/theme/tokens.dart';

class ThemeState extends Equatable {
  final ThemeMode mode;
  final Color seedColor;
  final int activeSectionIndex;

  const ThemeState({
    this.mode = ThemeMode.dark,
    this.seedColor = AppColors.seed,
    this.activeSectionIndex = 0,
  });

  bool get isDark => mode == ThemeMode.dark;

  ThemeState copyWith({
    ThemeMode? mode,
    Color? seedColor,
    int? activeSectionIndex,
  }) {
    return ThemeState(
      mode: mode ?? this.mode,
      seedColor: seedColor ?? this.seedColor,
      activeSectionIndex: activeSectionIndex ?? this.activeSectionIndex,
    );
  }

  @override
  List<Object?> get props => [mode, seedColor, activeSectionIndex];
}
