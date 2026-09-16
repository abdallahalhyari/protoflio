import 'package:flutter/material.dart';
import '../../../theme/surface_tone.dart';
import '../../../theme/tokens.dart';

/// Semantic tone → color slot mapping for EditorialChip.
enum ChipTone { primary, amber, green, sky, indigo, neutral }

/// Fill treatment.
enum ChipVariant { filled, outline, glass }

/// Shared pill-shaped chip used across the portfolio (status pills,
/// meta labels, tag chips, kicker badges). Replaces the ~40+ hand-rolled
/// `Container(padding, decoration, Row(icon, text))` clones that used to
/// live in projects / contact / hats / engineering pages.
class EditorialChip extends StatelessWidget {
  const EditorialChip({
    super.key,
    required this.label,
    this.icon,
    this.trailing,
    this.tone = ChipTone.primary,
    this.variant = ChipVariant.filled,
    this.dense = false,
    this.onTap,
  });

  final String label;
  final IconData? icon;
  final Widget? trailing;
  final ChipTone tone;
  final ChipVariant variant;

  /// Slightly tighter padding and font size — useful in dense meta rows.
  final bool dense;

  final VoidCallback? onTap;

  Color _toneColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;
    switch (tone) {
      case ChipTone.primary:
        return scheme.primary;
      case ChipTone.amber:
        return isDark ? AppColors.accentAmber : AppColors.accentAmberDeep;
      case ChipTone.green:
        return isDark ? AppColors.accentGreen : AppColors.accentGreenDeep;
      case ChipTone.sky:
        return isDark ? AppColors.accentSky : AppColors.accentSkyDeep;
      case ChipTone.indigo:
        return isDark ? AppColors.accentIndigo : AppColors.accentIndigoDeepText;
      case ChipTone.neutral:
        return isDark
            ? scheme.onSurface.withValues(alpha: 0.7)
            : AppColors.slate700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tint = _toneColor(context);
    final isDark = context.isDarkMode;

    Color bg;
    Color border;
    Color fg;
    switch (variant) {
      case ChipVariant.filled:
        bg = tint.withValues(alpha: isDark ? 0.18 : 0.14);
        border = tint.withValues(alpha: isDark ? 0.5 : 0.4);
        fg = tint;
        break;
      case ChipVariant.outline:
        bg = Colors.transparent;
        border = tint.withValues(alpha: isDark ? 0.6 : 0.5);
        fg = tint;
        break;
      case ChipVariant.glass:
        bg = isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.85);
        border = isDark
            ? Colors.white.withValues(alpha: 0.12)
            : AppColors.slate200;
        fg = isDark ? Colors.white : AppColors.slate900;
        break;
    }

    final hPad = dense ? 8.0 : 10.0;
    final vPad = dense ? 3.0 : 5.0;
    final fontSize = dense ? AppTypography.editorialSm : AppTypography.editorial;

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: fontSize + 2, color: fg),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: fg,
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 6),
          trailing!,
        ],
      ],
    );

    final decorated = Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: border, width: 1),
      ),
      child: row,
    );

    if (onTap == null) return decorated;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: decorated,
      ),
    );
  }
}
