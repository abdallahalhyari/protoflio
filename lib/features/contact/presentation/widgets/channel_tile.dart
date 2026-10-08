import 'package:flutter/material.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/utils/bidi.dart';
import 'package:profile/shared/widgets/magnetic_pull.dart';

class ChannelData {
  final String label;
  final String value;
  final IconData icon;
  final String primaryLabel;
  final VoidCallback primaryAction;
  final String secondaryLabel;
  final VoidCallback secondaryAction;
  final Color accent;

  const ChannelData({
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
    final labelColor = context.adaptiveAccentText(d.accent);
    // Tonal, not solid: four saturated sky/green/indigo/violet fills
    // outranked the hero email card's Send Email, the section's real
    // primary action. The tint matches the icon chip; the label keeps the
    // contrast-checked accent text colour. Hover fills it in.
    final buttonFill = d.accent.withValues(
        alpha: _hover ? (isDark ? 0.24 : 0.18) : (isDark ? 0.14 : 0.10));
    final buttonTextColor = labelColor;

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
                  ? Colors.white.withValues(alpha: AppAlpha.whisper)
                  : Colors.white.withValues(alpha: 0.03))
              : (_hover ? Colors.white : AppColors.ink50),
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: _hover
                ? d.accent.withValues(alpha: 0.55)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.10)
                    : AppColors.ink200),
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
                          fontSize: AppTypography.label,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ltrAlways(context, d.value),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: context.onSurface,
                          fontSize: AppTypography.body,
                          fontWeight: FontWeight.w700,
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
                  child: MergeSemantics(
                      child: Semantics(
                    button: true,
                    label: '${d.label}: ${d.primaryLabel}',
                    child: MagneticPull(
                      maxPull: 6.0, // Less pull for these smaller tiles
                      child: FilledButton(
                        onPressed: d.primaryAction,
                        style: FilledButton.styleFrom(
                          backgroundColor: buttonFill,
                          foregroundColor: buttonTextColor,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            side: BorderSide(
                              color: d.accent
                                  .withValues(alpha: isDark ? 0.45 : 0.35),
                            ),
                          ),
                        ),
                        child: Text(
                          d.primaryLabel,
                          semanticsLabel: '',
                          style: const TextStyle(
                            fontSize: AppTypography.label,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  )),
                ),
                const SizedBox(width: AppSpacing.sm),
                MergeSemantics(
                    child: Semantics(
                  button: true,
                  label: '${d.label}: ${d.secondaryLabel}',
                  child: MagneticPull(
                    maxPull: 6.0,
                    child: OutlinedButton(
                      onPressed: d.secondaryAction,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.onSurface,
                        side: BorderSide(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.28)
                              : AppColors.ink300,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                      ),
                      child: Text(
                        d.secondaryLabel,
                        semanticsLabel: '',
                        style: const TextStyle(
                          fontSize: AppTypography.label,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
