import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/utils/bidi.dart';

/// One labelled line of prose: a quiet label, then the sentence. Used for
/// the Problem / System / My role rows on Work cards and the Challenge /
/// Impact rows on Experience cards.
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 76,
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: AppTypography.label,
                height: 1.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: context.mutedText,
              ),
            ),
          ),
          Expanded(
            child: Text(
              ltrContent(context, text),
              maxLines: maxLines,
              overflow: maxLines == null ? null : TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppTypography.label,
                height: 1.5,
                color: context.onSurface.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
