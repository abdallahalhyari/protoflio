import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:profile/theme/tokens.dart';

class ThemeState extends Equatable {
  final ThemeMode mode;
  final Color seedColor;

  const ThemeState({
    this.mode = ThemeMode.dark,
    this.seedColor = AppColors.seed,
  });

  bool get isDark => mode == ThemeMode.dark;

  ThemeState copyWith({ThemeMode? mode, Color? seedColor}) {
    return ThemeState(
      mode: mode ?? this.mode,
      seedColor: seedColor ?? this.seedColor,
    );
  }

  @override
  List<Object?> get props => [mode, seedColor];
}
