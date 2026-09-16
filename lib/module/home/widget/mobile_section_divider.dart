import 'package:flutter/material.dart';

import '../../../theme/surface_tone.dart';
import '../../../theme/tokens.dart';

/// Between-section divider chip on mobile continuous scroll —
/// "02 · EXPERIENCE" style label with a fading horizontal rule.
class MobileSectionDivider extends StatelessWidget {
  const MobileSectionDivider({
    super.key,
    required this.number,
    required this.title,
  });

  final String number;
  final String title;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.xs),
              border: Border.all(color: context.glassBorder),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: AppColors.shadowSoft,
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
            ),
            child: Text(
              number,
              style: const TextStyle(
                color: AppColors.accentIndigo,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              color: context.subtleText,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          Colors.white.withValues(alpha: 0.25),
                          Colors.white.withValues(alpha: 0.02),
                        ]
                      : [
                          AppColors.slate300,
                          AppColors.slate200.withValues(alpha: 0.0),
                        ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
