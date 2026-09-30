import 'package:flutter/material.dart';
import 'package:profile/theme/tokens.dart';

class InquiryDialogActions extends StatelessWidget {
  final bool canSend;
  final VoidCallback onCopy;
  final VoidCallback onSend;

  const InquiryDialogActions({
    super.key,
    required this.canSend,
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
          onPressed: canSend ? onSend : null,
          icon: const Icon(Icons.mail_outline_rounded, size: 16),
          label: const Text('OPEN IN EMAIL CLIENT'),
        ),
      ],
    );
  }
}
