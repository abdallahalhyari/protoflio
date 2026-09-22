import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/features/experience/bloc/experience_timeline_bloc.dart';
import 'package:profile/features/experience/widget/animated_experience_node.dart';
import 'package:profile/features/experience/widget/credentials_bento_card.dart';
import 'package:profile/features/experience/widget/experience_header.dart';
import 'package:profile/shared/widget/screen_shell.dart';
import 'package:profile/shared/widget/staggered_entrance.dart';

class ExperiencePage extends StatefulWidget {
  final PageController? controller;
  final int? pageIndex;
  final bool isContinuousMobile;

  const ExperiencePage({
    super.key,
    this.controller,
    this.pageIndex,
    this.isContinuousMobile = false,
  });

  @override
  State<ExperiencePage> createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final ExperienceTimelineBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ExperienceTimelineBloc(
      initialVisibility: widget.isContinuousMobile,
    );

    if (!widget.isContinuousMobile) {
      _checkVisibility();
      widget.controller?.addListener(_checkVisibility);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_checkVisibility);
    _bloc.close();
    super.dispose();
  }

  void _checkVisibility() {
    if (!mounted) return;
    if (widget.controller == null ||
        !widget.controller!.hasClients ||
        widget.controller!.positions.length != 1) {
      if (!_bloc.state.isVisible) {
        _bloc.add(const ExperienceVisibilityChanged(true));
      }
      return;
    }

    // Trigger animation when the page comes into view
    final page =
        widget.controller!.page ?? widget.controller!.initialPage.toDouble();
    final isFocused = (page - (widget.pageIndex ?? 0)).abs() < 0.3;

    if (isFocused && !_bloc.state.isVisible) {
      _bloc.add(const ExperienceVisibilityChanged(true));
      widget.controller?.removeListener(_checkVisibility);
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
        event.logicalKey == LogicalKeyboardKey.arrowRight) {
      SoundService.instance.playSelection();
      _bloc.add(const ExperienceKeyboardNavigated(1));
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
        event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      SoundService.instance.playSelection();
      _bloc.add(const ExperienceKeyboardNavigated(-1));
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin requirement
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= AppBreakpoints.tablet;

    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<ExperienceTimelineBloc, ExperienceTimelineState>(
        builder: (context, state) {
          return Focus(
            autofocus: false,
            onKeyEvent: _handleKeyEvent,
            child: AppScreenShell(
              maxWidth: 1600, // Wider for horizontal scroll
              verticalPadding: AppSpacing.md,
              reserveBottomNav: !widget.isContinuousMobile,
              reserveMobileTop: !widget.isContinuousMobile,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  ExperienceHeader(isDesktop: isDesktop),
                  const SizedBox(height: AppSpacing.sm),

                  // Timeline Grid
                  if (widget.isContinuousMobile)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                      child: _buildContinuousMobileList(context, state),
                    )
                  else
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm,
                        ),
                        child: isDesktop
                            ? _buildDesktopGrid(context, state)
                            : _buildMobileList(context, state),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContinuousMobileList(
    BuildContext context,
    ExperienceTimelineState state,
  ) {
    final experiences = state.experiences;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < experiences.length; i++) ...[
          AnimatedExperienceNode(
            exp: experiences[i],
            index: i,
            isVisible: state.isVisible,
            isSelected: state.selectedIndex == i,
            onSelect: () => _bloc.add(ExperienceNodeSelected(i)),
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

  Widget _buildDesktopGrid(
    BuildContext context,
    ExperienceTimelineState state,
  ) {
    final experiences = state.experiences;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Column 1: Experiences 0 and 1
        Expanded(
          flex: 5,
          child: StaggeredEntrance(
            isVisible: state.isVisible,
            delayMs: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (experiences.isNotEmpty)
                  Expanded(
                    flex: 5,
                    child: AnimatedExperienceNode(
                      exp: experiences[0],
                      index: 0,
                      isVisible: state.isVisible,
                      isSelected: state.selectedIndex == 0,
                      onSelect: () =>
                          _bloc.add(const ExperienceNodeSelected(0)),
                      isDesktop: true,
                    ),
                  ),
                const SizedBox(height: AppSpacing.lg),
                if (experiences.length > 1)
                  Expanded(
                    flex: 4,
                    child: AnimatedExperienceNode(
                      exp: experiences[1],
                      index: 1,
                      isVisible: state.isVisible,
                      isSelected: state.selectedIndex == 1,
                      onSelect: () =>
                          _bloc.add(const ExperienceNodeSelected(1)),
                      isDesktop: true,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.lg),

        // Column 2: Experiences 2 and 3
        Expanded(
          flex: 5,
          child: StaggeredEntrance(
            isVisible: state.isVisible,
            delayMs: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (experiences.length > 2)
                  Expanded(
                    flex: 5,
                    child: AnimatedExperienceNode(
                      exp: experiences[2],
                      index: 2,
                      isVisible: state.isVisible,
                      isSelected: state.selectedIndex == 2,
                      onSelect: () =>
                          _bloc.add(const ExperienceNodeSelected(2)),
                      isDesktop: true,
                    ),
                  ),
                const SizedBox(height: AppSpacing.lg),
                if (experiences.length > 3)
                  Expanded(
                    flex: 4,
                    child: AnimatedExperienceNode(
                      exp: experiences[3],
                      index: 3,
                      isVisible: state.isVisible,
                      isSelected: state.selectedIndex == 3,
                      onSelect: () =>
                          _bloc.add(const ExperienceNodeSelected(3)),
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

  Widget _buildMobileList(
    BuildContext context,
    ExperienceTimelineState state,
  ) {
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
          index: index,
          isVisible: state.isVisible,
          isSelected: state.selectedIndex == index,
          onSelect: () => _bloc.add(ExperienceNodeSelected(index)),
          isDesktop: false,
        );
      },
    );
  }
}
