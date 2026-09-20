import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/service/sound_service.dart';

import 'package:profile/features/engineering/bloc/architecture_simulator_bloc.dart';
import 'package:profile/features/engineering/bloc/architecture_simulator_event.dart';
import 'package:profile/features/engineering/bloc/architecture_simulator_state.dart';
import '../data/architecture_data.dart';
import '../model/architecture_topic.dart';
import 'package:profile/features/engineering/widget/architecture_details_card.dart';
import 'package:profile/features/engineering/widget/architecture_diagram_card.dart';
import 'package:profile/features/engineering/widget/architecture_inspect_modal.dart';
import 'package:profile/features/engineering/widget/architecture_topic_tabs.dart';
import 'package:profile/features/engineering/widget/engineering_header.dart';
import 'package:profile/shared/widget/screen_shell.dart';
import 'package:profile/shared/widget/swipe_affordance.dart';

class EngineeringPage extends StatelessWidget {
  final bool isContinuousMobile;

  const EngineeringPage({
    super.key,
    this.isContinuousMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    ArchitectureSimulatorBloc? bloc;
    try {
      bloc = context.read<ArchitectureSimulatorBloc>();
    } catch (_) {
      bloc = null;
    }

    if (bloc != null) {
      return _EngineeringPageView(isContinuousMobile: isContinuousMobile);
    }

    return BlocProvider<ArchitectureSimulatorBloc>(
      create: (_) => ArchitectureSimulatorBloc(),
      child: _EngineeringPageView(isContinuousMobile: isContinuousMobile),
    );
  }
}

class _EngineeringPageView extends StatefulWidget {
  final bool isContinuousMobile;

  const _EngineeringPageView({required this.isContinuousMobile});

  @override
  State<_EngineeringPageView> createState() => _EngineeringPageViewState();
}

class _EngineeringPageViewState extends State<_EngineeringPageView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Widget _buildSwipeAffordance(int selectedIndex) {
    return SwipeAffordance(
      margin: const EdgeInsets.only(top: 6),
      label:
          'SWIPE OR TAP TO SWITCH ARCHITECTURAL BLUEPRINTS (${selectedIndex + 1}/${kArchitectureTopics.length})',
    );
  }

  Widget _buildDiagramCard(
    BuildContext context,
    ArchitectureTopic topic,
    int currentStepIndex,
    bool isPlaying,
    bool isDesktop,
  ) {
    return ArchitectureDiagramCard(
      topic: topic,
      isDesktop: isDesktop,
      activeStepIndex: currentStepIndex,
      isPlaying: isPlaying,
      onSelectStep: (step) {
        SoundService.instance.playSelection();
        context
            .read<ArchitectureSimulatorBloc>()
            .add(SimulatorStepSelected(step));
      },
      onPreviousStep: () {
        SoundService.instance.playClick();
        context
            .read<ArchitectureSimulatorBloc>()
            .add(const SimulatorPreviousStepRequested());
      },
      onNextStep: () {
        SoundService.instance.playClick();
        context
            .read<ArchitectureSimulatorBloc>()
            .add(const SimulatorNextStepRequested());
      },
      onTogglePlay: () {
        SoundService.instance.playClick();
        context
            .read<ArchitectureSimulatorBloc>()
            .add(const SimulatorAutoPlayToggled());
      },
      onResetStep: () {
        SoundService.instance.playClick();
        context
            .read<ArchitectureSimulatorBloc>()
            .add(const SimulatorResetRequested());
      },
      onInspect: () {
        showArchitectureInspectModal(
          context,
          topic: topic,
          currentStep: currentStepIndex,
          onStepChanged: (step) {
            context
                .read<ArchitectureSimulatorBloc>()
                .add(SimulatorStepSelected(step));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= AppBreakpoints.tablet;

    return BlocConsumer<ArchitectureSimulatorBloc, ArchitectureSimulatorState>(
      listenWhen: (prev, curr) =>
          prev.currentStepIndex != curr.currentStepIndex && curr.isPlaying,
      listener: (context, state) {
        SoundService.instance.playSelection();
      },
      builder: (context, state) {
        final activeTopic = state.currentTopic;
        final selectedTopicIndex = state.selectedTopicIndex;
        final currentStepIndex = state.currentStepIndex;
        final isPlaying = state.isPlaying;

        return AppScreenShell(
          maxWidth: 1280,
          verticalPadding: AppSpacing.md,
          reserveBottomNav: !widget.isContinuousMobile,
          reserveMobileTop: !widget.isContinuousMobile,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              EngineeringHeader(isDesktop: isDesktop),
              const SizedBox(height: AppSpacing.sm),
              ArchitectureTopicTabs(
                topics: kArchitectureTopics,
                selectedIndex: selectedTopicIndex,
                onSelectTopic: (index) {
                  SoundService.instance.playClick();
                  context
                      .read<ArchitectureSimulatorBloc>()
                      .add(SimulatorTopicSelected(index));
                },
                isDesktop: isDesktop,
              ),
              if (!isDesktop) _buildSwipeAffordance(selectedTopicIndex),
              const SizedBox(height: AppSpacing.md),
              if (widget.isContinuousMobile)
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity != null) {
                      if (details.primaryVelocity! < -200) {
                        SoundService.instance.playClick();
                        final nextIndex = (selectedTopicIndex + 1) %
                            kArchitectureTopics.length;
                        context
                            .read<ArchitectureSimulatorBloc>()
                            .add(SimulatorTopicSelected(nextIndex));
                      } else if (details.primaryVelocity! > 200) {
                        SoundService.instance.playClick();
                        final prevIndex = (selectedTopicIndex -
                                1 +
                                kArchitectureTopics.length) %
                            kArchitectureTopics.length;
                        context
                            .read<ArchitectureSimulatorBloc>()
                            .add(SimulatorTopicSelected(prevIndex));
                      }
                    }
                  },
                  child: AnimatedSwitcher(
                    duration: AppMotion.switcher,
                    switchInCurve: AppMotion.emphasized,
                    switchOutCurve: AppMotion.emphasizedAccel,
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.04, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
                    child: KeyedSubtree(
                      key: ValueKey('arch_topic_${activeTopic.id}'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildDiagramCard(
                            context,
                            activeTopic,
                            currentStepIndex,
                            isPlaying,
                            isDesktop,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          ArchitectureDetailsCard(
                            topic: activeTopic,
                            isDesktop: isDesktop,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 6,
                              child: _buildDiagramCard(
                                context,
                                activeTopic,
                                currentStepIndex,
                                isPlaying,
                                isDesktop,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            Expanded(
                              flex: 5,
                              child: ArchitectureDetailsCard(
                                topic: activeTopic,
                                isDesktop: isDesktop,
                              ),
                            ),
                          ],
                        )
                      : ListView(
                          primary: false,
                          padding: EdgeInsets.zero,
                          physics: const ClampingScrollPhysics(),
                          children: [
                            _buildDiagramCard(
                              context,
                              activeTopic,
                              currentStepIndex,
                              isPlaying,
                              isDesktop,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            ArchitectureDetailsCard(
                              topic: activeTopic,
                              isDesktop: isDesktop,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                          ],
                        ),
                ),
            ],
          ),
        );
      },
    );
  }
}
