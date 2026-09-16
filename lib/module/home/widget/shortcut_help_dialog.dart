import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import '../../../theme/tokens.dart';

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
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      tooltip: l10n.closeTooltip,
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.smd),
                _shortcutRow(scheme, '1–7', l10n.keyboardHintDigits),
                _shortcutRow(scheme, '↑ ↓', l10n.keyboardHintArrows),
                _shortcutRow(scheme, 'Home', l10n.keyboardHintHome),
                _shortcutRow(scheme, 'End', l10n.keyboardHintEnd),
                _shortcutRow(scheme, '?', l10n.showHelpShortcut),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _shortcutRow(ColorScheme scheme, String key, String label) {
  return Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Row(
      children: [
        Container(
          width: 56,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.chip),
            border: Border.all(
              color: scheme.primary.withValues(alpha: 0.35),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            key,
            style: TextStyle(
              fontFamily: 'Courier',
              color: scheme.primary,
              fontSize: AppTypography.overline,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
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
