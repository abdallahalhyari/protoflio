import 'package:flutter/material.dart';

import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';

/// A single outcome metric — big number + short caption.
class OutcomeCard extends StatelessWidget {
  const OutcomeCard({super.key, required this.headline, required this.body});

  final String headline;
  final String body;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;
    return Semantics(
      container: true,
      label: 'Key outcome metric: $headline. $body',
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.04)
              : Colors.white.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: scheme.primary.withValues(alpha: isDark ? 0.18 : 0.22),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                headline,
                style: TextStyle(
                  fontFamily: AppTypography.displayFont,
                  fontSize: AppTypography.statDisplay,
                  fontWeight: FontWeight.w900,
                  color: scheme.primary,
                  height: 1.0,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              body,
              style: TextStyle(
                fontSize: AppTypography.small,
                height: 1.35,
                color: scheme.onSurface.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Grid of `OutcomeCard` — 4 columns desktop, 2 on mobile, each row as
/// tall as its tallest card.
class OutcomeGrid extends StatelessWidget {
  const OutcomeGrid({
    super.key,
    required this.isDesktop,
    required this.items,
  });

  final bool isDesktop;
  final List<(String, String)> items;

  @override
  Widget build(BuildContext context) {
    final cols = isDesktop ? 4 : 2;
    // Rows sized to their tallest card: a fixed aspect-ratio grid left the
    // desktop cards ~200px tall around ~60px of content.
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += cols) {
      final row = items.skip(i).take(cols).toList();
      if (rows.isNotEmpty) rows.add(const SizedBox(height: AppSpacing.md));
      rows.add(IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var j = 0; j < cols; j++) ...[
              if (j > 0) const SizedBox(width: AppSpacing.md),
              Expanded(
                child: j < row.length
                    ? OutcomeCard(headline: row[j].$1, body: row[j].$2)
                    : const SizedBox.shrink(),
              ),
            ],
          ],
        ),
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}
