import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/features/case_study/bloc/case_study_reader_bloc.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/shared/widget/conditional_blur.dart';
import 'package:profile/features/case_study/widget/case_study_reading_companion.dart';
import 'package:profile/features/case_study/widget/companion/companion_dock_components.dart';

class CompanionFloatingChapterDock extends StatelessWidget {
  const CompanionFloatingChapterDock({
    super.key,
    required this.visible,
    required this.chapters,
    required this.activeChapterId,
    required this.onChapterTap,
    required this.onBackToTop,
    required this.isDark,
  });

  final bool visible;
  final List<CaseStudyChapter> chapters;
  final String? activeChapterId;
  final ValueChanged<CaseStudyChapter> onChapterTap;
  final VoidCallback onBackToTop;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < AppBreakpoints.tablet;

    return Positioned(
      bottom: isCompact ? 16 : 24,
      left: 12,
      right: 12,
      child: Center(
        child: RepaintBoundary(
          child: AnimatedSlide(
            offset: visible ? Offset.zero : const Offset(0, 1.4),
            duration: AppMotion.sm,
            curve: Curves.easeOutCubic,
            child: AnimatedOpacity(
              opacity: visible ? 1.0 : 0.0,
              duration: AppMotion.sm,
              curve: Curves.easeOutCubic,
              child: IgnorePointer(
                ignoring: !visible,
                child: Container(
                  key: const Key('case_study_chapter_dock'),
                  constraints:
                      BoxConstraints(maxWidth: math.max(0.0, screenWidth - 24)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    boxShadow: context.dockShadows,
                  ),
                  child: ConditionalBlur(
                    sigma: 20,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: context.dockSurface,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(
                          color: context.dockBorder,
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize:
                            isCompact ? MainAxisSize.max : MainAxisSize.min,
                        children: [
                          // Only the percent follows every scroll frame; the dock around it
                          // rebuilds when it shows, hides or the chapter changes.
                          BlocSelector<CaseStudyReaderBloc,
                              CaseStudyReaderState, double>(
                            selector: (state) => state.progress,
                            builder: (context, progress) =>
                                CompanionReadingPercentPill(
                              progress: progress,
                              isDark: isDark,
                              isCompact: isCompact,
                            ),
                          ),
                          const SizedBox(width: 8),
                          CompanionDockDivider(isDark: isDark),
                          const SizedBox(width: 8),
                          if (isCompact)
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: _buildChapters(isCompact: true),
                                ),
                              ),
                            )
                          else
                            Flexible(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: _buildChapters(isCompact: false),
                                ),
                              ),
                            ),
                          const SizedBox(width: 8),
                          CompanionDockDivider(isDark: isDark),
                          const SizedBox(width: 8),
                          CompanionBackToTopPill(
                            onTap: onBackToTop,
                            isDark: isDark,
                            isCompact: isCompact,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChapters({required bool isCompact}) {
    final list = <Widget>[];
    for (int i = 0; i < chapters.length; i++) {
      final ch = chapters[i];
      if (i > 0) list.add(const SizedBox(width: 4));
      list.add(CompanionChapterPill(
        chapter: ch,
        isActive: ch.id == activeChapterId,
        isCompact: isCompact,
        isDark: isDark,
        onTap: () => onChapterTap(ch),
      ));
    }
    return list;
  }
}
