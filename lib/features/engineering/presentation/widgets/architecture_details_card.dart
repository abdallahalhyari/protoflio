import 'package:flutter/material.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/features/about/presentation/about_navigation.dart';
import 'package:profile/features/shell/presentation/controllers/home_controller.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/engineering/domain/entities/architecture_topic.dart';
import 'package:profile/shared/utils/bidi.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/engineering/presentation/utils/architecture_labels.dart';

/// Card container displaying architecture rationale, summary, and technical safeguards.
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
    final accentText = context.adaptiveAccentText(scheme.primary);
    final budgets = topic.diagramSteps
        .where((s) => s.latencyBudget != null)
        .toList(growable: false);

    final items = <Widget>[
      // Section Eyebrow & Title
      Row(
        children: [
          Icon(Icons.layers_rounded,
              size: AppTypography.body, color: accentText),
          const SizedBox(width: 6),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                AppLocalizations.of(context)!.engBlueprint,
                style: TextStyle(
                  fontSize: AppTypography.label,
                  fontWeight: FontWeight.w900,
                  color: accentText,
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),
      Text(
        architectureTopicLabel(AppLocalizations.of(context)!, topic.title),
        style: TextStyle(
          fontSize: isDesktop ? AppTypography.title : AppTypography.title,
          fontWeight: FontWeight.w900,
          color: context.onSurface,
          height: 1.2,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        ltrContent(context, topic.summary),
        style: TextStyle(
          fontSize: AppTypography.body,
          color: context.onSurface,
          height: 1.5,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 14),

      // Architectural Rationale Container
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: isDark ? 0.09 : 0.06),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: scheme.primary.withValues(alpha: isDark ? 0.32 : 0.40),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: scheme.primary.withValues(alpha: isDark ? 0.08 : 0.04),
              blurRadius: 12,
              spreadRadius: -2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology_rounded, color: accentText, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.uiArchRationale,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: accentText,
                      fontSize: AppTypography.label,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              ltrContent(context, topic.whyChosen),
              style: TextStyle(
                color: context.onSurface,
                fontSize: AppTypography.label,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),

      // Technical Highlights / Key Implementation Safeguards
      Row(
        children: [
          Icon(Icons.security_rounded, size: 15, color: accentText),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              AppLocalizations.of(context)!.uiKeySafeguards,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: accentText,
                fontSize: AppTypography.label,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      for (final item in topic.technicalHighlights) ...[
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4, right: 8),
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentText,
                    boxShadow: [
                      BoxShadow(
                        color: accentText.withValues(alpha: 0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  ltrContent(context, item),
                  style: TextStyle(
                    color: context.onSurface,
                    fontSize: AppTypography.label,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      if (budgets.isNotEmpty) ...[
        const SizedBox(height: 14),
        Row(
          children: [
            Icon(Icons.speed_rounded, size: 15, color: accentText),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                AppLocalizations.of(context)!.uiLatencyBudget,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: accentText,
                  fontSize: AppTypography.label,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (final step in budgets) _BudgetRow(step: step, isDark: isDark),
      ],
      const SizedBox(height: 8),
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: OutlinedButton(
          onPressed: () {
            SoundService.instance.playClick();
            aboutTabRequest.value = AboutTabs.playground;
            HomeController.maybeOf(context)?.goTo(5);
          },
          child: Text(AppLocalizations.of(context)!.engTryDemos),
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
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.cardGlass,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.14)
                : AppColors.ink200,
          ),
          boxShadow: isDark
              ? const []
              : [
                  BoxShadow(
                    color: AppColors.ink900.withValues(alpha: 0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: content,
      ),
    );
  }
}

/// One tier of the latency budget: coloured layer dot, tier title, and
/// the budget as a tabular-aligned mono metric figure on the right.
class _BudgetRow extends StatelessWidget {
  const _BudgetRow({required this.step, required this.isDark});

  final DiagramStep step;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final tone = context.adaptiveAccentText(step.color);
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? step.color.withValues(alpha: 0.08) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: step.color.withValues(alpha: isDark ? 0.30 : 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: step.color.withValues(alpha: isDark ? 0.06 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: step.color.withValues(alpha: isDark ? 0.20 : 0.12),
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
            child: Icon(step.icon, size: 14, color: tone),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  step.layer,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: tone,
                    fontSize: AppTypography.label,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  step.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.onSurface,
                    fontSize: AppTypography.label,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            constraints: const BoxConstraints(minWidth: 72),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.45)
                  : step.color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.xs),
              border: Border.all(
                color: step.color.withValues(alpha: isDark ? 0.45 : 0.40),
                width: 1.1,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              ltrAlways(context, step.latencyBudget!),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: tone,
                fontSize: AppTypography.label,
                fontWeight: FontWeight.w900,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
