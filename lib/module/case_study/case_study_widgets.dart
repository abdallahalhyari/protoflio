import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../service/analytics_service.dart';
import '../../service/sound_service.dart';
import '../../theme/surface_tone.dart';
import '../../theme/tokens.dart';

/// Section kicker: numeric label + uppercase title + rule.
class SectionKicker extends StatelessWidget {
  const SectionKicker({super.key, required this.number, required this.label});

  final String number;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(children: [
      Text(
        number,
        style: TextStyle(
          fontFamily: AppTypography.displayFont,
          fontSize: AppTypography.heading,
          fontWeight: FontWeight.w900,
          color: scheme.primary,
        ),
      ),
      const SizedBox(width: AppSpacing.md),
      Expanded(
        child: Text(
          label,
          style: TextStyle(
            fontSize: AppTypography.overline,
            letterSpacing: 3,
            fontWeight: FontWeight.w800,
            color: scheme.onSurface.withValues(alpha: 0.9),
          ),
        ),
      ),
      Container(
        height: 1,
        width: 80,
        color: scheme.onSurface.withValues(alpha: 0.15),
      ),
    ]);
  }
}

/// Body prose, wider line-height for long reads.
class Prose extends StatelessWidget {
  const Prose(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Text(
      text,
      style: TextStyle(
        fontSize: AppTypography.body + 1,
        height: 1.65,
        color: scheme.onSurface.withValues(alpha: 0.85),
      ),
    );
  }
}

/// Vertical bullet list with primary-tinted markers.
class BulletList extends StatelessWidget {
  const BulletList({super.key, required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((t) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.smd),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          borderRadius: BorderRadius.circular(AppRadius.xxs),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.smd),
                    Expanded(
                      child: Text(
                        t,
                        style: TextStyle(
                          fontSize: AppTypography.body,
                          height: 1.55,
                          color: scheme.onSurface.withValues(alpha: 0.82),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

/// Data for a single ordered step inside a `TechnicalChapter`.
class TechStep {
  const TechStep({
    required this.layer,
    required this.title,
    required this.body,
  });
  final String layer;
  final String title;
  final String body;
}

/// A numbered technical chapter — kicker + ordered `TechStep` cards.
class TechnicalChapter extends StatelessWidget {
  const TechnicalChapter({
    super.key,
    required this.number,
    required this.title,
    required this.steps,
  });

  final String number;
  final String title;
  final List<TechStep> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionKicker(number: number, label: title),
        const SizedBox(height: AppSpacing.md),
        ...List.generate(steps.length, (i) {
          final s = steps[i];
          return Padding(
            padding: EdgeInsets.only(
                bottom: i == steps.length - 1 ? 0 : AppSpacing.md),
            child: TechStepCard(index: i + 1, step: s),
          );
        }),
      ],
    );
  }
}

class TechStepCard extends StatelessWidget {
  const TechStepCard({super.key, required this.index, required this.step});

  final int index;
  final TechStep step;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: scheme.primary.withValues(alpha: isDark ? 0.15 : 0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              index.toString().padLeft(2, '0'),
              style: TextStyle(
                fontFamily: AppTypography.displayFont,
                fontSize: AppTypography.subtitle,
                fontWeight: FontWeight.w900,
                color: scheme.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.layer,
                  style: TextStyle(
                    fontSize: AppTypography.editorial,
                    letterSpacing: 2.4,
                    fontWeight: FontWeight.w800,
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  step.title,
                  style: TextStyle(
                    fontSize: AppTypography.subtitle,
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  step.body,
                  style: TextStyle(
                    fontSize: AppTypography.body,
                    height: 1.55,
                    color: scheme.onSurface.withValues(alpha: 0.82),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A single outcome metric — big number + short caption.
class OutcomeCard extends StatelessWidget {
  const OutcomeCard({super.key, required this.headline, required this.body});

  final String headline;
  final String body;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;
    return Container(
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
                fontSize: 38,
                fontWeight: FontWeight.w900,
                color: scheme.primary,
                height: 1.0,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                body,
                style: TextStyle(
                  fontSize: AppTypography.small,
                  height: 1.35,
                  color: scheme.onSurface.withValues(alpha: 0.75),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Grid of `OutcomeCard` — 4 columns desktop, 2 on mobile.
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
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: cols,
      childAspectRatio: isDesktop ? 1.15 : 1.05,
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      children: items
          .map((c) => OutcomeCard(headline: c.$1, body: c.$2))
          .toList(),
    );
  }
}

/// Share / copy case study link helper with custom haptic toast.
Future<void> shareCaseStudy(
  BuildContext context, {
  required String slug,
  required String title,
}) async {
  SoundService.instance.playClick();
  Analytics.event('case_study_share', params: {'study': slug, 'title': title});
  final url = 'https://alhyari.web.app/#work/$slug';
  await Clipboard.setData(ClipboardData(text: url));

  if (!context.mounted) return;
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: const Duration(milliseconds: 3200),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      content: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: AppColors.accentGreen.withValues(alpha: 0.7),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: AppColors.accentGreen.withValues(alpha: 0.25),
                blurRadius: 14,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.accentGreen, size: 18),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  'Case study link copied: $url',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// A compact icon button for AppBar actions that shares the case study.
class CaseStudyToolbarShareButton extends StatelessWidget {
  final String slug;
  final String title;

  const CaseStudyToolbarShareButton({
    super.key,
    required this.slug,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.share_rounded, size: 20),
      tooltip: 'Share case study link',
      onPressed: () => shareCaseStudy(context, slug: slug, title: title),
    );
  }
}

/// Corporate verification links and direct share actions rendered in the case study masthead.
class CaseStudyCorporateHeader extends StatelessWidget {
  final String company;
  final String websiteUrl;
  final String linkedinUrl;
  final String slug;
  final String title;

  const CaseStudyCorporateHeader({
    super.key,
    required this.company,
    required this.websiteUrl,
    required this.linkedinUrl,
    required this.slug,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Wrap(
        spacing: 10,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _CaseStudyActionPill(
            label: 'OFFICIAL WEBSITE',
            tooltip: 'Visit $company official website',
            icon: Icons.language_rounded,
            url: websiteUrl,
            company: company,
            type: 'website',
            scheme: scheme,
            isDark: isDark,
          ),
          _CaseStudyActionPill(
            label: 'COMPANY LINKEDIN',
            tooltip: 'View $company on LinkedIn',
            isLinkedIn: true,
            url: linkedinUrl,
            company: company,
            type: 'linkedin',
            scheme: scheme,
            isDark: isDark,
          ),
          _CaseStudySharePill(
            slug: slug,
            title: title,
            scheme: scheme,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _CaseStudyActionPill extends StatefulWidget {
  final String label;
  final String tooltip;
  final IconData? icon;
  final bool isLinkedIn;
  final String url;
  final String company;
  final String type;
  final ColorScheme scheme;
  final bool isDark;

  const _CaseStudyActionPill({
    required this.label,
    required this.tooltip,
    this.icon,
    this.isLinkedIn = false,
    required this.url,
    required this.company,
    required this.type,
    required this.scheme,
    required this.isDark,
  });

  @override
  State<_CaseStudyActionPill> createState() => _CaseStudyActionPillState();
}

class _CaseStudyActionPillState extends State<_CaseStudyActionPill> {
  bool _hovered = false;

  Future<void> _handleTap() async {
    SoundService.instance.playClick();
    Analytics.event('case_study_company_link', params: {
      'company': widget.company,
      'type': widget.type,
      'url': widget.url,
    });
    final uri = Uri.parse(widget.url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final primary = widget.isLinkedIn ? const Color(0xFF0A66C2) : widget.scheme.primary;

    return Tooltip(
      message: widget.tooltip,
      waitDuration: const Duration(milliseconds: 300),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: _handleTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedScale(
            scale: _hovered ? 1.05 : 1.0,
            duration: AppMotion.snap,
            child: AnimatedContainer(
              duration: AppMotion.snap,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _hovered
                    ? (isDark
                        ? primary.withValues(alpha: 0.22)
                        : primary.withValues(alpha: 0.12))
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : AppColors.slate100),
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(
                  color: _hovered
                      ? primary.withValues(alpha: isDark ? 0.9 : 0.8)
                      : (isDark
                          ? Colors.white.withValues(alpha: 0.2)
                          : AppColors.slate300),
                  width: _hovered ? 1.4 : 1.0,
                ),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: primary.withValues(alpha: isDark ? 0.35 : 0.22),
                          blurRadius: 10,
                          spreadRadius: 0.5,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.isLinkedIn) ...[
                    Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A66C2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'in',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.0,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'sans-serif',
                          height: 1.0,
                        ),
                      ),
                    ),
                  ] else if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      size: 13,
                      color: _hovered
                          ? (isDark ? Colors.white : primary)
                          : (isDark ? Colors.white70 : AppColors.slate600),
                    ),
                  ],
                  const SizedBox(width: 5),
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontFamily: 'Courier',
                      fontSize: AppTypography.micro,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: _hovered
                          ? (isDark ? Colors.white : primary)
                          : (isDark ? Colors.white.withValues(alpha: 0.88) : AppColors.slate800),
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    Icons.arrow_outward_rounded,
                    size: 10,
                    color: _hovered
                        ? primary
                        : (isDark ? Colors.white38 : AppColors.slate400),
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

class _CaseStudySharePill extends StatefulWidget {
  final String slug;
  final String title;
  final ColorScheme scheme;
  final bool isDark;

  const _CaseStudySharePill({
    required this.slug,
    required this.title,
    required this.scheme,
    required this.isDark,
  });

  @override
  State<_CaseStudySharePill> createState() => _CaseStudySharePillState();
}

class _CaseStudySharePillState extends State<_CaseStudySharePill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    const accent = AppColors.accentGreen;

    return Tooltip(
      message: 'Copy direct link to this case study',
      waitDuration: const Duration(milliseconds: 300),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: () => shareCaseStudy(context, slug: widget.slug, title: widget.title),
          behavior: HitTestBehavior.opaque,
          child: AnimatedScale(
            scale: _hovered ? 1.05 : 1.0,
            duration: AppMotion.snap,
            child: AnimatedContainer(
              duration: AppMotion.snap,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _hovered
                    ? (isDark
                        ? accent.withValues(alpha: 0.22)
                        : accent.withValues(alpha: 0.12))
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : AppColors.slate100),
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(
                  color: _hovered
                      ? accent.withValues(alpha: isDark ? 0.9 : 0.8)
                      : (isDark
                          ? Colors.white.withValues(alpha: 0.2)
                          : AppColors.slate300),
                  width: _hovered ? 1.4 : 1.0,
                ),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: accent.withValues(alpha: isDark ? 0.35 : 0.22),
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
                        ? (isDark ? Colors.white : AppColors.accentGreenDeep)
                        : (isDark ? Colors.white70 : AppColors.slate600),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'SHARE STUDY',
                    style: TextStyle(
                      fontFamily: 'Courier',
                      fontSize: AppTypography.micro,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: _hovered
                          ? (isDark ? Colors.white : AppColors.accentGreenDeep)
                          : (isDark ? Colors.white.withValues(alpha: 0.88) : AppColors.slate800),
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
/// 6. Chromatic brand identity adaptation per case study.
class CaseStudyReadingCompanion extends StatefulWidget {
  const CaseStudyReadingCompanion({
    super.key,
    required this.scrollController,
    required this.chapters,
    required this.child,
    this.primaryAccent,
    this.secondaryAccent,
  });

  final ScrollController scrollController;
  final List<CaseStudyChapter> chapters;
  final Widget child;
  final Color? primaryAccent;
  final Color? secondaryAccent;

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
    Analytics.event('case_study_chapter_click', params: {'chapter': chapter.id});
    final ctx = chapter.key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
        alignment: 0.08,
      );
    }
  }

  void _scrollToTop() {
    SoundService.instance.playClick();
    Analytics.event('case_study_back_to_top');
    widget.scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final scheme = Theme.of(context).colorScheme;
    final primary = widget.primaryAccent ?? scheme.primary;
    final secondary = widget.secondaryAccent ?? scheme.secondary;

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
            primaryAccent: primary,
            secondaryAccent: secondary,
          ),
          _FloatingChapterDock(
            visible: _showDock,
            progress: _progress,
            chapters: widget.chapters,
            activeChapterId: _activeChapterId,
            onChapterTap: _scrollToChapter,
            onBackToTop: _scrollToTop,
            isDark: isDark,
            primaryAccent: primary,
            secondaryAccent: secondary,
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
    required this.primaryAccent,
    required this.secondaryAccent,
  });

  final double progress;
  final bool isDark;
  final Color primaryAccent;
  final Color secondaryAccent;

  @override
  Widget build(BuildContext context) {
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
                        primaryAccent,
                        secondaryAccent,
                        primaryAccent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryAccent
                            .withValues(alpha: isDark ? 0.8 : 0.6),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: secondaryAccent
                            .withValues(alpha: isDark ? 0.6 : 0.4),
                        blurRadius: 12,
                        spreadRadius: -1,
                      ),
                    ],
                  ),
                ),
                if (progress > 0.01 && progress < 0.995)
                  Positioned(
                    left: (filledWidth - 3).clamp(0.0, constraints.maxWidth - 6),
                    top: -1.2,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: primaryAccent,
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
    required this.primaryAccent,
    required this.secondaryAccent,
  });

  final bool visible;
  final double progress;
  final List<CaseStudyChapter> chapters;
  final String? activeChapterId;
  final ValueChanged<CaseStudyChapter> onChapterTap;
  final VoidCallback onBackToTop;
  final bool isDark;
  final Color primaryAccent;
  final Color secondaryAccent;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < AppBreakpoints.tablet;

    return Positioned(
      bottom: isCompact ? 16 : 24,
      left: 12,
      right: 12,
      child: Center(
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
                      color: Colors.black
                          .withValues(alpha: isDark ? 0.55 : 0.16),
                      blurRadius: 28,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: primaryAccent
                          .withValues(alpha: isDark ? 0.22 : 0.10),
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
                            ? const Color(0xE80A0E18)
                            : Colors.white.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(
                          color: isDark
                              ? primaryAccent.withValues(alpha: 0.32)
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
                            primaryAccent: primaryAccent,
                            secondaryAccent: secondaryAccent,
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
                            hoverAccent: secondaryAccent,
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
        primaryAccent: primaryAccent,
        secondaryAccent: secondaryAccent,
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
    required this.primaryAccent,
    required this.secondaryAccent,
  });

  final double progress;
  final bool isDark;
  final bool isCompact;
  final Color primaryAccent;
  final Color secondaryAccent;

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : AppColors.slate100,
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
              primaryAccent: primaryAccent,
              secondaryAccent: secondaryAccent,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            isCompact ? '$pct%' : '$pct% READ',
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: AppTypography.micro,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
              color: primaryAccent,
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
    required this.primaryAccent,
    required this.secondaryAccent,
    required this.onTap,
  });

  final CaseStudyChapter chapter;
  final bool isActive;
  final bool isCompact;
  final bool isDark;
  final Color primaryAccent;
  final Color secondaryAccent;
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
    final primary = widget.primaryAccent;
    final secondary = widget.secondaryAccent;

    final label = widget.isCompact
        ? widget.chapter.shortLabel
        : widget.chapter.label;

    return Tooltip(
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
                          primary.withValues(alpha: isDark ? 0.28 : 0.18),
                          secondary.withValues(alpha: isDark ? 0.22 : 0.12),
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
                      ? primary
                      : (_hovered
                          ? (isDark ? Colors.white30 : AppColors.slate400)
                          : Colors.transparent),
                  width: isActive ? 1.3 : 1.0,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: primary.withValues(alpha: isDark ? 0.38 : 0.22),
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
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primary,
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Courier',
                      fontSize: AppTypography.micro,
                      fontWeight:
                          isActive ? FontWeight.w900 : FontWeight.w700,
                      letterSpacing: 1.0,
                      color: isActive
                          ? primary
                          : (_hovered
                              ? (isDark ? Colors.white : AppColors.slate900)
                              : (isDark
                                  ? Colors.white70
                                  : AppColors.slate600)),
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

class _BackToTopPill extends StatefulWidget {
  const _BackToTopPill({
    required this.onTap,
    required this.isDark,
    required this.isCompact,
    required this.hoverAccent,
  });

  final VoidCallback onTap;
  final bool isDark;
  final bool isCompact;
  final Color hoverAccent;

  @override
  State<_BackToTopPill> createState() => _BackToTopPillState();
}

class _BackToTopPillState extends State<_BackToTopPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final accent = widget.hoverAccent;

    return Tooltip(
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
                        ? accent.withValues(alpha: 0.22)
                        : accent.withValues(alpha: 0.14))
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : AppColors.slate100),
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(
                  color: _hovered
                      ? accent
                      : (isDark
                          ? Colors.white.withValues(alpha: 0.18)
                          : AppColors.slate300),
                  width: _hovered ? 1.3 : 1.0,
                ),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: accent.withValues(alpha: isDark ? 0.35 : 0.2),
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
                        ? (isDark ? Colors.white : accent)
                        : (isDark ? Colors.white70 : AppColors.slate600),
                  ),
                  if (!widget.isCompact) ...[
                    const SizedBox(width: 4),
                    Text(
                      'TOP',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: AppTypography.micro,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: _hovered
                            ? (isDark ? Colors.white : accent)
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
    );
  }
}

class _MiniCircularProgressPainter extends CustomPainter {
  _MiniCircularProgressPainter({
    required this.progress,
    required this.isDark,
    required this.primaryAccent,
    required this.secondaryAccent,
  });

  final double progress;
  final bool isDark;
  final Color primaryAccent;
  final Color secondaryAccent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1.5;

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.15)
          : AppColors.slate300;
    canvas.drawCircle(center, radius, trackPaint);

    if (progress > 0) {
      final progressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 2.2
        ..shader = LinearGradient(
          colors: [primaryAccent, secondaryAccent],
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
      oldDelegate.progress != progress ||
      oldDelegate.isDark != isDark ||
      oldDelegate.primaryAccent != primaryAccent ||
      oldDelegate.secondaryAccent != secondaryAccent;
}

