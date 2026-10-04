import 'package:flutter/material.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

class AppBarAudioToggle extends StatelessWidget {
  const AppBarAudioToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return ValueListenableBuilder<bool>(
      valueListenable: SoundService.instance.isEnabled,
      builder: (_, enabled, __) {
        return MergeSemantics(
          child: Semantics(
            button: true,
            toggled: enabled,
            label: enabled ? 'Mute sound effects' : 'Enable sound effects',
            child: Tooltip(
              message: enabled ? 'Mute sound effects' : 'Enable sound effects',
              excludeFromSemantics: true,
              child: IconButton(
                iconSize: 18,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                icon: Icon(
                  enabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                  color: enabled
                      ? AppColors.accentAmber
                      : (isDark ? Colors.white38 : AppColors.slate400),
                ),
                onPressed: SoundService.instance.toggle,
              ),
            ),
          ),
        );
      },
    );
  }
}
