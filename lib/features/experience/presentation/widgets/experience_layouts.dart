import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/experience/presentation/bloc/experience_timeline_bloc.dart';
import 'package:profile/features/experience/presentation/widgets/animated_experience_node.dart';
import 'package:profile/features/experience/presentation/widgets/credentials_bento_card.dart';
import 'package:profile/shared/widgets/staggered_entrance.dart';

/// The roles in order, newest first, on one continuous spine. A career is
/// a sequence, so it reads as one column at natural height rather than a
/// grid of fixed-size tiles that clip their own text.
class _Timeline extends StatelessWidget {
  const _Timeline({
    super.key,
    required this.state,
    required this.onSelect,
    required this.isDesktop,
  });

  final ExperienceTimelineState state;
  final Function(int) onSelect;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final experiences = state.experiences;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < experiences.length; i++) ...[
          AnimatedExperienceNode(
            exp: experiences[i],
            isVisible: state.isVisible,
            isSelected: state.selectedIndex == i,
            onSelect: () => onSelect(i),
            isDesktop: isDesktop,
            isFirst: i == 0,
            isLast: i == experiences.length - 1,
          ),
          if (i == experiences.length - 1)
            const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class ExperienceContinuousMobileList extends StatelessWidget {
  final ExperienceTimelineState state;
  final Function(int) onSelect;

  const ExperienceContinuousMobileList({
    super.key,
    required this.state,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Timeline(state: state, onSelect: onSelect, isDesktop: false),
        CredentialsBentoCard(
          isVisible: state.isVisible,
          isDesktop: false,
        ),
      ],
    );
  }
}

/// Desktop: the timeline beside the academic and certification card. The
/// page scrolls (like About), so every role shows its full text.
class ExperienceDesktopGrid extends StatelessWidget {
  final ExperienceTimelineState state;
  final Function(int) onSelect;

  const ExperienceDesktopGrid({
    super.key,
    required this.state,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: false,
      physics: const ClampingScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 7,
            child: StaggeredEntrance(
              isVisible: state.isVisible,
              child: _Timeline(
                key: const Key('experience_chronology'),
                state: state,
                onSelect: onSelect,
                isDesktop: true,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 4,
            child: StaggeredEntrance(
              isVisible: state.isVisible,
              delayMs: 120,
              child: CredentialsBentoCard(
                isVisible: state.isVisible,
                isDesktop: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExperienceMobileList extends StatelessWidget {
  final ExperienceTimelineState state;
  final Function(int) onSelect;

  const ExperienceMobileList({
    super.key,
    required this.state,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final experiences = state.experiences;
    return ListView.builder(
      padding: EdgeInsets.zero,
      primary: false,
      physics: const ClampingScrollPhysics(),
      itemCount: experiences.length + 1,
      itemBuilder: (context, index) {
        if (index == experiences.length) {
          return CredentialsBentoCard(
            isVisible: state.isVisible,
            isDesktop: false,
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedExperienceNode(
              exp: experiences[index],
              isVisible: state.isVisible,
              isSelected: state.selectedIndex == index,
              onSelect: () => onSelect(index),
              isDesktop: false,
              isFirst: index == 0,
              isLast: index == experiences.length - 1,
            ),
            if (index == experiences.length - 1)
              const SizedBox(height: AppSpacing.md),
          ],
        );
      },
    );
  }
}
