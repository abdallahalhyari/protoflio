import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';
import '../../../service/sound_service.dart';

import '../data/architecture_data.dart';
import '../widget/engineering/architecture_details_card.dart';
import '../widget/engineering/architecture_diagram_card.dart';
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

  @override
  bool get wantKeepAlive => true;

  void _selectTopic(int index) {
    if (_selectedTopicIndex == index) return;
    SoundService.instance.playClick();
    setState(() => _selectedTopicIndex = index);
  }

  void _nextTopic() {
    SoundService.instance.playClick();
    setState(() => _selectedTopicIndex =
        (_selectedTopicIndex + 1) % kArchitectureTopics.length);
  }

  void _prevTopic() {
    SoundService.instance.playClick();
    setState(() => _selectedTopicIndex =
        (_selectedTopicIndex - 1 + kArchitectureTopics.length) %
            kArchitectureTopics.length);
  }

  Widget _buildSwipeAffordance() {
    return SwipeAffordance(
      margin: const EdgeInsets.only(top: 6),
      label:
          'SWIPE OR TAP TO SWITCH ARCHITECTURAL BLUEPRINTS (${_selectedTopicIndex + 1}/${kArchitectureTopics.length})',
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
                      ArchitectureDiagramCard(
                        topic: activeTopic,
                        isDesktop: isDesktop,
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
                          child: ArchitectureDiagramCard(
                            topic: activeTopic,
                            isDesktop: isDesktop,
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
                        ArchitectureDiagramCard(
                          topic: activeTopic,
                          isDesktop: isDesktop,
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
  }
}
