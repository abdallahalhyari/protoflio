import 'package:flutter/material.dart';

import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';

class SocialChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const SocialChip({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 14),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: AppTypography.caption,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.6,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: isDark ? Colors.white : AppColors.slate900,
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.35)
              : AppColors.slate300,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),
    );
  }
}
