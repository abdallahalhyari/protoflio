import 'package:flutter/material.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

class SocialChip extends StatefulWidget {
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
  State<SocialChip> createState() => _SocialChipState();
}

class _SocialChipState extends State<SocialChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final primary = Theme.of(context).colorScheme.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.05 : 1.0,
        duration: AppMotion.chipHover,
        curve: AppMotion.emphasized,
        child: OutlinedButton.icon(
          onPressed: widget.onTap,
          icon: Icon(widget.icon, size: 14),
          label: Text(
            widget.label,
            style: const TextStyle(
              fontSize: AppTypography.label,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.6,
            ),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: _hovered ? primary : context.onSurface,
            side: BorderSide(
              color: _hovered
                  ? primary.withValues(alpha: isDark ? 0.75 : 0.6)
                  : (isDark
                      ? Colors.white.withValues(alpha: AppAlpha.border)
                      : AppColors.ink300),
              width: _hovered ? 1.4 : 1.0,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
        ),
      ),
    );
  }
}
