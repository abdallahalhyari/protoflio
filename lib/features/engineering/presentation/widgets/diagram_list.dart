import 'package:flutter/material.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/engineering/domain/entities/architecture_topic.dart';
import 'package:profile/shared/utils/bidi.dart';
import 'package:profile/l10n/app_localizations.dart';

class DiagramList extends StatelessWidget {
  final ArchitectureTopic topic;
  final ColorScheme scheme;
  final bool isDesktop;
  final int? activeStepIndex;
  final ValueChanged<int>? onSelectStep;
  final bool shrinkWrap;

  const DiagramList({
    super.key,
    required this.topic,
    required this.scheme,
    required this.isDesktop,
    this.activeStepIndex,
    this.onSelectStep,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < topic.diagramSteps.length; i++) ...[
          _DiagramTierItem(
            key: ValueKey('tier_${topic.id}_$i'),
            step: topic.diagramSteps[i],
            index: i,
            isActive: activeStepIndex != null && activeStepIndex == i,
            isDesktop: isDesktop,
            isDark: isDark,
            onTap: onSelectStep != null ? () => onSelectStep!(i) : null,
          ),
          if (i < topic.diagramSteps.length - 1)
            _TierConnector(
              key: ValueKey('connector_${topic.id}_$i'),
              isActive: activeStepIndex != null && activeStepIndex == i,
              primaryColor: scheme.primary,
              isDark: isDark,
            ),
        ],
      ],
    );
  }
}

/// An interactive, crisp architectural tier box with hover elevation and active aura.
class _DiagramTierItem extends StatefulWidget {
  final DiagramStep step;
  final int index;
  final bool isActive;
  final bool isDesktop;
  final bool isDark;
  final VoidCallback? onTap;

  const _DiagramTierItem({
    super.key,
    required this.step,
    required this.index,
    required this.isActive,
    required this.isDesktop,
    required this.isDark,
    this.onTap,
  });

  @override
  State<_DiagramTierItem> createState() => _DiagramTierItemState();
}

class _DiagramTierItemState extends State<_DiagramTierItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final step = widget.step;
    final isDark = widget.isDark;
    final isDesktop = widget.isDesktop;
    final isActive = widget.isActive;
    final accent = context.adaptiveAccentText(step.color);

    final cardBg = isActive
        ? (isDark
            ? step.color.withValues(alpha: 0.18)
            : step.color.withValues(alpha: 0.10))
        : (_isHovered
            ? (isDark
                ? step.color.withValues(alpha: 0.10)
                : step.color.withValues(alpha: 0.05))
            : (isDark
                ? Colors.black.withValues(alpha: AppAlpha.border)
                : AppColors.slate50));

    final borderColor = isActive
        ? (isDark ? step.color : accent)
        : (_isHovered
            ? (isDark
                ? step.color.withValues(alpha: 0.7)
                : accent.withValues(alpha: 0.75))
            : (isDark
                ? step.color.withValues(alpha: 0.30)
                : AppColors.slate200));

    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedSlide(
          duration: AppMotion.cardHover,
          curve: AppMotion.emphasized,
          offset: Offset(0, _isHovered && !isActive ? -0.03 : 0.0),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(AppRadius.smd),
            child: AnimatedContainer(
              duration: AppMotion.snap,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 16 : 12,
                vertical: isDesktop ? 12 : 10,
              ),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(AppRadius.smd),
                border: Border.all(
                  color: borderColor,
                  width: isActive ? 2.0 : (_isHovered ? 1.5 : 1.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isDark ? step.color : accent).withValues(
                      alpha: isActive
                          ? (isDark ? 0.30 : 0.18)
                          : (_isHovered
                              ? (isDark ? 0.18 : 0.10)
                              : (isDark ? 0.06 : 0.03)),
                    ),
                    blurRadius: isActive ? 18 : (_isHovered ? 14 : 8),
                    spreadRadius: isActive ? 1 : 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: AppMotion.snap,
                    padding: EdgeInsets.all(
                      isDesktop ? (isActive ? 9 : 8) : (isActive ? 7 : 6),
                    ),
                    decoration: BoxDecoration(
                      color: step.color.withValues(
                        alpha: isActive ? 0.32 : (isDark ? 0.15 : 0.12),
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isActive
                            ? accent
                            : step.color
                                .withValues(alpha: isDark ? 0.35 : 0.25),
                        width: isActive ? 1.5 : 1.0,
                      ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: accent.withValues(alpha: 0.5),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      step.icon,
                      color: accent,
                      size: isDesktop ? 18 : 16,
                    ),
                  ),
                  SizedBox(width: isDesktop ? 14 : 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                step.layer,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: AppTypography.monoFont,
                                  color: accent,
                                  fontSize: isDesktop
                                      ? AppTypography.editorialSm
                                      : AppTypography.nano,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            if (isActive) ...[
                              const SizedBox(width: 8),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: accent,
                                      borderRadius:
                                          BorderRadius.circular(AppRadius.chip),
                                      boxShadow: [
                                        BoxShadow(
                                          color: accent.withValues(alpha: 0.45),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 5,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.onAccent(accent),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .uiActiveTrace,
                                          style: TextStyle(
                                            fontFamily: AppTypography.monoFont,
                                            fontSize: AppTypography.nano,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.onAccent(accent),
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          step.title,
                          style: TextStyle(
                            color: context.onSurface,
                            fontSize: isDesktop
                                ? AppTypography.smallLoose
                                : AppTypography.captionSm,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          ltrContent(context, step.details),
                          style: TextStyle(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.90)
                                : AppColors.slate700,
                            fontSize: isDesktop
                                ? AppTypography.caption
                                : AppTypography.editorialSm,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// An illuminated directional conduit between architecture tiers.
class _TierConnector extends StatelessWidget {
  final bool isActive;
  final Color primaryColor;
  final bool isDark;

  const _TierConnector({
    super.key,
    required this.isActive,
    required this.primaryColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final accentText = context.adaptiveAccentText(primaryColor);
    final connColor = isActive ? primaryColor : accentText;

    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: isActive ? 2.0 : 1.0,
                height: 10,
                decoration: BoxDecoration(
                  color: connColor,
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.6),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                decoration: BoxDecoration(
                  color: isActive
                      ? primaryColor.withValues(alpha: isDark ? 0.20 : 0.12)
                      : (isDark
                          ? Colors.white.withValues(alpha: 0.04)
                          : AppColors.slate100),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: connColor.withValues(alpha: isActive ? 0.7 : 0.4),
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.4),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: connColor,
                  size: isActive ? 16 : 14,
                ),
              ),
              Container(
                width: isActive ? 2.0 : 1.0,
                height: 10,
                decoration: BoxDecoration(
                  color: connColor,
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.6),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
