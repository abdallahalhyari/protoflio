import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/core/bloc/locale/locale_bloc.dart';
import 'package:profile/core/bloc/locale/locale_event.dart';
import 'package:profile/core/bloc/locale/locale_state.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';
import 'package:profile/core/bloc/theme/theme_event.dart';
import 'package:profile/core/bloc/theme/theme_state.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/tokens.dart';

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

class _Puck extends StatefulWidget {
  const _Puck({
    required this.dark,
    required this.child,
  });

  final bool dark;
  final Widget child;

  @override
  State<_Puck> createState() => _PuckState();
}

class _PuckState extends State<_Puck> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final dark = widget.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.05 : 1.0,
        duration: AppMotion.chipHover,
        curve: AppMotion.emphasized,
        child: AnimatedContainer(
          duration: AppMotion.chipHover,
          curve: AppMotion.emphasized,
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dark
                ? (_hovered
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.06))
                : (_hovered
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.92)),
            border: Border.all(
              color: _hovered
                  ? primary.withValues(alpha: dark ? 0.7 : 0.6)
                  : (dark
                      ? Colors.white.withValues(alpha: 0.18)
                      : AppColors.ink300),
              width: _hovered ? 1.4 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _hovered
                    ? primary.withValues(alpha: dark ? 0.28 : 0.16)
                    : Colors.black.withValues(alpha: dark ? 0.25 : 0.06),
                blurRadius: _hovered ? 12 : 6,
                spreadRadius: _hovered ? 1 : 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(child: widget.child),
        ),
      ),
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
          // One node, named once: the label merges into the menu button
          // (which keeps its focus state, so screen readers follow Tab),
          // and the hover tooltip stays out of the spoken name.
          return MergeSemantics(
            child: Semantics(
              button: true,
              label:
                  'Change language. Current: ${locale.languageCode.toUpperCase()}',
              child: Tooltip(
                message: 'Change Language',
                excludeFromSemantics: true,
                child: PopupMenuButton<String>(
                  tooltip: '',
                  padding: EdgeInsets.zero,
                  iconSize: 18,
                  icon: Icon(Icons.language_rounded,
                      color: dark ? Colors.white : AppColors.ink900, size: 18),
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
              ),
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
    return MergeSemantics(
      child: Semantics(
        button: true,
        toggled: dark,
        label: dark ? 'Switch to light mode' : 'Switch to dark mode',
        child: _Puck(
          dark: dark,
          child: Tooltip(
            message: dark ? 'Switch to light' : 'Switch to dark',
            excludeFromSemantics: true,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              icon: Icon(
                dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: dark ? Colors.white : AppColors.ink900,
                size: 18,
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                SoundService.instance.playClick();
                context.read<ThemeBloc>().add(const ThemeModeToggled());
              },
            ),
          ),
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
        return MergeSemantics(
          child: Semantics(
            button: true,
            toggled: enabled,
            label: enabled ? 'Mute sound effects' : 'Enable sound effects',
            child: _Puck(
              dark: dark,
              child: Tooltip(
                message: enabled
                    ? 'Sound Effects: ON (Click to mute)'
                    : 'Sound Effects: MUTED (Click to enable)',
                excludeFromSemantics: true,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 40, minHeight: 40),
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        enabled
                            ? Icons.volume_up_rounded
                            : Icons.volume_off_rounded,
                        color: enabled
                            ? (dark ? Colors.white : AppColors.ink900)
                            : (dark
                                ? Colors.white.withValues(alpha: 0.60)
                                : AppColors.ink400),
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
                              color: AppColors.teal,
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
            ),
          ),
        );
      },
    );
  }
}
