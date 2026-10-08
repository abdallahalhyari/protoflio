import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/experience/domain/repositories/experience_repository.dart';
import 'package:profile/features/experience/presentation/bloc/experience_timeline_bloc.dart';
import 'package:profile/features/experience/presentation/widgets/experience_header.dart';
import 'package:profile/shared/widgets/screen_shell.dart';
import 'package:profile/features/experience/presentation/widgets/experience_layouts.dart';

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
      repository: context.read<ExperienceRepository>(),
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
    if (_bloc.state.isVisible) {
      widget.controller?.removeListener(_checkVisibility);
      return;
    }

    if (widget.controller == null ||
        !widget.controller!.hasClients ||
        widget.controller!.positions.length != 1) {
      _bloc.add(const ExperienceVisibilityChanged(true));
      widget.controller?.removeListener(_checkVisibility);
      return;
    }

    // Start as the page begins to arrive, so content is already rising as
    // the scan line uncovers it instead of appearing after an empty reveal.
    final page =
        widget.controller!.page ?? widget.controller!.initialPage.toDouble();
    final isFocused = (page - (widget.pageIndex ?? 0)).abs() < 0.95;

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
    final isDesktop = AppBreakpoints.isDesktop(context);

    return BlocProvider.value(
      value: _bloc,
      child: Focus(
        onKeyEvent: _handleKeyEvent,
        child: AppScreenShell(
          maxWidth: kSectionMaxWidth,
          verticalPadding: AppSpacing.md,
          reserveBottomNav: !widget.isContinuousMobile,
          reserveMobileTop: !widget.isContinuousMobile,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              ExperienceHeader(isDesktop: isDesktop),
              const SizedBox(height: AppSpacing.sectionContent),

              // Timeline Grid
              if (widget.isContinuousMobile)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.sm,
                  ),
                  child: BlocBuilder<ExperienceTimelineBloc,
                      ExperienceTimelineState>(
                    buildWhen: (prev, curr) =>
                        prev.selectedIndex != curr.selectedIndex ||
                        prev.isVisible != curr.isVisible ||
                        prev.experiences != curr.experiences,
                    builder: (context, state) {
                      return ExperienceContinuousMobileList(
                        state: state,
                        onSelect: (idx) =>
                            _bloc.add(ExperienceNodeSelected(idx)),
                      );
                    },
                  ),
                )
              else
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    child: BlocBuilder<ExperienceTimelineBloc,
                        ExperienceTimelineState>(
                      buildWhen: (prev, curr) =>
                          prev.selectedIndex != curr.selectedIndex ||
                          prev.isVisible != curr.isVisible ||
                          prev.experiences != curr.experiences,
                      builder: (context, state) {
                        return isDesktop
                            ? ExperienceDesktopGrid(
                                state: state,
                                onSelect: (idx) =>
                                    _bloc.add(ExperienceNodeSelected(idx)),
                              )
                            : ExperienceMobileList(
                                state: state,
                                onSelect: (idx) =>
                                    _bloc.add(ExperienceNodeSelected(idx)),
                              );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
