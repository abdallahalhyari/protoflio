import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/utils/bidi.dart';

/// One labelled line of prose: a quiet label above its sentence. Used for
/// the Problem / System / My role rows on Work cards. The label sits on
/// its own line so the sentence gets the card's full width.
class LabeledLine extends StatelessWidget {
  const LabeledLine({
    super.key,
    required this.label,
    required this.text,
    this.maxLines,
  });

  final String label;
  final String text;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppTypography.label,
              height: 1.4,
              fontWeight: FontWeight.w600,
              color: context.mutedText,
            ),
          ),
          Text(
            ltrContent(context, text),
            maxLines: maxLines,
            overflow: maxLines == null ? null : TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: AppTypography.label + 1,
              height: 1.5,
              color: context.onSurface.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
