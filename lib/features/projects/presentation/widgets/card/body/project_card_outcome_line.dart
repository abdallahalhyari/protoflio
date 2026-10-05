import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/utils/bidi.dart';

class CardOutcomeLine extends StatelessWidget {
  const CardOutcomeLine({
    super.key,
    required this.text,
    required this.scheme,
    required this.isDark,
  });

  final String text;
  final ColorScheme scheme;
  final bool isDark;

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
                  fontFamily: AppTypography.monoFont,
                  color: accent,
                  fontSize: AppTypography.nano,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            ltrContent(context, text),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.95)
                  : AppColors.slate800,
              fontSize: AppTypography.caption + 1,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
