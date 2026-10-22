import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/engineering/domain/entities/architecture_topic.dart';
import 'package:profile/features/engineering/presentation/utils/architecture_labels.dart';
import 'package:profile/l10n/app_localizations.dart';

/// The written half of an architecture, beside its layer stack: what it
/// is, why it was chosen, what it costs, its safeguards and where it ran.
/// No box: type carries the hierarchy.
class ArchitectureDetails extends StatelessWidget {
  final ArchitectureTopic topic;

  const ArchitectureDetails({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final body = TextStyle(
      color: context.onSurface,
      fontSize: AppTypography.body,
      height: 1.6,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            architectureTopicLabel(l10n, topic.title),
            style: TextStyle(
              fontSize: AppTypography.heading,
              fontWeight: FontWeight.w700,
              height: 1.2,
              color: context.onSurface,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _English(Text(
          topic.summary,
          style: TextStyle(
            fontSize: AppTypography.lead,
            height: 1.55,
            color: context.mutedText,
          ),
        )),
        const SizedBox(height: AppSpacing.lg),
        _Subhead(l10n.uiArchRationale),
        _English(Text(topic.whyChosen, style: body)),
        const SizedBox(height: AppSpacing.lg),
        _Subhead(l10n.archCostLabel),
        _English(Text(topic.cost, style: body)),
        const SizedBox(height: AppSpacing.lg),
        _Subhead(l10n.uiKeySafeguards),
        for (final item in topic.technicalHighlights)
          _English(_Safeguard(text: item, style: body)),
        const SizedBox(height: AppSpacing.md),
        MergeSemantics(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: AppSpacing.smd),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: context.divider)),
            ),
            // Wraps rather than overflows at large text sizes.
            child: Wrap(
              spacing: AppSpacing.smd,
              runSpacing: 2,
              children: [
                Text(
                  l10n.archUsedAtLabel,
                  style: TextStyle(
                    fontSize: AppTypography.body,
                    color: context.mutedText,
                  ),
                ),
                Text(
                  topic.usedAt,
                  style: TextStyle(
                    fontSize: AppTypography.body,
                    fontWeight: FontWeight.w600,
                    color: context.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// The write-ups are English: left to right, full width, in every
/// language, while the headings around them follow the reader's.
class _English extends StatelessWidget {
  const _English(this.child);
  final Widget child;

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(width: double.infinity, child: child),
      );
}

class _Subhead extends StatelessWidget {
  const _Subhead(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Semantics(
        header: true,
        child: Text(
          text,
          style: TextStyle(
            color: context.onSurface,
            fontSize: AppTypography.body,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// One safeguard, marked with a short teal rule — the diagram's spine
/// colour, since each safeguard is a property of those tiers.
class _Safeguard extends StatelessWidget {
  const _Safeguard({required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final rule = context.isDarkMode ? AppColors.tealLight : AppColors.teal;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 11, end: 10),
            child: Container(width: 8, height: 1.5, color: rule),
          ),
          Expanded(child: Text(text, style: style)),
        ],
      ),
    );
  }
}
