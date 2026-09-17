import 'package:flutter/material.dart';

import '../../../../theme/surface_tone.dart';
import '../../../../theme/tokens.dart';
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
                            ],
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: widget.isDesktop ? 220 : 180,
                        child: Container(
                          color: widget.scheme.primary.withValues(alpha: 0.1),
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Text(
                            widget.project.company.toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'Courier',
                              color: widget.scheme.primary,
                              fontSize: AppTypography.micro,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
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
