import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:profile/core/services/analytics_service.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/case_study/presentation/bloc/case_study_reader_bloc.dart';
import 'package:profile/features/case_study/presentation/widgets/case_study_reveal.dart';

import 'package:profile/features/case_study/presentation/widgets/companion/companion_progress_bar.dart';
import 'package:profile/features/case_study/presentation/widgets/companion/companion_floating_dock.dart';

class CaseStudyChapter {
  const CaseStudyChapter({
    required this.id,
    required this.label,
    required this.shortLabel,
    required this.key,
  });

  final String id;
  final String label;
  final String shortLabel;
  final GlobalKey key;
}

class CaseStudyReadingCompanion extends StatefulWidget {
  const CaseStudyReadingCompanion({
    super.key,
    required this.scrollController,
    required this.chapters,
    required this.child,
  });

  final ScrollController scrollController;
  final List<CaseStudyChapter> chapters;
  final Widget child;

  @override
  State<CaseStudyReadingCompanion> createState() =>
      _CaseStudyReadingCompanionState();
}

class _CaseStudyReadingCompanionState extends State<CaseStudyReadingCompanion> {
  late final CaseStudyReaderBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CaseStudyReaderBloc(
      initialChapterId:
          widget.chapters.isNotEmpty ? widget.chapters.first.id : null,
    );
    widget.scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _measure();
    });
  }

  @override
  void didUpdateWidget(CaseStudyReadingCompanion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_onScroll);
      widget.scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _bloc.close();
    super.dispose();
  }

  bool _spyScheduled = false;

  void _onScroll() {
    if (_spyScheduled) return;
    _spyScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _spyScheduled = false;
      _measure();
    });
    WidgetsBinding.instance.scheduleFrame();
  }

  void _measure() {
    if (!mounted || !widget.scrollController.hasClients) return;

    final offset = widget.scrollController.offset;
    final maxScroll = widget.scrollController.position.maxScrollExtent;
    final progress = maxScroll > 0 ? (offset / maxScroll).clamp(0.0, 1.0) : 0.0;
    final showDock = offset > 140.0;

    String? activeId;
    String? lastUnbuilt;
    var sawBuilt = false;
    final threshold = MediaQuery.sizeOf(context).height * 0.45;
    for (final chapter in widget.chapters) {
      final box = chapter.key.currentContext?.findRenderObject();
      if (box is RenderBox && box.attached && box.hasSize) {
        sawBuilt = true;
        if (box.localToGlobal(Offset.zero).dy <= threshold) {
          activeId = chapter.id;
        } else {
          activeId ??= lastUnbuilt;
          break;
        }
      } else if (activeId == null) {
        lastUnbuilt = chapter.id;
      }
    }
    if (!sawBuilt) activeId = _bloc.state.activeChapterId;

    activeId ??= widget.chapters.isNotEmpty ? widget.chapters.first.id : null;

    _bloc.add(
        CaseStudyScrollProgressUpdated(progress: progress, showDock: showDock));
    if (activeId != null && activeId != _bloc.state.activeChapterId) {
      _bloc.add(CaseStudyChapterDetected(activeId));
    }
  }

  void _scrollToChapter(CaseStudyChapter chapter) {
    _bloc.add(CaseStudyChapterJumpRequested(chapter.id));
    SoundService.instance.playClick();
    Analytics.event('case_study_chapter_click',
        params: {'chapter': chapter.id});
    revealCaseStudySection(
      widget.scrollController,
      chapter.key,
      reduceMotion: MediaQuery.disableAnimationsOf(context),
    );
  }

  void _scrollToTop() {
    _bloc.add(const CaseStudyBackToTopRequested());
    SoundService.instance.playClick();
    Analytics.event('case_study_back_to_top');
    widget.scrollController.animateTo(
      0.0,
      duration: AppMotion.sectionScroll,
      curve: AppMotion.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    // Progress changes every scroll frame; only what shows it (the top bar
    // and the dock's percent pill) follows it. The dock and its chapter
    // chips rebuild when it shows or hides, or the chapter changes.
    return BlocProvider.value(
      value: _bloc,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification ||
              notification is OverscrollNotification) {
            _onScroll();
          }
          return false;
        },
        child: Stack(
          children: [
            widget.child,
            BlocSelector<CaseStudyReaderBloc, CaseStudyReaderState, bool>(
              selector: (state) => state.showDock,
              builder: (context, showDock) => Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 96 + MediaQuery.paddingOf(context).bottom,
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: showDock ? 1 : 0,
                    duration: AppMotion.sm,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context)
                                .scaffoldBackgroundColor
                                .withValues(alpha: 0.0),
                            Theme.of(context)
                                .scaffoldBackgroundColor
                                .withValues(alpha: 0.92),
                          ],
                          stops: const [0.0, 0.6],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            BlocSelector<CaseStudyReaderBloc, CaseStudyReaderState, double>(
              selector: (state) => state.progress,
              builder: (context, progress) => CompanionTopReadingProgressBar(
                progress: progress,
                isDark: isDark,
              ),
            ),
            BlocBuilder<CaseStudyReaderBloc, CaseStudyReaderState>(
              buildWhen: (prev, curr) =>
                  prev.showDock != curr.showDock ||
                  prev.activeChapterId != curr.activeChapterId,
              builder: (context, state) => CompanionFloatingChapterDock(
                visible: state.showDock,
                chapters: widget.chapters,
                activeChapterId: state.activeChapterId,
                onChapterTap: _scrollToChapter,
                onBackToTop: _scrollToTop,
                isDark: isDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
