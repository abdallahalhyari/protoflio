import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../service/analytics_service.dart';
import '../../../../service/sound_service.dart';
import '../../../../theme/surface_tone.dart';
import '../../../../theme/tokens.dart';
import '../../../case_study/case_study_router.dart';
import '../../../case_study/case_study_widgets.dart';
import '../../model/project.dart';
import '../../page/project_modal.dart';

class InteractiveProjectCard extends StatefulWidget {
  final Project project;
  final int index;
  final ColorScheme scheme;
  final bool isDesktop;

  const InteractiveProjectCard({
    super.key,
    required this.project,
    required this.index,
    required this.scheme,
    required this.isDesktop,
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
    final caseStudySlug = CaseStudyRouter.slugForCompany(widget.project.company);
    return Semantics(
      button: true,
      label: 'Read case study for ${widget.project.name}',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        onHover: (e) => _mousePos.value = e.localPosition,
        child: AnimatedScale(
          scale: _isHovered && widget.isDesktop ? 1.02 : 1.0,
          duration: AppMotion.cardHover,
          curve: AppMotion.emphasized,
          child: Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            elevation: isDark ? 0 : (_isHovered ? 12 : 4),
            shadowColor: isDark ? Colors.transparent : Colors.black.withValues(alpha: 0.15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              side: BorderSide(
                color: isDark
                    ? (_isHovered ? widget.scheme.primary.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.12))
                    : (_isHovered ? widget.scheme.primary.withValues(alpha: 0.45) : AppColors.slate200),
                width: 1,
              ),
            ),
            color: isDark ? AppColors.darkCard : Colors.white,
            child: InkWell(
              onTap: () => showProjectCaseStudy(context, project: widget.project, index: widget.index),
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
                        height: widget.isDesktop ? 220 : 180,
                        child: ClipRect(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              AnimatedScale(
                                scale: _isHovered && widget.isDesktop ? 1.08 : 1.0,
                                duration: AppMotion.lg,
                                curve: AppMotion.emphasizedDecel,
                                child: Image.asset(
                                  widget.project.heroImagePath!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Gradient Overlay
                              AnimatedOpacity(
                                opacity: _isHovered ? 1.0 : 0.8,
                                duration: AppMotion.cardHover,
                                child: const DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Color(0xE6000000), // 0.9 alpha black
                                        Color(0x1A000000), // 0.1 alpha black
                                      ],
                                    ),
                                  ),
                                  child: SizedBox.expand(),
                                ),
                              ),
                              // Spotlight
                              if (_isHovered && widget.isDesktop)
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
                              // Label
                              Positioned(
                                left: AppSpacing.md,
                                bottom: AppSpacing.md,
                                child: Text(
                                  widget.project.company.toUpperCase(),
                                  style: const TextStyle(
                                    fontFamily: 'Courier',
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
                        height: widget.isDesktop ? 220 : 180,
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
                                  fontFamily: 'Courier',
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
                                        fontFamily: 'Courier',
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
    final activeColor = widget.isLinkedIn ? const Color(0xFF0A66C2) : widget.scheme.primary;

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
                        color: _hovered ? Colors.white : const Color(0xFF0A66C2),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                      child: Text(
                        'in',
                        style: TextStyle(
                          color: _hovered ? const Color(0xFF0A66C2) : Colors.white,
                          fontSize: 9.5,
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

