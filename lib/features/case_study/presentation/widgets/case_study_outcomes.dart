import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

/// A single outcome figure: the number, its caption under it, a rule
/// above. Not a card: nothing here is tappable.
class OutcomeCard extends StatelessWidget {
  const OutcomeCard({super.key, required this.headline, required this.body});

  final String headline;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label:
          AppLocalizations.of(context)!.studyOutcomeSemantics(headline, body),
      child: Container(
        padding: const EdgeInsets.only(top: AppSpacing.smd),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: context.divider)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                headline,
                // Metrics ("< 1s", "-35%") are left-to-right tokens; inside
                // an Arabic line the sign would jump to the wrong end.
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontSize: AppTypography.display,
                  fontWeight: FontWeight.w700,
                  color: context.onSurface,
                  height: 1.1,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              body,
              style: TextStyle(
                fontSize: AppTypography.body,
                height: 1.45,
                color: context.mutedText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Outcome figures in a row of four on desktop, two by two on mobile.
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
    // As many columns as figures on desktop, up to four.
    final cols = isDesktop ? items.length.clamp(1, 4) : 2;
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += cols) {
      final row = items.skip(i).take(cols).toList();
      if (rows.isNotEmpty) rows.add(const SizedBox(height: AppSpacing.lg));
      rows.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var j = 0; j < cols; j++) ...[
            if (j > 0) const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: j < row.length
                  ? OutcomeCard(headline: row[j].$1, body: row[j].$2)
                  : const SizedBox.shrink(),
            ),
          ],
        ],
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}

/// Outcomes for a study with no measured figure to lead with: one plain
/// statement per row, a rule above each, in the reader's language.
class OutcomeNotes extends StatelessWidget {
  const OutcomeNotes({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final item in items)
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.smd),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: context.divider)),
            ),
            child: Text(
              item,
              style: TextStyle(
                fontSize: AppTypography.lead,
                height: 1.5,
                color: context.onSurface,
              ),
            ),
          ),
      ],
    );
  }
}
