import 'package:flutter/material.dart';

import '../../../../theme/tokens.dart';
import '../../model/experience.dart';
import 'experience_card.dart';

/// Wraps an [ExperienceCard] with staggered entry fade and slide animations.
class AnimatedExperienceNode extends StatelessWidget {
  final Experience exp;
  final int index;
  final bool isVisible;
  final bool isDesktop;

  const AnimatedExperienceNode({
    super.key,
    required this.exp,
    required this.index,
    required this.isVisible,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final card = Padding(
      padding: EdgeInsets.only(
        bottom: isDesktop ? 0 : AppSpacing.lg,
      ),
      child: ExperienceCard(exp: exp, scheme: scheme, isDesktop: isDesktop),
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
