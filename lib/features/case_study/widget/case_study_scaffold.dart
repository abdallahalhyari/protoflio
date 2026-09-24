import 'package:flutter/material.dart';

import 'package:profile/service/analytics_service.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/features/shell/widget/page_background.dart';
import 'case_study_corporate_header.dart';
import 'case_study_layout.dart';
import 'case_study_reading_companion.dart';

/// Encapsulates the GlobalKeys for standard case study chapters.
class CaseStudyChapterKeys {
  final GlobalKey problemKey = GlobalKey();
  final GlobalKey roleKey = GlobalKey();
  final GlobalKey archKey = GlobalKey();
  final GlobalKey outcomesKey = GlobalKey();
  final GlobalKey lessonsKey = GlobalKey();

  List<CaseStudyChapter> buildStandardChapters() => [
        CaseStudyChapter(
          id: 'problem',
          label: '01 PROBLEM',
          shortLabel: 'PROB',
          key: problemKey,
        ),
        CaseStudyChapter(
          id: 'role',
          label: '02 ROLE',
          shortLabel: 'ROLE',
          key: roleKey,
        ),
        CaseStudyChapter(
          id: 'architecture',
          label: '03 ARCH',
          shortLabel: 'ARCH',
          key: archKey,
        ),
        CaseStudyChapter(
          id: 'outcomes',
          label: '07 OUTCOMES',
          shortLabel: 'RESULTS',
          key: outcomesKey,
        ),
        CaseStudyChapter(
          id: 'lessons',
          label: '08 LESSONS',
          shortLabel: 'LESSONS',
          key: lessonsKey,
        ),
      ];
}

/// Unified layout scaffold for enterprise case studies.
/// Encapsulates the scroll controller, reading companion dock, pinned sliver
/// app bar, back navigation with analytics, and responsive margin padding.
class CaseStudyScaffold extends StatefulWidget {
  const CaseStudyScaffold({
    super.key,
    required this.slug,
    required this.appBarTitle,
    required this.shareTitle,
    required this.sliversBuilder,
    this.customChaptersBuilder,
  });

  final String slug;
  final String appBarTitle;
  final String shareTitle;
  final List<Widget> Function(
    BuildContext context,
    CaseStudyChapterKeys keys,
    bool isDesktop,
  ) sliversBuilder;
  final List<CaseStudyChapter> Function(CaseStudyChapterKeys keys)?
      customChaptersBuilder;

  @override
  State<CaseStudyScaffold> createState() => _CaseStudyScaffoldState();
}

class _CaseStudyScaffoldState extends State<CaseStudyScaffold> {
  late final ScrollController _scrollController;
  late final CaseStudyChapterKeys _keys;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _keys = CaseStudyChapterKeys();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = MediaQuery.sizeOf(context).width >= AppBreakpoints.tablet;
    final hPad = CaseStudyLayout.horizontalPadding(context);

    final chapters = widget.customChaptersBuilder?.call(_keys) ??
        _keys.buildStandardChapters();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PageBackground(
        child: CaseStudyReadingCompanion(
          scrollController: _scrollController,
          chapters: chapters,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: isDark
                    ? AppColors.darkSurface.withValues(alpha: 0.94)
                    : Colors.white.withValues(alpha: 0.94),
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  tooltip: 'Back to portfolio',
                  onPressed: () {
                    Analytics.event('case_study_back',
                        params: {'study': widget.slug});
                    Navigator.of(context).maybePop();
                  },
                ),
                title: Text(
                  widget.appBarTitle,
                  style: TextStyle(
                    fontSize: AppTypography.overline,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.4,
                    color: scheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
                actions: [
                  CaseStudyToolbarShareButton(
                    slug: widget.slug,
                    title: widget.shareTitle,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
              ),
              SliverPadding(
                // Bottom clears the floating reading dock (≈44px pill, 16–24px
                // off the edge) so the closing "Back to portfolio" CTA isn't
                // tucked under it.
                padding: EdgeInsets.fromLTRB(
                  hPad,
                  AppSpacing.xl,
                  hPad,
                  AppSpacing.xl + 72 + MediaQuery.paddingOf(context).bottom,
                ),
                sliver: SliverList.list(
                  children: widget.sliversBuilder(context, _keys, isDesktop),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
