import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/experience/presentation/bloc/experience_timeline_bloc.dart';
import 'package:profile/features/experience/presentation/widgets/animated_experience_node.dart';
import 'package:profile/features/experience/presentation/widgets/credentials_bento_card.dart';
import 'package:profile/shared/widgets/staggered_entrance.dart';

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
            isDesktop: false,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        CredentialsBentoCard(
          isVisible: state.isVisible,
          isDesktop: false,
        ),
      ],
    );
  }
}

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
    final experiences = state.experiences;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Column 1: Experiences 0 and 2
        Expanded(
          flex: 5,
          child: StaggeredEntrance(
            isVisible: state.isVisible,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (experiences.isNotEmpty)
                  Expanded(
                    flex: 5,
                    child: AnimatedExperienceNode(
                      exp: experiences[0],
                      isVisible: state.isVisible,
                      isSelected: state.selectedIndex == 0,
                      onSelect: () => onSelect(0),
                      isDesktop: true,
                    ),
                  ),
                const SizedBox(height: AppSpacing.lg),
                if (experiences.length > 2)
                  Expanded(
                    flex: 4,
                    child: AnimatedExperienceNode(
                      exp: experiences[2],
                      isVisible: state.isVisible,
                      isSelected: state.selectedIndex == 2,
                      onSelect: () => onSelect(2),
                      isDesktop: true,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.lg),

        // Column 2: Experiences 1 and 3
        Expanded(
          flex: 5,
          child: StaggeredEntrance(
            isVisible: state.isVisible,
            delayMs: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (experiences.length > 1)
                  Expanded(
                    flex: 5,
                    child: AnimatedExperienceNode(
                      exp: experiences[1],
                      isVisible: state.isVisible,
                      isSelected: state.selectedIndex == 1,
                      onSelect: () => onSelect(1),
                      isDesktop: true,
                    ),
                  ),
                const SizedBox(height: AppSpacing.lg),
                if (experiences.length > 3)
                  Expanded(
                    flex: 4,
                    child: AnimatedExperienceNode(
                      exp: experiences[3],
                      isVisible: state.isVisible,
                      isSelected: state.selectedIndex == 3,
                      onSelect: () => onSelect(3),
                      isDesktop: true,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.lg),

        // Column 3: Credentials Bento
        Expanded(
          flex: 4,
          child: StaggeredEntrance(
            isVisible: state.isVisible,
            delayMs: 160,
            child: CredentialsBentoCard(
              isVisible: state.isVisible,
              isDesktop: true,
            ),
          ),
        ),
      ],
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
        return AnimatedExperienceNode(
          exp: experiences[index],
          isVisible: state.isVisible,
          isSelected: state.selectedIndex == index,
          onSelect: () => onSelect(index),
          isDesktop: false,
        );
      },
    );
  }
}
