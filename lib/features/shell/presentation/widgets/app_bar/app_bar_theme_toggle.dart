import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';
import 'package:profile/core/bloc/theme/theme_event.dart';
import 'package:profile/core/bloc/theme/theme_state.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';

class AppBarThemeToggle extends StatelessWidget {
  const AppBarThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: (prev, curr) => prev.mode != curr.mode,
      builder: (_, themeState) {
        final dark = themeState.isDark;
        final l10n = AppLocalizations.of(context)!;
        return MergeSemantics(
          child: Semantics(
            button: true,
            toggled: dark,
            label: dark ? l10n.switchToLightMode : l10n.switchToDarkMode,
            child: Tooltip(
              message: dark ? l10n.switchToLightMode : l10n.switchToDarkMode,
              excludeFromSemantics: true,
              child: IconButton(
                iconSize: 18,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                icon: Icon(
                  dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  color: context.mutedText,
                ),
                onPressed: () {
                  SoundService.instance.playClick();
                  context.read<ThemeBloc>().add(const ThemeModeToggled());
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
