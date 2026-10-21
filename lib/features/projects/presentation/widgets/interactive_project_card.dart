import 'package:flutter/material.dart';

import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/case_study/presentation/pages/case_study_router.dart';
import 'package:profile/features/projects/domain/entities/project.dart';
import 'package:profile/features/projects/presentation/pages/project_modal.dart';
import 'package:profile/features/projects/presentation/widgets/card/project_card_hero.dart';
import 'package:profile/features/projects/presentation/widgets/card/project_card_body.dart';

class InteractiveProjectCard extends StatefulWidget {
  final Project project;
  final int index;
  final ColorScheme scheme;
  final bool isDesktop;

  /// Stretch to the height the parent gives (a grid row), pinning the
  /// "Read case study" row to the bottom. Otherwise the card takes its
  /// natural height.
  final bool fillHeight;

  const InteractiveProjectCard({
    super.key,
    required this.project,
    required this.index,
    required this.scheme,
    required this.isDesktop,
    this.fillHeight = false,
  });

  @override
  State<InteractiveProjectCard> createState() => _InteractiveProjectCardState();
}

class _InteractiveProjectCardState extends State<InteractiveProjectCard> {
  bool _isHovered = false;
  bool _isFocused = false;
  final ValueNotifier<Offset> _mousePos = ValueNotifier<Offset>(Offset.zero);

  @override
  void dispose() {
    _mousePos.dispose();
    super.dispose();
  }

  void _openStudy() {
    SoundService.instance.playClick();
    final slug = CaseStudyRouter.slugForCompany(widget.project.company);
    if (slug != null) {
      CaseStudyRouter.push(context, slug);
    } else {
      showProjectCaseStudy(
        context,
        project: widget.project,
        index: widget.index,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final reduceMotion = AppMedia.reduceMotion(context);
    final hovered = _isHovered && widget.isDesktop && !reduceMotion;
    final isInteractive = (hovered || _isFocused) && !reduceMotion;
    final caseStudySlug =
        CaseStudyRouter.slugForCompany(widget.project.company);

    final domainAccent = switch (widget.project.domain) {
      'Healthcare & Smart Cards' => AppColors.tealLight,
      'Enterprise HIS & LMS' => widget.scheme.primary,
      'Consumer & Social' => AppColors.teal,
      'M-Commerce & Streaming' => AppColors.goldSoft,
      _ => widget.scheme.primary,
    };

    final pinFoot = widget.fillHeight;
    final body = CardBodyContent(
      project: widget.project,
      scheme: widget.scheme,
      isDesktop: widget.isDesktop,
      isHovered: _isHovered || _isFocused,
      isDark: isDark,
      pinFoot: pinFoot,
      onOpenStudy: _openStudy,
      onFocusChange: (focused) => setState(() => _isFocused = focused),
    );

    return RepaintBoundary(
      child: Semantics(
        container: true,
        explicitChildNodes: true,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          onHover: (e) {
            if ((e.localPosition - _mousePos.value).distanceSquared > 4) {
              _mousePos.value = e.localPosition;
            }
          },
          child: AnimatedScale(
            scale: isInteractive ? 1.005 : 1.0,
            duration: AppMotion.cardHover,
            curve: AppMotion.emphasized,
            child: AnimatedContainer(
              duration: AppMotion.cardHover,
              curve: AppMotion.emphasized,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.card),
                gradient: isInteractive && isDark
                    ? RadialGradient(
                        center: Alignment(
                          (_mousePos.value.dx /
                                      (widget.isDesktop ? 400 : 300)) *
                                  2 -
                              1,
                          (_mousePos.value.dy / 500) * 2 - 1,
                        ),
                        radius: 1.5,
                        colors: [
                          domainAccent.withValues(alpha: 0.14),
                          context.cardGlassHover,
                        ],
                        stops: const [0.0, 0.55],
                      )
                    : null,
                color: isInteractive && !isDark
                    ? context.cardGlassHover
                    : (isInteractive ? null : context.cardGlass),
                border: Border.all(
                  color: isInteractive
                      ? (isDark
                          ? domainAccent.withValues(alpha: 0.85)
                          : widget.scheme.primary.withValues(alpha: 0.75))
                      : (isDark
                          ? Colors.white.withValues(alpha: 0.14)
                          : AppColors.ink200),
                  width: isInteractive ? 1.5 : 1.0,
                ),
                boxShadow: isInteractive
                    ? [
                        BoxShadow(
                          color: (isDark ? domainAccent : AppColors.shadowSoft)
                              .withValues(alpha: isDark ? 0.1 : 0.65),
                          blurRadius: isDark ? 14 : 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.card),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    canRequestFocus: false,
                    excludeFromSemantics: true,
                    onTap: _openStudy,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: widget.isDesktop ? 300 : 270,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (widget.project.heroImagePath != null)
                            CardHeroImage(
                              project: widget.project,
                              scheme: widget.scheme,
                              isDesktop: widget.isDesktop,
                              hovered: hovered,
                              isDark: isDark,
                              mousePos: _mousePos,
                              caseStudySlug: caseStudySlug,
                            )
                          else
                            CardFallbackPlaceholder(
                              project: widget.project,
                              scheme: widget.scheme,
                              isDesktop: widget.isDesktop,
                              isDark: isDark,
                              caseStudySlug: caseStudySlug,
                            ),
                          if (pinFoot) Expanded(child: body) else body,
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
}
