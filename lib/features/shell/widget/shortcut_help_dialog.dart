import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/tokens.dart';

/// Modal listing keyboard shortcuts (digits, arrows, Home/End, ?).
/// Called from `KeyboardHintChip` and the `?` key handler.
Future<void> showShortcutHelpDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final scheme = Theme.of(context).colorScheme;
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (ctx) {
      return Dialog(
        // Opaque: the themed glass dialog let the page behind (headline,
        // buttons) read straight through the shortcut list.
        backgroundColor: Theme.of(ctx).brightness == Brightness.dark
            ? AppColors.darkSurfaceElevated
            : AppColors.lightSurface,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.keyboard_alt_outlined,
                        size: 22, color: scheme.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        l10n.keyboardHintTitle,
                        style: const TextStyle(
                          fontSize: AppTypography.body + 1,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      tooltip: l10n.closeTooltip,
                      onPressed: () {
                        SoundService.instance.playClick();
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.smd),
                _shortcutRow(
                    scheme, _keyText(scheme, '1–7'), l10n.keyboardHintDigits),
                // Icons, not '↑ ↓': Roboto has no arrow glyphs, so the text pulled
                // a 68 KB Noto Sans Symbols fallback font at runtime.
                _shortcutRow(
                    scheme,
                    _keyIcons(scheme, const [
                      Icons.arrow_upward_rounded,
                      Icons.arrow_downward_rounded,
                    ]),
                    l10n.keyboardHintArrows),
                _shortcutRow(
                    scheme, _keyText(scheme, 'Home'), l10n.keyboardHintHome),
                _shortcutRow(
                    scheme, _keyText(scheme, 'End'), l10n.keyboardHintEnd),
                _shortcutRow(
                    scheme, _keyText(scheme, '?'), l10n.showHelpShortcut),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _keyText(ColorScheme scheme, String key) => Text(
      key,
      style: TextStyle(
        fontFamily: AppTypography.monoFont,
        color: scheme.primary,
        fontSize: AppTypography.overline,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.5,
      ),
    );

Widget _keyIcons(ColorScheme scheme, List<IconData> icons) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final icon in icons)
          Icon(icon, size: AppTypography.overline + 3, color: scheme.primary),
      ],
    );

Widget _shortcutRow(ColorScheme scheme, Widget keyCap, String label) {
  return Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Row(
      children: [
        Container(
          width: 56,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: AppAlpha.hover),
            borderRadius: BorderRadius.circular(AppRadius.chip),
            border: Border.all(
              color: scheme.primary.withValues(alpha: AppAlpha.border),
            ),
          ),
          alignment: Alignment.center,
          child: keyCap,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.85),
              fontSize: AppTypography.small,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}
