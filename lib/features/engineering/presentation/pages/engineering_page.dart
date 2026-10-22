import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/core/services/sound_service.dart';

import 'package:profile/features/engineering/domain/repositories/architecture_repository.dart';
import 'package:profile/features/engineering/presentation/bloc/architecture_simulator_bloc.dart';
import 'package:profile/features/engineering/presentation/bloc/architecture_simulator_event.dart';
import 'package:profile/features/engineering/presentation/bloc/architecture_simulator_state.dart';
import 'package:profile/features/engineering/data/datasources/architecture_data.dart';
import 'package:profile/features/engineering/domain/entities/architecture_topic.dart';
import 'package:profile/features/engineering/presentation/widgets/architecture_details.dart';
import 'package:profile/features/engineering/presentation/widgets/layer_stack.dart';
import 'package:profile/features/engineering/presentation/widgets/architecture_topic_tabs.dart';
import 'package:profile/features/engineering/presentation/widgets/engineering_header.dart';
import 'package:profile/shared/widgets/screen_shell.dart';

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

/// Engineering: five architectures, one at a time. The chips pick one; its
/// layers run down a teal line beside what it is, why, what it costs, its
/// safeguards and where it ran.
class _EngineeringPageViewState extends State<_EngineeringPageView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDesktop = AppBreakpoints.isDesktop(context);
    final reduceMotion = AppMedia.reduceMotion(context);

    final chips = BlocSelector<ArchitectureSimulatorBloc,
        ArchitectureSimulatorState, int>(
      selector: (state) => state.selectedTopicIndex,
      builder: (context, selectedTopicIndex) => ArchitectureTopicTabs(
        topics: kArchitectureTopics,
        selectedIndex: selectedTopicIndex,
        onSelectTopic: (index) {
          SoundService.instance.playClick();
          context
              .read<ArchitectureSimulatorBloc>()
              .add(SimulatorTopicSelected(index));
        },
      ),
    );

    // Picking a topic swaps the view with a short fade: it answers the
    // tap and shows that the content changed.
    final view = BlocSelector<ArchitectureSimulatorBloc,
        ArchitectureSimulatorState, ArchitectureTopic>(
      selector: (state) => state.currentTopic,
      builder: (context, topic) => AnimatedSwitcher(
        duration: reduceMotion ? Duration.zero : AppMotion.switcher,
        layoutBuilder: (current, previous) => Stack(
          alignment: Alignment.topCenter,
          children: [...previous, if (current != null) current],
        ),
        child: KeyedSubtree(
          key: ValueKey('arch_topic_${topic.id}'),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: LayerStack(topic: topic)),
                    const SizedBox(width: AppSpacing.xl),
                    Expanded(flex: 6, child: ArchitectureDetails(topic: topic)),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LayerStack(topic: topic),
                    const SizedBox(height: AppSpacing.xl),
                    ArchitectureDetails(topic: topic),
                  ],
                ),
        ),
      ),
    );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EngineeringHeader(isDesktop: isDesktop),
        const SizedBox(height: AppSpacing.sectionContent),
        chips,
        const SizedBox(height: AppSpacing.xl),
        view,
        const SizedBox(height: AppSpacing.lg),
      ],
    );

    return AppScreenShell(
      maxWidth: kSectionMaxWidth,
      verticalPadding: AppSpacing.md,
      reserveBottomNav: !widget.isContinuousMobile,
      reserveMobileTop: !widget.isContinuousMobile,
      child: widget.isContinuousMobile
          ? content
          : SingleChildScrollView(
              primary: false,
              physics: const ClampingScrollPhysics(),
              child: content,
            ),
    );
  }
}
