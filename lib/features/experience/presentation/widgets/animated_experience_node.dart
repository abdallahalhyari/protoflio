import 'package:flutter/material.dart';

import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/experience/domain/entities/experience.dart';
import 'package:profile/features/experience/presentation/widgets/experience_card.dart';

/// Wraps an [ExperienceCard] in the timeline's entry fade. Fade only: a
/// slide would pull a role's spine segment out of line with its
/// neighbours while it arrives.
class AnimatedExperienceNode extends StatelessWidget {
  final Experience exp;
  final bool isVisible;
  final bool isDesktop;

  final bool isSelected;
  final VoidCallback? onSelect;
  final bool isFirst;
  final bool isLast;

  const AnimatedExperienceNode({
    super.key,
    required this.exp,
    required this.isVisible,
    required this.isDesktop,
    this.isSelected = false,
    this.onSelect,
    this.isFirst = true,
    this.isLast = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final card = RepaintBoundary(
      child: ExperienceCard(
        exp: exp,
        scheme: scheme,
        isDesktop: isDesktop,
        isSelected: isSelected,
        onSelect: onSelect,
        isFirst: isFirst,
        isLast: isLast,
      ),
    );

    if (MediaQuery.disableAnimationsOf(context)) {
      return card;
    }

    return AnimatedOpacity(
      duration: AppMotion.sectionScroll,
      curve: AppMotion.emphasized,
      opacity: isVisible ? 1.0 : 0.0,
      child: card,
    );
  }
}
