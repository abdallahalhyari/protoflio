import 'package:flutter/material.dart';

import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';

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
    // Light mode fills with the deep tone the label uses; dark mode keeps
    // the bright accent. Either way the text is picked for contrast: white
    // on the bright indigo and violet was 3.0:1 and 4.2:1.
    final buttonFill = isDark ? d.accent : labelColor;
    final buttonTextColor = AppColors.onAccent(buttonFill);

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
                          color: context.onSurface,
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
                  child: MergeSemantics(
                      child: Semantics(
                    button: true,
                    label: '${d.label}: ${d.primaryLabel}',
                    child: FilledButton(
                      onPressed: d.primaryAction,
                      style: FilledButton.styleFrom(
                        backgroundColor: buttonFill,
                        foregroundColor: buttonTextColor,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                      ),
                      child: Text(
                        d.primaryLabel.toUpperCase(),
                        semanticsLabel: '',
                        style: const TextStyle(
                          fontSize: AppTypography.caption,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
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
                  child: OutlinedButton(
                    onPressed: d.secondaryAction,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.onSurface,
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
                      semanticsLabel: '',
                      style: const TextStyle(
                        fontSize: AppTypography.caption,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
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
