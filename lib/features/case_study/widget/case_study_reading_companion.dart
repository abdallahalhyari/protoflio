import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../../../service/analytics_service.dart';
import '../../../service/sound_service.dart';
import '../../../theme/surface_tone.dart';
import '../../../theme/tokens.dart';

/// Representation of a chapter / section anchor in a case study.
class CaseStudyChapter {
  const CaseStudyChapter({
    required this.id,
    required this.label,
    required this.shortLabel,
    required this.key,
  });

  final String id;
  final String label;
  final String shortLabel;
  final GlobalKey key;
}

/// A cyber-obsidian reading companion wrapper for case study pages.
///
/// Features:
/// 1. Top glowing reading progress bar with cyber gradient and ambient shadow.
/// 2. Floating glassmorphism executive chapter dock appearing after initial scroll.
/// 3. Real-time reading % HUD with mini circular arc.
/// 4. 1-tap chapter anchors with active section detection and smooth scrolling.
/// 5. Back-to-Top smooth jump with audio feedback.
class CaseStudyReadingCompanion extends StatefulWidget {
  const CaseStudyReadingCompanion({
    super.key,
    required this.scrollController,
    required this.chapters,
    required this.child,
  });

  final ScrollController scrollController;
  final List<CaseStudyChapter> chapters;
  final Widget child;

  @override
  State<CaseStudyReadingCompanion> createState() =>
      _CaseStudyReadingCompanionState();
}

class _CaseStudyReadingCompanionState extends State<CaseStudyReadingCompanion> {
  double _progress = 0.0;
  bool _showDock = false;
  String? _activeChapterId;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
    if (widget.chapters.isNotEmpty) {
      _activeChapterId = widget.chapters.first.id;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _onScroll();
    });
  }

  @override
  void didUpdateWidget(CaseStudyReadingCompanion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_onScroll);
      widget.scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!mounted || !widget.scrollController.hasClients) return;

    final offset = widget.scrollController.offset;
    final maxScroll = widget.scrollController.position.maxScrollExtent;
    final progress = maxScroll > 0 ? (offset / maxScroll).clamp(0.0, 1.0) : 0.0;
    final showDock = offset > 140.0;

    String? activeId;
    final vpHeight = MediaQuery.sizeOf(context).height;
    for (final chapter in widget.chapters) {
      final ctx = chapter.key.currentContext;
      if (ctx != null && ctx.findRenderObject() is RenderBox) {
        final box = ctx.findRenderObject()! as RenderBox;
        if (box.hasSize) {
          final pos = box.localToGlobal(Offset.zero);
          if (pos.dy <= vpHeight * 0.45) {
            activeId = chapter.id;
          }
        }
      }
    }

    activeId ??= widget.chapters.isNotEmpty ? widget.chapters.first.id : null;

    if (activeId != _activeChapterId ||
        showDock != _showDock ||
        (progress - _progress).abs() > 0.005) {
      setState(() {
        _progress = progress;
        _showDock = showDock;
        _activeChapterId = activeId;
      });
    }
  }

  void _scrollToChapter(CaseStudyChapter chapter) {
    SoundService.instance.playClick();
    Analytics.event('case_study_chapter_click',
        params: {'chapter': chapter.id});
    final ctx = chapter.key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: AppMotion.sectionScroll,
        curve: AppMotion.easeInOutCubic,
        alignment: 0.08,
      );
    }
  }

  void _scrollToTop() {
    SoundService.instance.playClick();
    Analytics.event('case_study_back_to_top');
    widget.scrollController.animateTo(
      0.0,
      duration: AppMotion.sectionScroll,
      curve: AppMotion.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification ||
            notification is OverscrollNotification) {
          _onScroll();
        }
        return false;
      },
      child: Stack(
        children: [
          widget.child,
          _TopReadingProgressBar(
            progress: _progress,
            isDark: isDark,
          ),
          _FloatingChapterDock(
            visible: _showDock,
            progress: _progress,
            chapters: widget.chapters,
            activeChapterId: _activeChapterId,
            onChapterTap: _scrollToChapter,
            onBackToTop: _scrollToTop,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _TopReadingProgressBar extends StatelessWidget {
  const _TopReadingProgressBar({
    required this.progress,
    required this.isDark,
  });

  final double progress;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Positioned(
      key: const Key('case_study_reading_progress_bar'),
      top: 0,
      left: 0,
      right: 0,
      height: 3.5,
      child: Container(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.black.withValues(alpha: 0.05),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final filledWidth = constraints.maxWidth * progress;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 60),
                  curve: Curves.easeOut,
                  width: filledWidth,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accentCyan,
                        scheme.primary,
                        AppColors.accentGreen,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentCyan
                            .withValues(alpha: isDark ? 0.8 : 0.6),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: AppColors.accentGreen
                            .withValues(alpha: isDark ? 0.6 : 0.4),
                        blurRadius: 12,
                        spreadRadius: -1,
                      ),
                    ],
                  ),
                ),
                if (progress > 0.01 && progress < 0.995)
                  Positioned(
                    left:
                        (filledWidth - 3).clamp(0.0, constraints.maxWidth - 6),
                    top: -1.2,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.accentCyan,
                            blurRadius: 6,
                            spreadRadius: 1.5,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FloatingChapterDock extends StatelessWidget {
  const _FloatingChapterDock({
    required this.visible,
    required this.progress,
    required this.chapters,
    required this.activeChapterId,
    required this.onChapterTap,
    required this.onBackToTop,
    required this.isDark,
  });

  final bool visible;
  final double progress;
  final List<CaseStudyChapter> chapters;
  final String? activeChapterId;
  final ValueChanged<CaseStudyChapter> onChapterTap;
  final VoidCallback onBackToTop;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < AppBreakpoints.tablet;

    return Positioned(
      bottom: isCompact ? 16 : 24,
      left: 12,
      right: 12,
      child: Center(
        child: RepaintBoundary(
          child: AnimatedSlide(
            offset: visible ? Offset.zero : const Offset(0, 1.4),
            duration: AppMotion.sm,
            curve: Curves.easeOutCubic,
            child: AnimatedOpacity(
              opacity: visible ? 1.0 : 0.0,
              duration: AppMotion.sm,
              curve: Curves.easeOutCubic,
              child: IgnorePointer(
                ignoring: !visible,
                child: Container(
                  key: const Key('case_study_chapter_dock'),
                  constraints: isCompact
                      ? BoxConstraints(maxWidth: screenWidth - 24)
                      : null,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withValues(alpha: isDark ? 0.55 : 0.16),
                        blurRadius: 28,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: AppColors.accentCyan
                            .withValues(alpha: isDark ? 0.16 : 0.08),
                        blurRadius: 14,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCanvas.withValues(alpha: 0.91)
                              : Colors.white.withValues(alpha: 0.94),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(
                            color: isDark
                                ? AppColors.accentCyan.withValues(alpha: 0.28)
                                : AppColors.slate300.withValues(alpha: 0.9),
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize:
                              isCompact ? MainAxisSize.max : MainAxisSize.min,
                          children: [
                            _ReadingPercentPill(
                              progress: progress,
                              isDark: isDark,
                              isCompact: isCompact,
                            ),
                            const SizedBox(width: 8),
                            _DockDivider(isDark: isDark),
                            const SizedBox(width: 8),
                            if (isCompact)
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: _buildChapters(isCompact: true),
                                  ),
                                ),
                              )
                            else
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: _buildChapters(isCompact: false),
                              ),
                            const SizedBox(width: 8),
                            _DockDivider(isDark: isDark),
                            const SizedBox(width: 8),
                            _BackToTopPill(
                              onTap: onBackToTop,
                              isDark: isDark,
                              isCompact: isCompact,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChapters({required bool isCompact}) {
    final list = <Widget>[];
    for (int i = 0; i < chapters.length; i++) {
      final ch = chapters[i];
      if (i > 0) list.add(const SizedBox(width: 4));
      list.add(_ChapterPill(
        chapter: ch,
        isActive: ch.id == activeChapterId,
        isCompact: isCompact,
        isDark: isDark,
        onTap: () => onChapterTap(ch),
      ));
    }
    return list;
  }
}

class _DockDivider extends StatelessWidget {
  const _DockDivider({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 18,
      color: isDark ? Colors.white24 : AppColors.slate300,
    );
  }
}

class _ReadingPercentPill extends StatelessWidget {
  const _ReadingPercentPill({
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
        color:
            isDark ? Colors.white.withValues(alpha: 0.05) : AppColors.slate100,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : AppColors.slate300,
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomPaint(
            size: const Size(13, 13),
            painter: _MiniCircularProgressPainter(
              progress: progress,
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            isCompact ? '$pct%' : '$pct% READ',
            style: TextStyle(
              fontFamily: AppTypography.monoFont,
              fontSize: AppTypography.micro,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
              color: isDark ? AppColors.accentCyan : AppColors.accentCyanDeep,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChapterPill extends StatefulWidget {
  const _ChapterPill({
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
  State<_ChapterPill> createState() => _ChapterPillState();
}

class _ChapterPillState extends State<_ChapterPill> {
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
      label: 'Chapter ${widget.chapter.label}',
      child: Tooltip(
        message: 'Jump to ${widget.chapter.label}',
        waitDuration: const Duration(milliseconds: 300),
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
                            AppColors.accentCyan
                                .withValues(alpha: isDark ? 0.26 : 0.18),
                            AppColors.accentGreen
                                .withValues(alpha: isDark ? 0.20 : 0.12),
                          ],
                        )
                      : null,
                  color: isActive
                      ? null
                      : (_hovered
                          ? (isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : AppColors.slate200)
                          : Colors.transparent),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: isActive
                        ? AppColors.accentCyan
                        : (_hovered
                            ? (isDark ? Colors.white30 : AppColors.slate400)
                            : Colors.transparent),
                    width: isActive ? 1.3 : 1.0,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.accentCyan
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
                          color: AppColors.accentCyan,
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: AppTypography.monoFont,
                        fontSize: AppTypography.micro,
                        fontWeight: isActive ? FontWeight.w900 : FontWeight.w700,
                        letterSpacing: 1.0,
                        color: isActive
                            ? (isDark
                                ? AppColors.accentCyan
                                : AppColors.accentCyanDeep)
                            : (_hovered
                                ? (isDark ? Colors.white : AppColors.slate900)
                                : (isDark ? Colors.white70 : AppColors.slate600)),
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

class _BackToTopPill extends StatefulWidget {
  const _BackToTopPill({
    required this.onTap,
    required this.isDark,
    required this.isCompact,
  });

  final VoidCallback onTap;
  final bool isDark;
  final bool isCompact;

  @override
  State<_BackToTopPill> createState() => _BackToTopPillState();
}

class _BackToTopPillState extends State<_BackToTopPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;

    return Semantics(
      button: true,
      label: 'Back to top',
      child: Tooltip(
        message: 'Back to top',
        waitDuration: const Duration(milliseconds: 300),
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
                          ? AppColors.accentGreen.withValues(alpha: 0.22)
                          : AppColors.accentGreen.withValues(alpha: 0.14))
                      : (isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : AppColors.slate100),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: _hovered
                        ? AppColors.accentGreen
                        : (isDark
                            ? Colors.white.withValues(alpha: 0.18)
                            : AppColors.slate300),
                    width: _hovered ? 1.3 : 1.0,
                  ),
                  boxShadow: _hovered
                      ? [
                          BoxShadow(
                            color: AppColors.accentGreen
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
                          ? (isDark ? Colors.white : AppColors.accentGreenDeep)
                          : (isDark ? Colors.white70 : AppColors.slate600),
                    ),
                    if (!widget.isCompact) ...[
                      const SizedBox(width: 4),
                      Text(
                        'TOP',
                        style: TextStyle(
                          fontFamily: AppTypography.monoFont,
                          fontSize: AppTypography.micro,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                          color: _hovered
                              ? (isDark
                                  ? Colors.white
                                  : AppColors.accentGreenDeep)
                              : (isDark ? Colors.white70 : AppColors.slate600),
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

class _MiniCircularProgressPainter extends CustomPainter {
  _MiniCircularProgressPainter({required this.progress, required this.isDark});

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
          isDark ? Colors.white.withValues(alpha: 0.15) : AppColors.slate300;
    canvas.drawCircle(center, radius, trackPaint);

    if (progress > 0) {
      final progressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 2.2
        ..shader = const LinearGradient(
          colors: [AppColors.accentCyan, AppColors.accentGreen],
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
  bool shouldRepaint(_MiniCircularProgressPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.isDark != isDark;
}
