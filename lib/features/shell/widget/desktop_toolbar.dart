import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/core/bloc/locale/locale_bloc.dart';
import 'package:profile/core/bloc/locale/locale_event.dart';
import 'package:profile/core/bloc/locale/locale_state.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';
import 'package:profile/core/bloc/theme/theme_event.dart';
import 'package:profile/core/bloc/theme/theme_state.dart';
import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/tokens.dart';

/// Top-right desktop toolbar — language picker, theme toggle, audio
/// mute. Self-contained: reads its own state from
/// mute. Self-contained: reads its own state from ThemeBloc,
/// LocaleBloc, and
/// [SoundService.instance.isEnabled].
class DesktopToolbar extends StatelessWidget {
  const DesktopToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: (prev, curr) => prev.mode != curr.mode,
      builder: (_, themeState) {
        final dark = themeState.isDark;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LanguagePickerPuck(dark: dark),
            const SizedBox(width: AppSpacing.sm),
            _ThemeTogglePuck(dark: dark),
            const SizedBox(width: AppSpacing.sm),
            _AudioTogglePuck(dark: dark),
          ],
        );
      },
    );
  }
}

class _Puck extends StatelessWidget {
  const _Puck({required this.dark, required this.child});
  final bool dark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: dark ? Colors.black45 : Colors.white.withValues(alpha: 0.9),
      elevation: dark ? 0 : 2,
      shadowColor: Colors.black12,
      shape: CircleBorder(
        side: BorderSide(
          color:
              dark ? Colors.white.withValues(alpha: 0.14) : AppColors.slate200,
          width: 1.0,
        ),
      ),
      child: child,
    );
  }
}

class _LanguagePickerPuck extends StatelessWidget {
  const _LanguagePickerPuck({required this.dark});
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return _Puck(
      dark: dark,
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, localeState) {
          final locale = localeState.locale;
          return Semantics(
            button: true,
            label:
                'Change language. Current: ${locale.languageCode.toUpperCase()}',
            child: PopupMenuButton<String>(
              tooltip: 'Change Language',
              icon: Icon(Icons.language,
                  color: dark ? Colors.white : AppColors.slate900),
              onSelected: (val) {
                HapticFeedback.lightImpact();
                SoundService.instance.playClick();
                context.read<LocaleBloc>().add(LocaleChanged(val));
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'en', child: Text('English')),
                PopupMenuItem(value: 'ar', child: Text('العربية')),
                PopupMenuItem(value: 'cs', child: Text('Čeština')),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ThemeTogglePuck extends StatelessWidget {
  const _ThemeTogglePuck({required this.dark});
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: dark,
      label: dark ? 'Switch to light mode' : 'Switch to dark mode',
      child: _Puck(
        dark: dark,
        child: IconButton(
          tooltip: dark ? 'Switch to light' : 'Switch to dark',
          icon: Icon(
            dark ? Icons.light_mode : Icons.dark_mode,
            color: dark ? Colors.white : AppColors.slate900,
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            SoundService.instance.playClick();
            context.read<ThemeBloc>().add(const ThemeModeToggled());
          },
        ),
      ),
    );
  }
}

class _AudioTogglePuck extends StatelessWidget {
  const _AudioTogglePuck({required this.dark});
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: SoundService.instance.isEnabled,
      builder: (context, enabled, _) {
        return Semantics(
          button: true,
          toggled: enabled,
          label: enabled ? 'Mute sound effects' : 'Enable sound effects',
          child: _Puck(
            dark: dark,
            child: IconButton(
              tooltip: enabled
                  ? 'Sound Effects: ON (Click to mute)'
                  : 'Sound Effects: MUTED (Click to enable)',
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    enabled ? Icons.volume_up : Icons.volume_off,
                    color: enabled
                        ? (dark ? Colors.white : AppColors.slate900)
                        : (dark
                            ? Colors.white.withValues(alpha: 0.60)
                            : AppColors.slate400),
                    size: 18,
                  ),
                  if (enabled)
                    Positioned(
                      right: -1,
                      top: -1,
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: AppColors.accentGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                SoundService.instance.toggle();
              },
            ),
          ),
        );
      },
    );
  }
}
