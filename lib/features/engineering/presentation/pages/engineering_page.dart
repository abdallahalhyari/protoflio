import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/core/services/sound_service.dart';

import 'package:profile/features/engineering/domain/repositories/architecture_repository.dart';
import 'package:profile/features/engineering/presentation/bloc/architecture_simulator_bloc.dart';
import 'package:profile/features/engineering/presentation/bloc/architecture_simulator_event.dart';
import 'package:profile/features/engineering/presentation/bloc/architecture_simulator_state.dart';
import 'package:profile/features/engineering/data/datasources/architecture_data.dart';
import 'package:profile/features/engineering/domain/entities/architecture_topic.dart';
import 'package:profile/features/engineering/presentation/widgets/architecture_details_card.dart';
import 'package:profile/features/engineering/presentation/widgets/architecture_diagram_card.dart';
import 'package:profile/features/engineering/presentation/widgets/architecture_inspect_modal.dart';
import 'package:profile/features/engineering/presentation/widgets/architecture_topic_tabs.dart';
import 'package:profile/features/engineering/presentation/widgets/engineering_header.dart';
import 'package:profile/shared/widgets/screen_shell.dart';
import 'package:profile/shared/widgets/swipe_affordance.dart';
import 'package:profile/shared/widgets/text_tabs.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/features/about/presentation/about_navigation.dart';
import 'package:profile/features/engineering/presentation/widgets/capabilities_view.dart';
import 'package:profile/features/shell/presentation/controllers/home_controller.dart';

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

    ArchitectureRepository? repo;
    try {
      repo = context.read<ArchitectureRepository>();
    } catch (_) {
      repo = null;
    }

    return BlocProvider<ArchitectureSimulatorBloc>(
      create: (_) => ArchitectureSimulatorBloc(repository: repo),
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

  /// 0: the four architectures; 1: the capabilities behind them.
  int _view = 0;

  Widget _buildSwipeAffordance(int selectedIndex) {
    return SwipeAffordance(
      margin: const EdgeInsets.only(top: 6),
      label: AppLocalizations.of(context)!
          .engSwipeHint(selectedIndex + 1, kArchitectureTopics.length),
    );
  }

  Widget _buildDiagramCard(
    BuildContext context,
    ArchitectureTopic topic,
    int currentStepIndex,
    bool isDesktop,
  ) {
    return ArchitectureDiagramCard(
      topic: topic,
      isDesktop: isDesktop,
      activeStepIndex: currentStepIndex,
      onSelectStep: (step) {
        SoundService.instance.playSelection();
        context
            .read<ArchitectureSimulatorBloc>()
            .add(SimulatorStepSelected(step));
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
    final isDesktop = AppBreakpoints.isDesktop(context);

    return BlocListener<ArchitectureSimulatorBloc, ArchitectureSimulatorState>(
      listenWhen: (prev, curr) =>
          prev.currentStepIndex != curr.currentStepIndex,
      listener: (context, state) {
        SoundService.instance.playSelection();
      },
      child: AppScreenShell(
        maxWidth: kSectionMaxWidth,
        verticalPadding: AppSpacing.md,
        reserveBottomNav: !widget.isContinuousMobile,
        reserveMobileTop: !widget.isContinuousMobile,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EngineeringHeader(isDesktop: isDesktop),
            const SizedBox(height: AppSpacing.sm),
            TextTabs(
              labels: [
                AppLocalizations.of(context)!.engTabArchitectures,
                AppLocalizations.of(context)!.engTabCapabilities,
              ],
              selected: _view,
              accent:
                  context.isDarkMode ? AppColors.goldSoft : AppColors.goldDeep,
              onSelect: (i) => setState(() => _view = i),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (_view == 1) ...[
              if (widget.isContinuousMobile)
                CapabilitiesView(
                  isDesktop: isDesktop,
                  onTryDemo: _openPlayground,
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    primary: false,
                    child: CapabilitiesView(
                      isDesktop: isDesktop,
                      onTryDemo: _openPlayground,
                    ),
                  ),
                ),
            ] else ...[
              BlocSelector<ArchitectureSimulatorBloc,
                  ArchitectureSimulatorState, int>(
                selector: (state) => state.selectedTopicIndex,
                builder: (context, selectedTopicIndex) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ArchitectureTopicTabs(
                        topics: kArchitectureTopics,
                        selectedIndex: selectedTopicIndex,
                        onSelectTopic: (index) {
                          SoundService.instance.playClick();
                          context
                              .read<ArchitectureSimulatorBloc>()
                              .add(SimulatorTopicSelected(index));
                        },
                      ),
                      if (!isDesktop) _buildSwipeAffordance(selectedTopicIndex),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              if (widget.isContinuousMobile)
                BlocBuilder<ArchitectureSimulatorBloc,
                    ArchitectureSimulatorState>(
                  buildWhen: (prev, curr) =>
                      prev.selectedTopicIndex != curr.selectedTopicIndex ||
                      prev.currentStepIndex != curr.currentStepIndex,
                  builder: (context, state) {
                    final activeTopic = state.currentTopic;
                    final selectedTopicIndex = state.selectedTopicIndex;
                    final currentStepIndex = state.currentStepIndex;

                    return GestureDetector(
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
                              begin: const Offset(0.03, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: ScaleTransition(
                              scale: Tween<double>(begin: 0.98, end: 1.0)
                                  .animate(animation),
                              child: child,
                            ),
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
                    );
                  },
                )
              else
                Expanded(
                  child: isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 6,
                              child: BlocBuilder<ArchitectureSimulatorBloc,
                                  ArchitectureSimulatorState>(
                                buildWhen: (prev, curr) =>
                                    prev.selectedTopicIndex !=
                                        curr.selectedTopicIndex ||
                                    prev.currentStepIndex !=
                                        curr.currentStepIndex,
                                builder: (context, state) {
                                  return _buildDiagramCard(
                                    context,
                                    state.currentTopic,
                                    state.currentStepIndex,
                                    isDesktop,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            Expanded(
                              flex: 5,
                              child: BlocSelector<
                                  ArchitectureSimulatorBloc,
                                  ArchitectureSimulatorState,
                                  ArchitectureTopic>(
                                selector: (state) => state.currentTopic,
                                builder: (context, activeTopic) {
                                  return ArchitectureDetailsCard(
                                    topic: activeTopic,
                                    isDesktop: isDesktop,
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : ListView(
                          primary: false,
                          padding: EdgeInsets.zero,
                          physics: const ClampingScrollPhysics(),
                          children: [
                            BlocBuilder<ArchitectureSimulatorBloc,
                                ArchitectureSimulatorState>(
                              buildWhen: (prev, curr) =>
                                  prev.selectedTopicIndex !=
                                      curr.selectedTopicIndex ||
                                  prev.currentStepIndex !=
                                      curr.currentStepIndex,
                              builder: (context, state) {
                                return _buildDiagramCard(
                                  context,
                                  state.currentTopic,
                                  state.currentStepIndex,
                                  isDesktop,
                                );
                              },
                            ),
                            const SizedBox(height: AppSpacing.md),
                            BlocSelector<ArchitectureSimulatorBloc,
                                ArchitectureSimulatorState, ArchitectureTopic>(
                              selector: (state) => state.currentTopic,
                              builder: (context, activeTopic) {
                                return ArchitectureDetailsCard(
                                  topic: activeTopic,
                                  isDesktop: isDesktop,
                                );
                              },
                            ),
                            const SizedBox(height: AppSpacing.lg),
                          ],
                        ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  void _openPlayground() {
    SoundService.instance.playClick();
    aboutTabRequest.value = AboutTabs.playground;
    HomeController.maybeOf(context)?.goTo(5);
  }
}
