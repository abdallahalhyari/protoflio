import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/l10n/app_localizations.dart';

class InquiryDialogActions extends StatelessWidget {
  final bool canSend;
  final bool isSending;

  /// True when messages go straight through EmailJS; false when the button
  /// opens the visitor's email app with the draft.
  final bool sendsDirectly;
  final VoidCallback onCopy;
  final VoidCallback onSend;

  const InquiryDialogActions({
    super.key,
    required this.canSend,
    this.isSending = false,
    this.sendsDirectly = false,
    required this.onCopy,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      children: [
        OutlinedButton.icon(
          onPressed: canSend ? onCopy : null,
          icon: const Icon(Icons.copy_rounded, size: 16),
          label: Text(AppLocalizations.of(context)!.uiCopyDraft),
        ),
        FilledButton.icon(
          onPressed: (canSend && !isSending) ? onSend : null,
          icon: isSending
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  sendsDirectly
                      ? Icons.send_rounded
                      : Icons.mail_outline_rounded,
                  size: 16,
                ),
          label: Text(
            isSending
                ? AppLocalizations.of(context)!.uiSending
                : (sendsDirectly
                    ? AppLocalizations.of(context)!.uiSendMessage
                    : AppLocalizations.of(context)!.uiOpenEmailClient),
          ),
        ),
      ],
    );
  }
}
