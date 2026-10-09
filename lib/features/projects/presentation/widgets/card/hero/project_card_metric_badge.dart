import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';

class CardMetricBadge extends StatelessWidget {
  const CardMetricBadge({
    super.key,
    required this.text,
    required this.primary,
  });

  final String text;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppSpacing.sm,
      left: AppSpacing.sm,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(AppRadius.xs),
          border: Border.all(
            color: primary.withValues(alpha: 0.75),
          ),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.40),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.6),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Icon(Icons.verified_rounded, size: 12, color: primary),
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(
                fontFamily: AppTypography.monoFont,
                color: Colors.white,
                fontSize: AppTypography.label,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
