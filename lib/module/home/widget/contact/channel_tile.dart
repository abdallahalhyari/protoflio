import 'package:flutter/material.dart';

import '../../../../theme/surface_tone.dart';
import '../../../../theme/tokens.dart';

class ChannelData {
  final String badge;
  final Color badgeColor;
  final String label;
  final String value;
  final IconData icon;
  final String primaryLabel;
  final VoidCallback primaryAction;
  final String secondaryLabel;
  final VoidCallback secondaryAction;
  final Color accent;

  const ChannelData({
    required this.badge,
    required this.badgeColor,
    required this.label,
    required this.value,
    required this.icon,
    required this.primaryLabel,
    required this.primaryAction,
    required this.secondaryLabel,
    required this.secondaryAction,
    required this.accent,
  });
}

/// Compact tile shown in the 2x2 channels grid. Combines an accent
/// icon puck, label + value, and two inline actions (primary / secondary).
class ChannelTile extends StatefulWidget {
  final ChannelData data;

  const ChannelTile({super.key, required this.data});

  @override
  State<ChannelTile> createState() => _ChannelTileState();
}

class _ChannelTileState extends State<ChannelTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final isDark = context.isDarkMode;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: AppMotion.chipHover,
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark
              ? (_hover
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.white.withValues(alpha: 0.03))
              : (_hover ? Colors.white : AppColors.slate50),
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: _hover
                ? d.accent.withValues(alpha: 0.55)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.10)
                    : AppColors.slate200),
            width: _hover ? 1.4 : 1,
          ),
          boxShadow: [
            if (_hover)
              BoxShadow(
                color: d.accent.withValues(alpha: isDark ? 0.18 : 0.10),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: d.accent.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(AppRadius.smd),
                    border: Border.all(
                      color: d.accent.withValues(alpha: 0.45),
                    ),
                  ),
                  child: Icon(d.icon, size: 20, color: d.accent),
                ),
                const SizedBox(width: AppSpacing.smd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        d.label,
                        style: TextStyle(
                          color: d.accent,
                          fontSize: AppTypography.editorialSm,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        d.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark ? Colors.white : AppColors.slate900,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.smd),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: d.primaryAction,
                    style: FilledButton.styleFrom(
                      backgroundColor: d.accent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                    ),
                    child: Text(
                      d.primaryLabel.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                OutlinedButton(
                  onPressed: d.secondaryAction,
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        isDark ? Colors.white : AppColors.slate900,
                    side: BorderSide(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.28)
                          : AppColors.slate300,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                  child: Text(
                    d.secondaryLabel.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
