import 'package:flutter/material.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/engineering/domain/entities/architecture_topic.dart';
import 'package:profile/features/engineering/presentation/utils/architecture_labels.dart';
import 'package:profile/features/shell/presentation/controllers/home_controller.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/utils/bidi.dart';

/// The written half of an architecture: what it is, why it was chosen,
/// and the safeguards it buys. The tiers and their latency budgets live
/// in the diagram beside it, so they are not repeated here.
class ArchitectureDetailsCard extends StatelessWidget {
  final ArchitectureTopic topic;
  final bool isDesktop;

  const ArchitectureDetailsCard({
    super.key,
    required this.topic,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final body = TextStyle(
      color: context.onSurface,
      fontSize: AppTypography.body,
      height: 1.6,
    );

    final items = <Widget>[
      Text(
        architectureTopicLabel(l10n, topic.title),
        style: TextStyle(
          fontSize: AppTypography.title,
          fontWeight: FontWeight.w600,
          color: context.onSurface,
          height: 1.25,
        ),
      ),
      const SizedBox(height: AppSpacing.sm),
      Text(
        ltrContent(context, topic.summary),
        style: body.copyWith(color: context.mutedText),
      ),
      const SizedBox(height: AppSpacing.lg),
      _Subhead(l10n.uiArchRationale),
      Text(ltrContent(context, topic.whyChosen), style: body),
      const SizedBox(height: AppSpacing.lg),
      _Subhead(l10n.uiKeySafeguards),
      for (final item in topic.technicalHighlights)
        _Safeguard(text: ltrContent(context, item), style: body),
      const SizedBox(height: AppSpacing.md),
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: OutlinedButton.icon(
          onPressed: () {
            SoundService.instance.playClick();
            HomeController.maybeOf(context)?.goTo(5);
          },
          icon: const Icon(Icons.play_circle_fill_rounded, size: 16),
          label: Text(l10n.engTryDemos),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            side: BorderSide(
              color: scheme.primary.withValues(alpha: isDark ? 0.6 : 0.4),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
        ),
      ),
    ];

    final Widget content = isDesktop
        ? ListView(
            primary: false,
            padding: EdgeInsets.zero,
            physics: const ClampingScrollPhysics(),
            children: items,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: items,
          );

    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: context.cardGlass,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.14)
                : AppColors.ink200,
          ),
        ),
        child: content,
      ),
    );
  }
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
