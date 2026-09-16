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

  Color _adaptiveAccent(BuildContext context, Color color) {
    final isDark = context.isDarkMode;
    if (isDark) return color;
    if (color.toARGB32() == 0xFF38BDF8) return AppColors.accentSkyDeep;
    if (color.toARGB32() == 0xFF34D399) return AppColors.accentGreenDeep;
    if (color.toARGB32() == 0xFF818CF8) return AppColors.accentIndigoDeepText;
    if (color.toARGB32() == 0xFF8B5CF6) return AppColors.accentVioletDeep;
    return color;
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final isDark = context.isDarkMode;
    final labelColor = _adaptiveAccent(context, d.accent);
    final buttonTextColor = d.accent.computeLuminance() > 0.35 ? Colors.black : Colors.white;

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
                    color: d.accent.withValues(alpha: isDark ? 0.14 : 0.10),
                    borderRadius: BorderRadius.circular(AppRadius.smd),
                    border: Border.all(
                      color: d.accent.withValues(alpha: isDark ? 0.45 : 0.35),
                    ),
                  ),
                  child: Icon(d.icon, size: 20, color: labelColor),
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
                          color: labelColor,
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
                          fontSize: AppTypography.smallLoose,
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
                      foregroundColor: buttonTextColor,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                    ),
                    child: Text(
                      d.primaryLabel.toUpperCase(),
                      style: const TextStyle(
                        fontSize: AppTypography.caption,
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
                      fontSize: AppTypography.caption,
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
