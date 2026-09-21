import 'package:flutter/material.dart';

import 'package:profile/theme/tokens.dart';
import 'package:profile/features/experience/model/experience.dart';
import 'experience_card.dart';

/// Wraps an [ExperienceCard] with staggered entry fade and slide animations.
class AnimatedExperienceNode extends StatelessWidget {
  final Experience exp;
  final int index;
  final bool isVisible;
  final bool isDesktop;

  final bool isSelected;
  final VoidCallback? onSelect;

  const AnimatedExperienceNode({
    super.key,
    required this.exp,
    required this.index,
    required this.isVisible,
    required this.isDesktop,
    this.isSelected = false,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final card = RepaintBoundary(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: isDesktop ? 0 : AppSpacing.lg,
        ),
        child: ExperienceCard(
          exp: exp,
          scheme: scheme,
          isDesktop: isDesktop,
          isSelected: isSelected,
          onSelect: onSelect,
        ),
      ),
    );

    if (MediaQuery.disableAnimationsOf(context)) {
      return card;
    }

    return AnimatedOpacity(
      duration: AppMotion.sectionScroll,
      curve: AppMotion.emphasized,
      opacity: isVisible ? 1.0 : 0.0,
      child: AnimatedSlide(
        duration: AppMotion.sectionScroll,
        curve: AppMotion.emphasized,
        offset: isVisible
            ? Offset.zero
            : (isDesktop ? const Offset(0.2, 0) : const Offset(0, 0.2)),
        child: card,
      ),
    );
  }
}
