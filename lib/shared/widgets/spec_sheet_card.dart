import 'package:flutter/material.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

/// Label/value blocks stacked in one card with hairline rules between
/// them, start-aligned. Used on mobile where the desktop layout puts the
/// same blocks in a row: centred in a Wrap as separate chips, blocks of
/// different widths stacked into a ragged pyramid.
class SpecSheetCard extends StatefulWidget {
  const SpecSheetCard({
    super.key,
    required this.rows,
    this.margin,
    this.lightLineColor = AppColors.ink200,
  });

  final List<Widget> rows;
  final EdgeInsetsGeometry? margin;

  /// Border and row-rule colour in light mode. The intro keeps its own
  /// palette, so it passes `IntroColors.slate200`.
  final Color lightLineColor;

  @override
  State<SpecSheetCard> createState() => _SpecSheetCardState();
}

class _SpecSheetCardState extends State<SpecSheetCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final primary = Theme.of(context).colorScheme.primary;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final borderColor = _isHovered
        ? primary.withValues(alpha: isDark ? 0.4 : 0.5)
        : (isDark
            ? Colors.white.withValues(alpha: 0.1)
            : widget.lightLineColor);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: reduceMotion ? Duration.zero : AppMotion.micro,
        curve: Curves.easeOutCubic,
        margin: widget.margin,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: borderColor,
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: isDark
              ? (_isHovered
                  ? [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.12),
                        blurRadius: 12,
                        spreadRadius: 1,
                      )
                    ]
                  : null)
              : [
                  BoxShadow(
                    color: _isHovered
                        ? primary.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.04),
                    blurRadius: _isHovered ? 8 : 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < widget.rows.length; i++) ...[
              if (i > 0)
                Container(
                  height: 1,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : widget.lightLineColor,
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.smd, vertical: 10),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: widget.rows[i],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
