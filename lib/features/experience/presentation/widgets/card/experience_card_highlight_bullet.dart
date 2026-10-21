import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/utils/bidi.dart';

/// One achievement under a role, marked with a short teal rule (the
/// timeline spine's colour). Every highlight carries the same weight:
/// none is singled out in a gold lead-in.
class HighlightBullet extends StatelessWidget {
  const HighlightBullet({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final rule = context.isDarkMode ? AppColors.tealLight : AppColors.teal;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 10, end: 10),
            child: Container(width: 8, height: 1.5, color: rule),
          ),
          Expanded(
            child: Text(
              ltrContent(context, text),
              style: TextStyle(
                color: context.onSurface,
                fontSize: AppTypography.body,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
