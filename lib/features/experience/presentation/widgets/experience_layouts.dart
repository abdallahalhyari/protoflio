import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/experience/presentation/bloc/experience_timeline_bloc.dart';
import 'package:profile/features/experience/presentation/widgets/animated_experience_node.dart';
import 'package:profile/features/experience/presentation/widgets/credentials_bento_card.dart';
import 'package:profile/features/experience/presentation/widgets/experience_timeline_connector.dart';
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
          if (i < experiences.length - 1)
            ExperienceTimelineConnector(
              isAdjacentSelected: state.selectedIndex == i ||
                  state.selectedIndex == i + 1,
              isCurrent: experiences[i]
                      .period
                      .toLowerCase()
                      .contains('present') ||
                  experiences[i + 1]
                      .period
                      .toLowerCase()
                      .contains('present'),
            )
          else
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
        Expanded(
          flex: 7,
          child: StaggeredEntrance(
            isVisible: state.isVisible,
            child: GridView.builder(
              key: const Key('experience_chronology'),
              primary: false,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 1.3,
              ),
              itemCount: experiences.length,
              itemBuilder: (context, index) => AnimatedExperienceNode(
                exp: experiences[index],
                isVisible: state.isVisible,
                isSelected: state.selectedIndex == index,
                onSelect: () => onSelect(index),
                isDesktop: true,
              ),
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
            ),
            if (index < experiences.length - 1)
              ExperienceTimelineConnector(
                isAdjacentSelected: state.selectedIndex == index ||
                    state.selectedIndex == index + 1,
                isCurrent: experiences[index]
                        .period
                        .toLowerCase()
                        .contains('present') ||
                    experiences[index + 1]
                        .period
                        .toLowerCase()
                        .contains('present'),
              )
            else
              const SizedBox(height: AppSpacing.md),
          ],
        );
      },
    );
  }
}
