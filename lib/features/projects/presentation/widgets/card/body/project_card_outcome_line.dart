import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/utils/bidi.dart';

class CardOutcomeLine extends StatelessWidget {
  const CardOutcomeLine({
    super.key,
    required this.text,
    required this.scheme,
    required this.isDark,
    this.maxLines = 2,
  });

  final String text;
  final ColorScheme scheme;
  final bool isDark;

  /// Null lets the line wrap in full, for cards that size to content.
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final accent = isDark
        ? scheme.primary
        : AppColors.toAccessibleLightText(scheme.primary);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          margin: const EdgeInsets.only(top: 1),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: isDark ? 0.15 : 0.10),
            borderRadius: BorderRadius.circular(AppRadius.xs),
            border: Border.all(
                color: accent.withValues(alpha: isDark ? 0.35 : 0.25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.trending_up_rounded, size: 10, color: accent),
              const SizedBox(width: 4),
              Text(
                'IMPACT',
                style: TextStyle(
                  color: accent,
                  fontSize: AppTypography.label,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            ltrContent(context, text),
            maxLines: maxLines,
            overflow: maxLines == null ? null : TextOverflow.ellipsis,
            style: TextStyle(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.95)
                  : AppColors.ink800,
              fontSize: AppTypography.label + 1,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
