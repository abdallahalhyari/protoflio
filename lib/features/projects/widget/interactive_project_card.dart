import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:profile/service/analytics_service.dart';
import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/features/case_study/case_study_router.dart';
import 'package:profile/features/case_study/case_study_widgets.dart';
import 'package:profile/features/projects/model/project.dart';
import 'package:profile/features/projects/page/project_modal.dart';

class InteractiveProjectCard extends StatefulWidget {
  final Project project;
  final int index;
  final ColorScheme scheme;
  final bool isDesktop;
  final String? selectedTech;
  final ValueChanged<String>? onSelectTech;
  final bool isDimmed;

  const InteractiveProjectCard({
    super.key,
    required this.project,
    required this.index,
    required this.scheme,
    required this.isDesktop,
    this.selectedTech,
    this.onSelectTech,
    this.isDimmed = false,
  });

  @override
  State<InteractiveProjectCard> createState() => _InteractiveProjectCardState();
}

class _InteractiveProjectCardState extends State<InteractiveProjectCard> {
  bool _isHovered = false;
  final ValueNotifier<Offset> _mousePos = ValueNotifier<Offset>(Offset.zero);

  @override
  void dispose() {
    _mousePos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final reduceMotion = AppMedia.reduceMotion(context);
    final hovered = _isHovered && widget.isDesktop && !reduceMotion;
    final caseStudySlug = CaseStudyRouter.slugForCompany(widget.project.company);
    return RepaintBoundary(
      child: Semantics(
        button: true,
        label: 'Read case study for ${widget.project.name}',
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          onHover: (e) => _mousePos.value = e.localPosition,
          child: AnimatedOpacity(
            opacity: widget.isDimmed ? 0.35 : 1.0,
            duration: AppMotion.snap,
            child: AnimatedScale(
              scale: hovered ? 1.02 : 1.0,
              duration: AppMotion.cardHover,
              curve: AppMotion.emphasized,
            child: Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              elevation: isDark ? 0 : (hovered ? 12 : 4),
              shadowColor: isDark ? Colors.transparent : Colors.black.withValues(alpha: 0.15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                side: BorderSide(
                  color: hovered
                      ? widget.scheme.primary.withValues(alpha: isDark ? 0.55 : 0.45)
                      : (isDark
                          ? Colors.white.withValues(alpha: 0.10)
                          : AppColors.slate200),
                  width: hovered ? 1.5 : 1.0,
                ),
              ),
              color: isDark ? AppColors.darkCard : Colors.white,
              child: InkWell(
                onTap: () {
                  SoundService.instance.playClick();
                  if (caseStudySlug != null) {
                    CaseStudyRouter.push(context, caseStudySlug);
                  } else {
                    showProjectCaseStudy(
                      context,
                      project: widget.project,
                      index: widget.index,
                    );
                  }
                },
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: widget.isDesktop ? 300 : 270,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Image Header with Parallax & Spotlight
                      if (widget.project.heroImagePath != null)
                        SizedBox(
                          height: widget.isDesktop ? 175 : 155,
                          child: ClipRect(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                AnimatedScale(
                                  scale: hovered ? 1.08 : 1.0,
                                  duration: AppMotion.lg,
                                  curve: AppMotion.emphasizedDecel,
                                  child: Image.asset(
                                    widget.project.heroImagePath!,
                                    fit: BoxFit.cover,
                                    gaplessPlayback: true,
                                  ),
                                ),
                              // Gradient Overlay
                              AnimatedOpacity(
                                opacity: hovered ? 1.0 : 0.8,
                                duration: AppMotion.cardHover,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.90),
                                        Colors.black.withValues(alpha: 0.10),
                                      ],
                                    ),
                                  ),
                                  child: const SizedBox.expand(),
                                ),
                              ),
                              // Spotlight
                              if (hovered)
                                Positioned.fill(
                                  child: ValueListenableBuilder<Offset>(
                                    valueListenable: _mousePos,
                                    builder: (context, pos, _) => Container(
                                      decoration: BoxDecoration(
                                        gradient: RadialGradient(
                                          center: FractionalOffset(
                                            (pos.dx / 400).clamp(0.0, 1.0),
                                            (pos.dy / 200).clamp(0.0, 1.0),
                                          ),
                                          radius: 0.6,
                                          colors: [
                                            widget.scheme.primary.withValues(alpha: 0.3),
                                            Colors.transparent,
                                          ],
                                          stops: const [0.0, 1.0],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                               // Metric Badge
                              if (widget.project.metricBadge != null)
                                Positioned(
                                  top: AppSpacing.sm,
                                  left: AppSpacing.sm,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.75),
                                      borderRadius: BorderRadius.circular(AppRadius.xs),
                                      border: Border.all(
                                        color: widget.scheme.primary.withValues(alpha: 0.6),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.verified_rounded, size: 12, color: widget.scheme.primary),
                                        const SizedBox(width: 4),
                                        Text(
                                          widget.project.metricBadge!.toUpperCase(),
                                          style: const TextStyle(
                                            fontFamily: AppTypography.monoFont,
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              // Label
                              Positioned(
                                left: AppSpacing.md,
                                bottom: AppSpacing.md,
                                child: Text(
                                  widget.project.company.toUpperCase(),
                                  style: const TextStyle(
                                    fontFamily: AppTypography.monoFont,
                                    color: Colors.white,
                                    fontSize: AppTypography.micro,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              // Company Quick Links
                              if (widget.project.url != null ||
                                  widget.project.linkedinUrl != null ||
                                  caseStudySlug != null)
                                Positioned(
                                  top: AppSpacing.sm,
                                  right: AppSpacing.sm,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (widget.project.url != null)
                                        _ProjectCardLinkIcon(
                                          tooltip: 'Visit ${widget.project.company} official website',
                                          url: widget.project.url!,
                                          icon: Icons.language_rounded,
                                          company: widget.project.company,
                                          type: 'website',
                                          scheme: widget.scheme,
                                        ),
                                      if (widget.project.linkedinUrl != null) ...[
                                        const SizedBox(width: 6),
                                        _ProjectCardLinkIcon(
                                          tooltip: 'View ${widget.project.company} on LinkedIn',
                                          url: widget.project.linkedinUrl!,
                                          isLinkedIn: true,
                                          company: widget.project.company,
                                          type: 'linkedin',
                                          scheme: widget.scheme,
                                        ),
                                      ],
                                      if (caseStudySlug != null) ...[
                                        const SizedBox(width: 6),
                                        _ProjectCardLinkIcon(
                                          tooltip: 'Copy link to ${widget.project.name} case study',
                                          icon: Icons.share_rounded,
                                          onTap: () => shareCaseStudy(
                                            context,
                                            slug: caseStudySlug,
                                            title: widget.project.name,
                                          ),
                                          company: widget.project.company,
                                          type: 'share_case_study',
                                          scheme: widget.scheme,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: widget.isDesktop ? 175 : 155,
                        child: Container(
                          color: widget.scheme.primary.withValues(alpha: 0.1),
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.project.company.toUpperCase(),
                                style: TextStyle(
                                  fontFamily: AppTypography.monoFont,
                                  color: widget.scheme.primary,
                                  fontSize: AppTypography.micro,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              if (widget.project.url != null ||
                                  widget.project.linkedinUrl != null ||
                                  caseStudySlug != null)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (widget.project.url != null)
                                      _ProjectCardLinkIcon(
                                        tooltip: 'Visit ${widget.project.company} official website',
                                        url: widget.project.url!,
                                        icon: Icons.language_rounded,
                                        company: widget.project.company,
                                        type: 'website',
                                        scheme: widget.scheme,
                                      ),
                                    if (widget.project.linkedinUrl != null) ...[
                                      const SizedBox(width: 6),
                                      _ProjectCardLinkIcon(
                                        tooltip: 'View ${widget.project.company} on LinkedIn',
                                        url: widget.project.linkedinUrl!,
                                        isLinkedIn: true,
                                        company: widget.project.company,
                                        type: 'linkedin',
                                        scheme: widget.scheme,
                                      ),
                                    ],
                                    if (caseStudySlug != null) ...[
                                      const SizedBox(width: 6),
                                      _ProjectCardLinkIcon(
                                        tooltip: 'Copy link to ${widget.project.name} case study',
                                        icon: Icons.share_rounded,
                                        onTap: () => shareCaseStudy(
                                          context,
                                          slug: caseStudySlug,
                                          title: widget.project.name,
                                        ),
                                        company: widget.project.company,
                                        type: 'share_case_study',
                                        scheme: widget.scheme,
                                      ),
                                    ],
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    // Body
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedDefaultTextStyle(
                                duration: AppMotion.snap,
                                style: TextStyle(
                                  fontFamily: AppTypography.displayFont,
                                  color: _isHovered
                                      ? widget.scheme.primary
                                      : (isDark ? Colors.white : AppColors.slate900),
                                  fontSize: widget.isDesktop ? 22 : 18,
                                  fontWeight: FontWeight.w900,
                                  height: 1.1,
                                ),
                                child: Text(
                                  widget.project.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.project.tagline,
                                style: TextStyle(
                                  color: isDark ? Colors.white.withValues(alpha: 0.7) : AppColors.slate600,
                                  fontSize: widget.isDesktop ? 13 : 12,
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              for (final tag in widget.project.stack.take(widget.isDesktop ? 4 : 3))
                                _TechTagChip(
                                  tag: tag,
                                  isSelected: widget.selectedTech == tag,
                                  scheme: widget.scheme,
                                  isDark: isDark,
                                  onTap: widget.onSelectTech != null
                                      ? () {
                                          SoundService.instance.playSelection();
                                          widget.onSelectTech!(tag);
                                        }
                                      : null,
                                ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          AnimatedSlide(
                            offset: _isHovered && widget.isDesktop ? const Offset(0.05, 0) : Offset.zero,
                            duration: AppMotion.cardHover,
                            curve: AppMotion.emphasized,
                            child: Builder(
                              builder: (context) {
                                final ctaColor = isDark ? widget.scheme.primary : AppColors.accentIndigoDeepText;
                                return Row(
                                  children: [
                                    Text(
                                      'READ CASE STUDY',
                                      style: TextStyle(
                                        fontFamily: AppTypography.monoFont,
                                        color: ctaColor,
                                        fontSize: AppTypography.caption,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Icon(Icons.arrow_forward_rounded, size: 14, color: ctaColor),
                                  ],
                                );
                              },
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
      ),
    ),
  ),
  );
  }
}

class _TechTagChip extends StatelessWidget {
  final String tag;
  final bool isSelected;
  final ColorScheme scheme;
  final bool isDark;
  final VoidCallback? onTap;

  const _TechTagChip({
    required this.tag,
    required this.isSelected,
    required this.scheme,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isSelected
        ? scheme.primary.withValues(alpha: isDark ? 0.25 : 0.15)
        : (isDark ? Colors.white.withValues(alpha: 0.06) : AppColors.slate100);

    final border = isSelected
        ? scheme.primary
        : (isDark ? Colors.white12 : AppColors.slate200);

    final text = isSelected
        ? scheme.primary
        : (isDark ? Colors.white70 : AppColors.slate700);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.xs),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.xs),
          border: Border.all(color: border, width: isSelected ? 1.2 : 0.8),
        ),
        child: Text(
          tag,
          style: TextStyle(
            fontFamily: AppTypography.monoFont,
            color: text,
            fontSize: 9.5,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ProjectCardLinkIcon extends StatefulWidget {
  final String tooltip;
  final String? url;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isLinkedIn;
  final String company;
  final String type;
  final ColorScheme scheme;

  const _ProjectCardLinkIcon({
    required this.tooltip,
    this.url,
    this.onTap,
    this.icon,
    this.isLinkedIn = false,
    required this.company,
    required this.type,
    required this.scheme,
  });

  @override
  State<_ProjectCardLinkIcon> createState() => _ProjectCardLinkIconState();
}

class _ProjectCardLinkIconState extends State<_ProjectCardLinkIcon> {
  bool _hovered = false;

  Future<void> _handleTap() async {
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }
    SoundService.instance.playClick();
    Analytics.event('project_company_link_click', params: {
      'company': widget.company,
      'type': widget.type,
      'url': widget.url ?? '',
    });
    if (widget.url != null) {
      final uri = Uri.parse(widget.url!);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.isLinkedIn ? AppColors.linkedIn : widget.scheme.primary;

    return Tooltip(
      message: widget.tooltip,
      waitDuration: const Duration(milliseconds: 250),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: _handleTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedScale(
            scale: _hovered ? 1.1 : 1.0,
            duration: AppMotion.snap,
            child: AnimatedContainer(
              duration: AppMotion.snap,
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: _hovered
                    ? activeColor.withValues(alpha: 0.85)
                    : Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(AppRadius.xs),
                border: Border.all(
                  color: _hovered
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.25),
                  width: 1.0,
                ),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: activeColor.withValues(alpha: 0.45),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: widget.isLinkedIn
                  ? Container(
                      width: 15,
                      height: 15,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _hovered ? Colors.white : AppColors.linkedIn,
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                      child: Text(
                        'in',
                        style: TextStyle(
                          color: _hovered ? AppColors.linkedIn : Colors.white,
                          fontSize: AppTypography.editorialSm,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'sans-serif',
                          height: 1.0,
                        ),
                      ),
                    )
                  : Icon(
                      widget.icon ?? Icons.language_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

