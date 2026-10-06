import 'package:flutter/material.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

/// Label/value blocks stacked in one card with hairline rules between
/// them, start-aligned. Used on mobile where the desktop layout puts the
/// same blocks in a row: centred in a Wrap as separate chips, blocks of
/// different widths stacked into a ragged pyramid.
class SpecSheetCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : lightLineColor,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              Container(
                height: 1,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : lightLineColor,
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.smd, vertical: 10),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: rows[i],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
