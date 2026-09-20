import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';

/// Desktop bottom-right keyboard-hint chip. Renders a small kbd-icon
/// puck with a rich tooltip listing all keyboard shortcuts. Tapping
/// invokes [onShowHelp] — the parent typically opens a dialog.
class KeyboardHintChip extends StatelessWidget {
  const KeyboardHintChip({super.key, required this.onShowHelp});

  final VoidCallback onShowHelp;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      button: true,
      label: '${l10n.keyboardHintTitle}. Tap to view keyboard shortcuts.',
      child: Tooltip(
        preferBelow: false,
        richMessage: TextSpan(
          style: const TextStyle(fontSize: AppTypography.overline, height: 1.5, color: Colors.white),
          children: [
            TextSpan(
                text: '${l10n.keyboardHintTitle}\n',
                style: const TextStyle(fontWeight: FontWeight.w900)),
            TextSpan(text: '${l10n.keyboardHintDigits}\n'),
            TextSpan(text: '${l10n.keyboardHintArrows}\n'),
            TextSpan(text: '${l10n.keyboardHintHome}\n'),
            TextSpan(text: l10n.keyboardHintEnd),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkResponse(
            radius: 22,
            onTap: () {
              SoundService.instance.playClick();
              HapticFeedback.selectionClick();
              onShowHelp();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                color: context.glassSurface,
                border: Border.all(color: context.glassBorderStrong, width: 1),
                boxShadow: isDark
                    ? null
                    : [
                        BoxShadow(
                          color: AppColors.shadowSoft,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.keyboard_alt_outlined,
                    size: 14,
                    color: context.mutedText,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'SHORTCUTS [?]',
                    style: TextStyle(
                      fontFamily: AppTypography.monoFont,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: context.mutedText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
