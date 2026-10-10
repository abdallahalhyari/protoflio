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
        fontSize: AppTypography.body - 1,
        height: 1.35,
      ),
    );
    if (value == null) return text;

    return Semantics(
      label: '$value $label',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.035)
              : AppColors.ink100.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppRadius.xs),
          border: Border.all(
            color: isDark
                ? figureColor.withValues(alpha: 0.25)
                : figureColor.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 44, maxWidth: 88),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  ltrContent(context, value!),
                  style: TextStyle(
                    fontFamily: AppTypography.monoFont,
                    fontSize: AppTypography.heading,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                    color: figureColor,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 1,
              height: 24,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.12)
                  : AppColors.ink200,
            ),
            const SizedBox(width: 10),
            Expanded(child: text),
          ],
        ),
      ),
    );
  }
}
