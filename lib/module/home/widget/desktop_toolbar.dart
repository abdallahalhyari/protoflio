import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profile/locale_controller.dart';

import '../../../service/sound_service.dart';
import '../../../theme/tokens.dart';
import '../../../theme_controller.dart';

/// Top-right desktop toolbar — language picker, theme toggle, audio
/// mute. Self-contained: reads its own state from
/// [ThemeController.mode], [LocaleController.locale], and
/// [SoundService.instance.isEnabled].
class DesktopToolbar extends StatelessWidget {
  const DesktopToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (_, mode, __) {
        final dark = mode == ThemeMode.dark;
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
      shape: const CircleBorder(),
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
      child: ValueListenableBuilder<Locale>(
        valueListenable: LocaleController.locale,
        builder: (context, locale, _) {
          return PopupMenuButton<String>(
            tooltip: 'Change Language',
            icon: Icon(Icons.language,
                color: dark ? Colors.white : AppColors.slate900),
            onSelected: (val) {
              HapticFeedback.lightImpact();
              LocaleController.changeLocale(val);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'en', child: Text('English')),
              PopupMenuItem(value: 'ar', child: Text('العربية')),
              PopupMenuItem(value: 'cs', child: Text('Čeština')),
            ],
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
      toggled: dark,
      label: 'Dark mode',
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
            ThemeController.toggle();
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
        return _Puck(
          dark: dark,
          child: IconButton(
            tooltip: enabled ? 'Mute ambient audio' : 'Enable ambient audio',
            icon: Icon(
              enabled ? Icons.volume_up : Icons.volume_off,
              color: enabled
                  ? (dark ? Colors.white : AppColors.slate900)
                  : (dark
                      ? Colors.white.withValues(alpha: 0.60)
                      : AppColors.slate400),
              size: 18,
            ),
            onPressed: () {
              SoundService.instance.toggle();
            },
          ),
        );
      },
    );
  }
}
