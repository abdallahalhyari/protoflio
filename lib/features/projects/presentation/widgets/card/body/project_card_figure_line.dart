import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/utils/bidi.dart';

/// A card's result: one large figure with a sentence beside it. With no
/// [value] the sentence stands alone.
class CardFigureLine extends StatelessWidget {
  const CardFigureLine({
    super.key,
    required this.label,
    required this.scheme,
    required this.isDark,
    this.value,
    this.maxLines,
  });

  final String? value;
  final String label;
  final ColorScheme scheme;
  final bool isDark;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final figureColor = isDark ? AppColors.goldSoft : AppColors.goldDeep;
    final text = Text(
      ltrContent(context, label),
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      style: TextStyle(
        color: context.onSurface.withValues(alpha: isDark ? 0.9 : 0.85),
        fontSize: AppTypography.body,
        height: 1.4,
      ),
    );
    if (value == null) return text;

    return Semantics(
      label: '$value $label',
      excludeSemantics: true,
      child: Row(
        children: [
          SizedBox(
            // One width for every card, so the sentences line up.
            width: 128,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                ltrContent(context, value!),
                style: TextStyle(
                  fontSize: AppTypography.heading,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  color: figureColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: text),
        ],
      ),
    );
  }
}
