import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';

/// Pill-shaped hint telling touch users a horizontal switcher is available.
/// Replaces the near-identical inline widgets that used to live in
/// projects_page / engineering_page / skills_page.
class SwipeAffordance extends StatelessWidget {
  const SwipeAffordance({
    super.key,
    required this.label,
    this.icon = Icons.swipe_outlined,
    this.margin,
  });

  final String label;
  final IconData icon;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;

    return Container(
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 13, color: scheme.primary.withValues(alpha: 0.8)),
          const SizedBox(width: 6),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.65)
                      : const Color(0xFF64748B),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
