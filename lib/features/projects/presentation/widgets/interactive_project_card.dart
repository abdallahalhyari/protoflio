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
    // Pointer over the card or keyboard focus inside it: the border turns
    // gold, since the whole card opens its case study. Nothing moves.
    final isActive = _isHovered || _isFocused;
    final caseStudySlug =
        CaseStudyRouter.slugForCompany(widget.project.company);

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
          child: AnimatedContainer(
            duration: AppMotion.cardHover,
            curve: AppMotion.emphasized,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.card),
              color: context.cardGlass,
              border: Border.all(
                color: isActive
                    ? widget.scheme.primary.withValues(alpha: 0.7)
                    : context.glassBorderStrong,
                // Thicker too, so keyboard focus reads without colour.
                width: isActive ? 1.5 : 1.0,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  canRequestFocus: false,
                  excludeFromSemantics: true,
                  // The gold border and title mark hover; no tint over
                  // the whole card on top of them.
                  hoverColor: Colors.transparent,
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
                            isDark: isDark,
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
    );
  }
}
