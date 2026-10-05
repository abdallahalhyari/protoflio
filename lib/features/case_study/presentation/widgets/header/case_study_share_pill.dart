import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/utils/bidi.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

import 'package:profile/features/case_study/presentation/widgets/header/case_study_share_util.dart';

class CaseStudySharePill extends StatefulWidget {
  final String slug;
  final String title;
  final ColorScheme scheme;
  final bool isDark;

  const CaseStudySharePill({
    super.key,
    required this.slug,
    required this.title,
    required this.scheme,
    required this.isDark,
  });

  @override
  State<CaseStudySharePill> createState() => _CaseStudySharePillState();
}

class _CaseStudySharePillState extends State<CaseStudySharePill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    const accent = AppColors.teal;

    return Semantics(
      button: true,
      label: AppLocalizations.of(context)!.studyShareSemantics(widget.title),
      child: Tooltip(
        message: AppLocalizations.of(context)!.studyShareTooltip,
        excludeFromSemantics: true,
        waitDuration: AppMotion.tooltipWait,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () => shareCaseStudy(context,
                    slug: widget.slug, title: widget.title),
                borderRadius: BorderRadius.circular(AppRadius.pill),
                onFocusChange: (focused) => setState(() => _hovered = focused),
                child: ExcludeSemantics(
                    child: AnimatedScale(
                  scale: _hovered ? 1.05 : 1.0,
                  duration: AppMotion.snap,
                  child: AnimatedContainer(
                    duration: AppMotion.snap,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _hovered
                          ? (isDark
                              ? accent.withValues(alpha: 0.22)
                              : accent.withValues(alpha: AppAlpha.hover))
                          : (isDark
                              ? Colors.white.withValues(alpha: AppAlpha.whisper)
                              : AppColors.ink100),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(
                        color: _hovered
                            ? accent.withValues(alpha: isDark ? 0.9 : 0.8)
                            : (isDark
                                ? Colors.white.withValues(alpha: 0.2)
                                : AppColors.ink300),
                        width: _hovered ? 1.4 : 1.0,
                      ),
                      boxShadow: _hovered
                          ? [
                              BoxShadow(
                                color: accent.withValues(
                                    alpha: isDark ? 0.35 : 0.22),
                                blurRadius: 10,
                                spreadRadius: 0.5,
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.share_rounded,
                          size: 13,
                          color: _hovered
                              ? (isDark ? Colors.white : AppColors.tealDeep)
                              : (context.mutedText),
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            AppLocalizations.of(context)!.studyShare,
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: AppTypography.label,
                              fontWeight: FontWeight.w900,
                              letterSpacing: latinTracking(context, 1.2),
                              color: _hovered
                                  ? (isDark ? Colors.white : AppColors.tealDeep)
                                  : (isDark
                                      ? Colors.white.withValues(alpha: 0.88)
                                      : AppColors.ink800),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
              )),
        ),
      ),
    );
  }
}
