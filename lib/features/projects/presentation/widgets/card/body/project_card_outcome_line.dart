import 'package:flutter/material.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/shared/util/bidi.dart';

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
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(Icons.trending_up_rounded, size: 15, color: accent),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            ltrContent(context, text),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.88)
                  : AppColors.slate800,
              fontSize: AppTypography.caption + 1,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
