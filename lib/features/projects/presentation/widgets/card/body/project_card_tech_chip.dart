import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/core/theme/surface_tone.dart';

class CardTechTagChip extends StatefulWidget {
  final String tag;
  final bool isSelected;
  final ColorScheme scheme;
  final bool isDark;
  final VoidCallback? onTap;

  const CardTechTagChip({
    super.key,
    required this.tag,
    required this.isSelected,
    required this.scheme,
    required this.isDark,
    this.onTap,
  });

  @override
  State<CardTechTagChip> createState() => _CardTechTagChipState();
}

class _CardTechTagChipState extends State<CardTechTagChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.isSelected
        ? widget.scheme.primary.withValues(alpha: widget.isDark ? 0.25 : 0.15)
        : (widget.isDark
            ? Colors.white.withValues(alpha: AppAlpha.whisper)
            : AppColors.ink100);

    final border =
        widget.isSelected ? widget.scheme.primary : (context.divider);

    final text = widget.isSelected
        ? (widget.isDark
            ? widget.scheme.primary
            : AppColors.toAccessibleLightText(widget.scheme.primary))
        : (widget.isDark ? Colors.white70 : AppColors.ink700);

    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final animDuration = reduceMotion ? Duration.zero : AppMotion.snap;

    return Semantics(
      button: widget.onTap != null,
      selected: widget.isSelected,
      label: widget.onTap != null
          ? 'Show case studies using ${widget.tag}'
          : widget.tag,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedScale(
          scale: _isHovered && widget.onTap != null ? 1.05 : 1.0,
          duration: animDuration,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(AppRadius.xs),
            child: AnimatedContainer(
              duration: animDuration,
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4.5),
              decoration: BoxDecoration(
                color: _isHovered && widget.onTap != null
                    ? widget.scheme.primary
                        .withValues(alpha: widget.isDark ? 0.35 : 0.25)
                    : bg,
                borderRadius: BorderRadius.circular(AppRadius.xs),
                border: Border.all(
                  color: _isHovered && widget.onTap != null
                      ? widget.scheme.primary
                      : border,
                  width: widget.isSelected ? 1.2 : 0.8,
                ),
              ),
              child: Text(
                widget.tag,
                semanticsLabel: '',
                style: TextStyle(
                  color: _isHovered && widget.onTap != null && !widget.isDark
                      ? AppColors.toAccessibleLightText(widget.scheme.primary)
                      : text,
                  fontSize: AppTypography.label,
                  fontWeight: widget.isSelected || _isHovered
                      ? FontWeight.w900
                      : FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
