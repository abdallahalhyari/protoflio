import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/features/experience/domain/repositories/experience_repository.dart';
import 'package:profile/features/experience/presentation/bloc/experience_timeline_bloc.dart';
import 'package:profile/features/experience/presentation/widgets/experience_header.dart';
import 'package:profile/shared/widget/screen_shell.dart';
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
                      child: ExperienceContinuousMobileList(
                        state: state,
                        onSelect: (idx) => _bloc.add(ExperienceNodeSelected(idx)),
                      ),
                    )
                  else
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm,
                        ),
                        child: isDesktop
                            ? ExperienceDesktopGrid(
                                state: state,
                                onSelect: (idx) => _bloc.add(ExperienceNodeSelected(idx)),
                              )
                            : ExperienceMobileList(
                                state: state,
                                onSelect: (idx) => _bloc.add(ExperienceNodeSelected(idx)),
                              ),
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
}
