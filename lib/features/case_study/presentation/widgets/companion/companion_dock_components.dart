import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/case_study/presentation/widgets/case_study_reading_companion.dart';

class CompanionDockDivider extends StatelessWidget {
  const CompanionDockDivider({super.key, required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 18,
      color: context.glassBorderStrong,
    );
  }
}

class CompanionReadingPercentPill extends StatelessWidget {
  const CompanionReadingPercentPill({
    super.key,
    required this.progress,
    required this.isDark,
    required this.isCompact,
  });

  final double progress;
  final bool isDark;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : AppColors.ink100,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: AppAlpha.hover)
              : AppColors.ink300,
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomPaint(
            size: const Size(13, 13),
            painter: CompanionMiniCircularProgressPainter(
              progress: progress,
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            isCompact
                ? '$pct%'
                : '${AppLocalizations.of(context)!.studyReadPercent(pct)} · 3 MIN READ',
            style: TextStyle(
              fontSize: AppTypography.label,
              fontWeight: FontWeight.w900,
              color: isDark ? AppColors.tealLight : AppColors.tealDeep,
            ),
          ),
        ],
      ),
    );
  }
}

class CompanionChapterPill extends StatefulWidget {
  const CompanionChapterPill({
    super.key,
    required this.chapter,
    required this.isActive,
    required this.isCompact,
    required this.isDark,
    required this.onTap,
  });

  final CaseStudyChapter chapter;
  final bool isActive;
  final bool isCompact;
  final bool isDark;
  final VoidCallback onTap;

  @override
  State<CompanionChapterPill> createState() => _CompanionChapterPillState();
}

class _CompanionChapterPillState extends State<CompanionChapterPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final isActive = widget.isActive;

    final label =
        widget.isCompact ? widget.chapter.shortLabel : widget.chapter.label;

    return Semantics(
      button: true,
      selected: isActive,
      label: AppLocalizations.of(context)!.studyChapter(widget.chapter.label),
      child: Tooltip(
        message:
            AppLocalizations.of(context)!.studyJumpTo(widget.chapter.label),
        waitDuration: AppMotion.tooltipWait,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            key: Key('case_study_chapter_${widget.chapter.id}'),
            onTap: widget.onTap,
            behavior: HitTestBehavior.opaque,
            child: AnimatedScale(
              scale: _hovered ? 1.05 : 1.0,
              duration: AppMotion.snap,
              child: AnimatedContainer(
                duration: AppMotion.snap,
                padding: EdgeInsets.symmetric(
                  horizontal: widget.isCompact ? 8 : 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  gradient: isActive
                      ? LinearGradient(
                          colors: [
                            AppColors.teal
                                .withValues(alpha: isDark ? 0.26 : 0.18),
                            AppColors.teal
                                .withValues(alpha: isDark ? 0.20 : 0.12),
                          ],
                        )
                      : null,
                  color: isActive
                      ? null
                      : (_hovered
                          ? (isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : AppColors.ink200)
                          : Colors.transparent),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: isActive
                        ? AppColors.teal
                        : (_hovered
                            ? (isDark ? Colors.white30 : AppColors.ink400)
                            : Colors.transparent),
                    width: isActive ? 1.3 : 1.0,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.teal
                                .withValues(alpha: isDark ? 0.35 : 0.2),
                            blurRadius: 8,
                            spreadRadius: 0.5,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isActive) ...[
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.teal,
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: AppTypography.label,
                        fontWeight:
                            isActive ? FontWeight.w900 : FontWeight.w700,
                        color: isActive
                            ? (isDark
                                ? AppColors.tealLight
                                : AppColors.tealDeep)
                            : (_hovered
                                ? (context.onSurface)
                                : (context.mutedText)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CompanionBackToTopPill extends StatefulWidget {
  const CompanionBackToTopPill({
    super.key,
    required this.onTap,
    required this.isDark,
    required this.isCompact,
  });

  final VoidCallback onTap;
  final bool isDark;
  final bool isCompact;

  @override
  State<CompanionBackToTopPill> createState() => _CompanionBackToTopPillState();
}

class _CompanionBackToTopPillState extends State<CompanionBackToTopPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;

    return Semantics(
      button: true,
      label: AppLocalizations.of(context)!.studyBackToTop,
      child: Tooltip(
        message: AppLocalizations.of(context)!.studyBackToTop,
        waitDuration: AppMotion.tooltipWait,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            key: const Key('case_study_back_to_top'),
            onTap: widget.onTap,
            behavior: HitTestBehavior.opaque,
            child: AnimatedScale(
              scale: _hovered ? 1.06 : 1.0,
              duration: AppMotion.snap,
              child: AnimatedContainer(
                duration: AppMotion.snap,
                padding: EdgeInsets.symmetric(
                  horizontal: widget.isCompact ? 7 : 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _hovered
                      ? (isDark
                          ? AppColors.teal.withValues(alpha: 0.22)
                          : AppColors.teal.withValues(alpha: 0.14))
                      : (isDark
                          ? Colors.white.withValues(alpha: AppAlpha.whisper)
                          : AppColors.ink100),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: _hovered
                        ? AppColors.teal
                        : (isDark
                            ? Colors.white.withValues(alpha: 0.18)
                            : AppColors.ink300),
                    width: _hovered ? 1.3 : 1.0,
                  ),
                  boxShadow: _hovered
                      ? [
                          BoxShadow(
                            color: AppColors.teal
                                .withValues(alpha: isDark ? 0.35 : 0.2),
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
                      Icons.arrow_upward_rounded,
                      size: 13,
                      color: _hovered
                          ? (isDark ? Colors.white : AppColors.tealDeep)
                          : (context.mutedText),
                    ),
                    if (!widget.isCompact) ...[
                      const SizedBox(width: 4),
                      Text(
                        AppLocalizations.of(context)!.studyTop,
                        style: TextStyle(
                          fontSize: AppTypography.label,
                          fontWeight: FontWeight.w900,
                          color: _hovered
                              ? (isDark ? Colors.white : AppColors.tealDeep)
                              : (context.mutedText),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CompanionMiniCircularProgressPainter extends CustomPainter {
  CompanionMiniCircularProgressPainter(
      {required this.progress, required this.isDark});

  final double progress;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1.5;

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color =
          isDark ? Colors.white.withValues(alpha: 0.15) : AppColors.ink300;
    canvas.drawCircle(center, radius, trackPaint);

    if (progress > 0) {
      final progressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 2.2
        ..shader = const LinearGradient(
          colors: [AppColors.teal, AppColors.teal],
        ).createShader(Rect.fromCircle(center: center, radius: radius));

      const startAngle = -3.141592653589793 / 2;
      final sweepAngle = 2 * 3.141592653589793 * progress.clamp(0.0, 1.0);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CompanionMiniCircularProgressPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.isDark != isDark;
}
