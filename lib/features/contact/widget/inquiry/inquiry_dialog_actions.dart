import 'package:flutter/material.dart';
import 'package:profile/theme/tokens.dart';

class InquiryDialogActions extends StatelessWidget {
  final bool canSend;
  final bool isSending;
  final VoidCallback onCopy;
  final VoidCallback onSend;

  const InquiryDialogActions({
    super.key,
    required this.canSend,
    this.isSending = false,
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
          label: const Text('COPY DRAFT'),
        ),
        FilledButton.icon(
          onPressed: (canSend && !isSending) ? onSend : null,
          icon: isSending
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.send_rounded, size: 16),
          label: Text(isSending ? 'SENDING...' : 'SEND SECURE MESSAGE'),
        ),
      ],
    );
  }
}
