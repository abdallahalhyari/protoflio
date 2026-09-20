import 'dart:async';
import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';
import '../../../service/sound_service.dart';

import '../data/architecture_data.dart';
import '../model/architecture_topic.dart';
import '../widget/engineering/architecture_details_card.dart';
import '../widget/engineering/architecture_diagram_card.dart';
import '../widget/engineering/architecture_inspect_modal.dart';
import '../widget/engineering/architecture_topic_tabs.dart';
import '../widget/engineering/engineering_header.dart';
import '../widget/screen_shell.dart';
import '../widget/swipe_affordance.dart';

class EngineeringPage extends StatefulWidget {
  final bool isContinuousMobile;

  const EngineeringPage({
    super.key,
    this.isContinuousMobile = false,
  });

  @override
  State<EngineeringPage> createState() => _EngineeringPageState();
}

class _EngineeringPageState extends State<EngineeringPage>
    with AutomaticKeepAliveClientMixin {
  int _selectedTopicIndex = 0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _simulatorTimer;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _simulatorTimer?.cancel();
    super.dispose();
  }

  void _stopPlayback() {
    _simulatorTimer?.cancel();
    _isPlaying = false;
  }

  void _selectTopic(int index) {
    if (_selectedTopicIndex == index) return;
    SoundService.instance.playClick();
    _stopPlayback();
    setState(() {
      _selectedTopicIndex = index;
      _currentStepIndex = 0;
    });
  }

  void _nextTopic() {
    SoundService.instance.playClick();
    _stopPlayback();
    setState(() {
      _selectedTopicIndex =
          (_selectedTopicIndex + 1) % kArchitectureTopics.length;
      _currentStepIndex = 0;
    });
  }

  void _prevTopic() {
    SoundService.instance.playClick();
    _stopPlayback();
    setState(() {
      _selectedTopicIndex =
          (_selectedTopicIndex - 1 + kArchitectureTopics.length) %
              kArchitectureTopics.length;
      _currentStepIndex = 0;
    });
  }

  void _togglePlay(int maxSteps) {
    if (_isPlaying) {
      _stopPlayback();
      setState(() {});
    } else {
      _isPlaying = true;
      _simulatorTimer?.cancel();
      _simulatorTimer = Timer.periodic(const Duration(milliseconds: 2200), (_) {
        if (!mounted) return;
        setState(() {
          _currentStepIndex = (_currentStepIndex + 1) % maxSteps;
        });
        SoundService.instance.playSelection();
      });
      setState(() {});
    }
  }

  void _stepNext(int maxSteps) {
    _stopPlayback();
    setState(() {
      _currentStepIndex = (_currentStepIndex + 1).clamp(0, maxSteps - 1);
    });
  }

  void _stepPrev(int maxSteps) {
    _stopPlayback();
    setState(() {
      _currentStepIndex = (_currentStepIndex - 1).clamp(0, maxSteps - 1);
    });
  }

  void _resetStep() {
    _stopPlayback();
    setState(() {
      _currentStepIndex = 0;
    });
  }

  Widget _buildSwipeAffordance() {
    return SwipeAffordance(
      margin: const EdgeInsets.only(top: 6),
      label:
          'SWIPE OR TAP TO SWITCH ARCHITECTURAL BLUEPRINTS (${_selectedTopicIndex + 1}/${kArchitectureTopics.length})',
    );
  }

  Widget _buildDiagramCard(ArchitectureTopic topic, bool isDesktop) {
    final maxSteps = topic.diagramSteps.length;
    return ArchitectureDiagramCard(
      topic: topic,
      isDesktop: isDesktop,
      activeStepIndex: _currentStepIndex,
      isPlaying: _isPlaying,
      onSelectStep: (step) {
        _stopPlayback();
        setState(() => _currentStepIndex = step);
        SoundService.instance.playSelection();
      },
      onPreviousStep: () => _stepPrev(maxSteps),
      onNextStep: () => _stepNext(maxSteps),
      onTogglePlay: () => _togglePlay(maxSteps),
      onResetStep: _resetStep,
      onInspect: () {
        showArchitectureInspectModal(
          context,
          topic: topic,
          currentStep: _currentStepIndex,
          onStepChanged: (step) => setState(() => _currentStepIndex = step),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin requirement
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= AppBreakpoints.tablet;
    final activeTopic = kArchitectureTopics[_selectedTopicIndex];

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
            selectedIndex: _selectedTopicIndex,
            onSelectTopic: _selectTopic,
            isDesktop: isDesktop,
          ),
          if (!isDesktop) _buildSwipeAffordance(),
          const SizedBox(height: AppSpacing.md),
          if (widget.isContinuousMobile)
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity != null) {
                  if (details.primaryVelocity! < -200) {
                    _nextTopic();
                  } else if (details.primaryVelocity! > 200) {
                    _prevTopic();
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
                      _buildDiagramCard(activeTopic, isDesktop),
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
                          child: _buildDiagramCard(activeTopic, isDesktop),
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
                        _buildDiagramCard(activeTopic, isDesktop),
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
  }
}
