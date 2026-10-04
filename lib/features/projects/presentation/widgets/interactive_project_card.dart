import 'package:flutter/material.dart';

import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/case_study/presentation/pages/case_study_router.dart';
import 'package:profile/features/projects/domain/entities/project.dart';
import 'package:profile/features/projects/presentation/pages/project_modal.dart';
import 'package:profile/shared/widgets/holographic_physics.dart';
import 'package:profile/features/projects/presentation/widgets/card/project_card_hero.dart';
import 'package:profile/features/projects/presentation/widgets/card/project_card_body.dart';

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

    return LayoutBuilder(builder: (context, constraints) {
      final pinFoot = widget.isDesktop && constraints.hasBoundedHeight;
      return RepaintBoundary(
        child: Semantics(
          container: true,
          explicitChildNodes: true,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            onHover: (e) => _mousePos.value = e.localPosition,
            child: AnimatedOpacity(
              opacity: widget.isDimmed ? 0.35 : 1.0,
              duration: AppMotion.snap,
              child: AnimatedScale(
                scale: isInteractive ? 1.02 : 1.0,
                duration: AppMotion.cardHover,
                curve: AppMotion.emphasized,
                child: HolographicCardPhysics(
                  child: AnimatedContainer(
                    duration: AppMotion.cardHover,
                    curve: AppMotion.emphasized,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      boxShadow: isInteractive && isDark
                          ? [
                              BoxShadow(
                                color: widget.scheme.primary
                                    .withValues(alpha: 0.28),
                                blurRadius: 28,
                                spreadRadius: 1,
                              ),
                              BoxShadow(
                                color: AppColors.accentViolet
                                    .withValues(alpha: 0.15),
                                blurRadius: 36,
                                spreadRadius: 2,
                              ),
                            ]
                          : [],
                    ),
                    child: Card(
                      margin: EdgeInsets.zero,
                      clipBehavior: Clip.antiAlias,
                      elevation: isDark ? 0 : (isInteractive ? 16 : 8),
                      shadowColor: isDark
                          ? Colors.transparent
                          : (isInteractive
                              ? Color.lerp(
                                      widget.scheme.primary, Colors.black, 0.5)!
                                  .withValues(alpha: 0.3)
                              : AppColors.shadowSoft),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        side: BorderSide(
                          color: isInteractive
                              ? widget.scheme.primary
                                  .withValues(alpha: isDark ? 0.75 : 0.65)
                              : (isDark
                                  ? Colors.white.withValues(alpha: 0.10)
                                  : AppColors.slate200),
                          width: isInteractive ? 1.5 : 1.0,
                        ),
                      ),
                      color: isInteractive
                          ? context.cardGlassHover
                          : context.cardGlass,
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
                              if (pinFoot)
                                Expanded(
                                  child: CardBodyContent(
                                    project: widget.project,
                                    scheme: widget.scheme,
                                    isDesktop: widget.isDesktop,
                                    isHovered: _isHovered,
                                    isDark: isDark,
                                    pinFoot: true,
                                    selectedTech: widget.selectedTech,
                                    onSelectTech: widget.onSelectTech,
                                    onOpenStudy: _openStudy,
                                    onFocusChange: (focused) =>
                                        setState(() => _isFocused = focused),
                                  ),
                                )
                              else
                                CardBodyContent(
                                  project: widget.project,
                                  scheme: widget.scheme,
                                  isDesktop: widget.isDesktop,
                                  isHovered: _isHovered,
                                  isDark: isDark,
                                  pinFoot: false,
                                  selectedTech: widget.selectedTech,
                                  onSelectTech: widget.onSelectTech,
                                  onOpenStudy: _openStudy,
                                  onFocusChange: (focused) =>
                                      setState(() => _isFocused = focused),
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
    });
  }
}
