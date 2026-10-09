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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.78),
          borderRadius: BorderRadius.circular(AppRadius.xs),
          border: Border.all(
            color: primary.withValues(alpha: 0.65),
          ),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.35),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified_rounded, size: 12, color: primary),
            const SizedBox(width: 5),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: AppTypography.label,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
