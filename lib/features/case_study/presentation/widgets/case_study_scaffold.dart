import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/core/services/analytics_service.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/shell/presentation/widgets/page_background.dart';
import 'package:profile/features/case_study/presentation/widgets/case_study_corporate_header.dart';
import 'package:profile/features/case_study/presentation/widgets/case_study_layout.dart';
import 'package:profile/features/case_study/presentation/widgets/case_study_reading_companion.dart';

/// Encapsulates the GlobalKeys for standard case study chapters.
class CaseStudyChapterKeys {
  final GlobalKey problemKey = GlobalKey();
  final GlobalKey roleKey = GlobalKey();
  final GlobalKey archKey = GlobalKey();
  final GlobalKey outcomesKey = GlobalKey();
  final GlobalKey lessonsKey = GlobalKey();

  List<CaseStudyChapter> buildStandardChapters(AppLocalizations l10n) => [
        CaseStudyChapter(
          id: 'problem',
          label: '01 ${l10n.studyDockProblem}',
          shortLabel: l10n.studyDockProblemShort,
          key: problemKey,
        ),
        CaseStudyChapter(
          id: 'role',
          label: '02 ${l10n.studyDockRole}',
          shortLabel: l10n.studyDockRole,
          key: roleKey,
        ),
        CaseStudyChapter(
          id: 'architecture',
          label: '03 ${l10n.studyDockArch}',
          shortLabel: l10n.studyDockArch,
          key: archKey,
        ),
        CaseStudyChapter(
          id: 'outcomes',
          label: '07 ${l10n.studyDockOutcomes}',
          shortLabel: l10n.studyDockOutcomesShort,
          key: outcomesKey,
        ),
        CaseStudyChapter(
          id: 'lessons',
          label: '08 ${l10n.studyDockLessons}',
          shortLabel: l10n.studyDockLessons,
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
  });

  final String slug;
  final String appBarTitle;
  final String shareTitle;
  final List<Widget> Function(
    BuildContext context,
    CaseStudyChapterKeys keys,
    bool isDesktop,
  ) sliversBuilder;

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
    final isDesktop = AppBreakpoints.isDesktop(context);
    final hPad = CaseStudyLayout.horizontalPadding(context);

    final chapters = _keys.buildStandardChapters(AppLocalizations.of(context)!);

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
                  tooltip: AppLocalizations.of(context)!.studyBackToPortfolio,
                  onPressed: () {
                    Analytics.event('case_study_back',
                        params: {'study': widget.slug});
                    Navigator.of(context).maybePop();
                  },
                ),
                title: Text(
                  widget.appBarTitle,
                  style: TextStyle(
                    fontSize: AppTypography.label,
                    fontWeight: FontWeight.w800,
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
