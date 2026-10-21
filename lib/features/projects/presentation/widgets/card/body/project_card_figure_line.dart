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
    this.stacked = false,
  });

  final String? value;
  final String label;
  final ColorScheme scheme;
  final bool isDark;
  final int? maxLines;

  /// Number above the sentence instead of beside it, for narrow cards
  /// where the sentence would shrink to a word a line.
  final bool stacked;

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
        child: Builder(
          builder: (context) {
            Widget figureText(double maxWidth) => ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: maxWidth < 44 ? maxWidth : 44,
                    maxWidth: maxWidth,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      ltrContent(context, value!),
                      style: TextStyle(
                        fontSize: AppTypography.heading,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                        color: figureColor,
                        letterSpacing: -0.5,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                );
            if (stacked) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  figureText(double.infinity),
                  const SizedBox(height: 4),
                  text,
                ],
              );
            }
            return Row(
              children: [
                figureText(88),
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
            );
          },
        ),
      ),
    );
  }
}
