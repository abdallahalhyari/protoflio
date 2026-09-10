import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/tokens.dart';
import '../../../service/sound_service.dart';
import '../data/projects_data.dart';
import '../model/project.dart';
import '../widget/screen_shell.dart';
import '../widget/swipe_affordance.dart';

class ProjectsPage extends StatefulWidget {
  final PageController? controller;
  final int? pageIndex;
  final bool isContinuousMobile;

  const ProjectsPage({
    super.key,
    this.controller,
    this.pageIndex,
    this.isContinuousMobile = false,
  });

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  int _selectedIndex = 0;
  final ScrollController _articleScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _articleScrollController.dispose();
    super.dispose();
  }

  void _selectProject(int index) {
    if (_selectedIndex == index) return;
    SoundService.instance.playClick();
    setState(() => _selectedIndex = index);
    if (_articleScrollController.hasClients) {
      _articleScrollController.jumpTo(0.0);
    }
  }

  void _nextProject() {
    SoundService.instance.playClick();
    setState(() => _selectedIndex = (_selectedIndex + 1) % kProjects.length);
  }

  void _prevProject() {
    SoundService.instance.playClick();
    setState(() => _selectedIndex = (_selectedIndex - 1 + kProjects.length) % kProjects.length);
  }

  Future<void> _openProjectUrl(String url) async {
    SoundService.instance.playClick();
    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open $url'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Zero-padded 2-digit ordinal for the tile / feature number.
  /// Was previously written as `_ordinal(index)` inline everywhere —
  /// works today (4 projects) but breaks at 10+.
  String _ordinal(int index) => (index + 1).toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= AppBreakpoints.tablet;
    final loc = AppLocalizations.of(context)!;
    final currentProject = kProjects[_selectedIndex];

    return AppScreenShell(
      maxWidth: 1200,
      verticalPadding: widget.isContinuousMobile ? AppSpacing.md : AppSpacing.md,
      reserveBottomNav: !widget.isContinuousMobile,
      reserveMobileTop: !widget.isContinuousMobile,
      child: isDesktop
            // DESKTOP: Master-Detail 2-Column (Zero nested vertical scroll!)
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                    // Left Column: Header + 4 Project Selector Tiles
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildHeader(scheme, loc, size, isDesktop),
                          const SizedBox(height: 12),
                          Container(height: 1, color: scheme.onSurface.withValues(alpha: 0.12)),
                          const SizedBox(height: 12),

                          // 4 Interactive Project Tiles (No scroll needed, exactly 4 tiles!)
                          Expanded(
                            child: ListView(
                              primary: false,
                              padding: EdgeInsets.zero,
                              physics: const ClampingScrollPhysics(),
                              children: [
                                for (int i = 0; i < kProjects.length; i++) ...[
                                  _buildDesktopProjectTile(
                                    project: kProjects[i],
                                    index: i,
                                    isSelected: _selectedIndex == i,
                                    scheme: scheme,
                                  ),
                                  if (i < kProjects.length - 1)
                                    const SizedBox(height: 16),
                                ],
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),
                          _buildFootnote(scheme),
                        ],
                      ),
                    ),

                    const SizedBox(width: AppSpacing.xl),

                    // Right Column: Feature Magazine Case Study Spread
                    Expanded(
                      flex: 7,
                      child: SingleChildScrollView(
                        controller: _articleScrollController,
                        padding: EdgeInsets.zero,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: _buildMagazineArticle(currentProject, _selectedIndex, scheme, size, isDesktop),
                        ),
                      ),
                    ),
                  ],
                )
            // MOBILE: Compact paginated spread
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(scheme, loc, size, isDesktop),
                  const SizedBox(height: 10),

                  // Compact Project Tabs
                  _buildMobileProjectTabs(scheme),
                  const SizedBox(height: 8),
                  _buildSwipeAffordance(scheme),
                  const SizedBox(height: 8),
                  Container(height: 1, color: scheme.onSurface.withValues(alpha: 0.12)),
                  const SizedBox(height: 10),

                  // Selected Project Case Study
                  if (widget.isContinuousMobile)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity != null) {
                          if (details.primaryVelocity! < -200) {
                            _nextProject();
                          } else if (details.primaryVelocity! > 200) {
                            _prevProject();
                          }
                        }
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.04, 0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: KeyedSubtree(
                          key: ValueKey('project_article_${currentProject.name}'),
                          child: _buildMagazineArticle(currentProject, _selectedIndex, scheme, size, isDesktop),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.zero,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: _buildMagazineArticle(currentProject, _selectedIndex, scheme, size, isDesktop),
                        ),
                      ),
                    ),

                  const SizedBox(height: 10),
                  // Mobile Pagination Bar (< PREV · NEXT >)
                  _buildMobilePagination(scheme),
                  const SizedBox(height: 6),
                  _buildFootnote(scheme),
                ],
              ),
    );
  }

  Widget _buildHeader(ColorScheme scheme, AppLocalizations loc, Size size, bool isDesktop) {
    // Premium magazine-feature masthead: kicker rule + eyebrow +
    // display headline + separator rule + right-side meta pill.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
            height: 2, color: scheme.primary.withValues(alpha: 0.9)),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isDesktop
                        ? 'FEATURE 02 · SELECTED CASE STUDIES'
                        : 'FEATURE 02 · SELECTED WORK',
                    style: TextStyle(
                      color: scheme.primary,
                      fontSize: isDesktop ? 11 : 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      loc.navProjects.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Tenada',
                        color: scheme.onSurface,
                        fontSize: (size.width * 0.05).clamp(24.0, 48.0),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Enterprise mobile suites shipped to production',
                    style: TextStyle(
                      color: scheme.onSurface.withValues(alpha: 0.75),
                      fontSize: isDesktop ? 12.5 : 11.5,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            if (isDesktop)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                      color: scheme.primary.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('✦',
                        style: TextStyle(
                            color: AppColors.accentAmber, fontSize: 11)),
                    const SizedBox(width: 6),
                    Text(
                      '${kProjects.length} SUITES · 4+ YEARS',
                      style: TextStyle(
                        color: scheme.primary,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
            height: 0.75, color: scheme.primary.withValues(alpha: 0.5)),
      ],
    );
  }

  Widget _buildDesktopProjectTile({
    required Project project,
    required int index,
    required bool isSelected,
    required ColorScheme scheme,
  }) {
    final isDark = scheme.brightness == Brightness.dark;
    return Semantics(
      button: true,
      selected: isSelected,
      label:
          '${project.company} — ${project.name}${isSelected ? ", selected" : ""}',
      child: InkWell(
        onTap: () => _selectProject(index),
        borderRadius: BorderRadius.circular(12),
        focusColor: scheme.primary.withValues(alpha: 0.25),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? scheme.primary.withValues(alpha: isDark ? 0.18 : 0.12)
                    : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.85)),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? scheme.primary.withValues(alpha: 0.8)
                      : (isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0)),
                  width: isSelected ? 1.5 : 1.0,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: scheme.primary.withValues(alpha: 0.25),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ]
                    : (isDark
                        ? []
                        : [
                            BoxShadow(
                              color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]),
              ),
              child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? scheme.primary : (isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _ordinal(index),
                style: TextStyle(
                  fontFamily: 'Courier',
                  color: isSelected ? (isDark ? Colors.black : Colors.white) : (isDark ? Colors.white70 : const Color(0xFF475569)),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    project.company.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Courier',
                      color: isSelected ? scheme.primary : scheme.onSurface.withValues(alpha: 0.52),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    project.name.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Tenada',
                      color: isSelected ? (isDark ? Colors.white : scheme.primary) : scheme.onSurface.withValues(alpha: 0.85),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.arrow_forward_rounded : Icons.chevron_right_rounded,
              color: isSelected ? scheme.primary : scheme.onSurface.withValues(alpha: 0.3),
              size: 16,
            ),
          ],
        ),
      ),
      ),
      ),
    );
  }

  Widget _buildMobileProjectTabs(ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < kProjects.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            InkWell(
              onTap: () => _selectProject(i),
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _selectedIndex == i
                          ? scheme.primary.withValues(alpha: isDark ? 0.22 : 0.15)
                          : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.85)),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _selectedIndex == i
                            ? scheme.primary.withValues(alpha: 0.9)
                            : (isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFCBD5E1)),
                        width: _selectedIndex == i ? 1.4 : 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: _selectedIndex == i ? scheme.primary : (isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _ordinal(i),
                            style: TextStyle(
                              fontFamily: 'Courier',
                              color: _selectedIndex == i ? (isDark ? Colors.black : Colors.white) : (isDark ? Colors.white70 : const Color(0xFF475569)),
                              fontSize: 9.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          kProjects[i].company.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Courier',
                            color: _selectedIndex == i ? (isDark ? Colors.white : scheme.primary) : scheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 9.5,
                            fontWeight: _selectedIndex == i ? FontWeight.w800 : FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSwipeAffordance(ColorScheme scheme) {
    return SwipeAffordance(
      label:
          'SWIPE OR TAP TO SWITCH CASE STUDIES (${_selectedIndex + 1}/${kProjects.length})',
    );
  }

  Widget _buildMobilePagination(ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton.icon(
          onPressed: _prevProject,
          style: OutlinedButton.styleFrom(
            foregroundColor: isDark ? Colors.white70 : const Color(0xFF334155),
            side: BorderSide(color: isDark ? Colors.white24 : const Color(0xFFCBD5E1)),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: const Size(0, 32),
          ),
          icon: const Icon(Icons.chevron_left, size: 14),
          label: const Text('PREV', style: TextStyle(fontFamily: 'Courier', fontSize: 9.5, fontWeight: FontWeight.w700)),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < kProjects.length; i++)
              InkWell(
                onTap: () => _selectProject(i),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _selectedIndex == i ? 18 : 6,
                    height: 5,
                    decoration: BoxDecoration(
                      color: _selectedIndex == i ? scheme.primary : (isDark ? Colors.white24 : const Color(0xFFCBD5E1)),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
          ],
        ),
        OutlinedButton.icon(
          onPressed: _nextProject,
          style: OutlinedButton.styleFrom(
            foregroundColor: isDark ? Colors.white70 : const Color(0xFF334155),
            side: BorderSide(color: isDark ? Colors.white24 : const Color(0xFFCBD5E1)),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: const Size(0, 32),
          ),
          icon: const Icon(Icons.chevron_right, size: 14),
          label: const Text('NEXT', style: TextStyle(fontFamily: 'Courier', fontSize: 9.5, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }

  Widget _buildMagazineArticle(Project project, int index, ColorScheme scheme, Size size, bool isDesktop) {
    final isDark = scheme.brightness == Brightness.dark;
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            constraints: BoxConstraints(maxWidth: isDesktop ? 780 : 960),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? scheme.primary.withValues(alpha: 0.5) : const Color(0xFFCBD5E1),
                width: isDark ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black.withValues(alpha: 0.5) : const Color(0xFF0F172A).withValues(alpha: 0.06),
                  blurRadius: 22,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: scheme.primary.withValues(alpha: isDark ? 0.15 : 0.08),
                  blurRadius: 20,
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.02, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Column(
                key: ValueKey(project.name),
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Accent Rule
            Container(
              height: 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [scheme.primary, const Color(0xFFC084FC)],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 20 : 14,
                vertical: isDesktop ? 16 : 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dateline Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: scheme.primary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                project.company.toUpperCase(),
                                style: TextStyle(
                                  fontFamily: 'Courier',
                                  color: scheme.primary,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                isDesktop ? 'FEATURE ARTICLE // VOL. ${_ordinal(index)}' : 'VOL. ${_ordinal(index)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Courier',
                                  color: isDark ? Colors.white.withValues(alpha: 0.6) : const Color(0xFF64748B),
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (project.url != null)
                        InkWell(
                          onTap: () => _openProjectUrl(project.url!),
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: scheme.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color:
                                      scheme.primary.withValues(alpha: 0.5)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'VISIT',
                                  style: TextStyle(
                                    fontFamily: 'Courier',
                                    color: scheme.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                Icon(Icons.arrow_outward,
                                    size: 11, color: scheme.primary),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Project Headline
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      project.name.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Tenada',
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        fontSize: isDesktop ? 38 : 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.5,
                        height: 1.05,
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Tagline
                  Text(
                    project.tagline,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.white.withValues(alpha: 0.85) : const Color(0xFF334155),
                      fontSize: isDesktop ? 13 : 11.5,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 1. Context Paragraph
                  if (project.context != null) ...[
                    Text(
                      project.context!,
                      style: TextStyle(
                        color: isDark ? Colors.white.withValues(alpha: 0.8) : const Color(0xFF334155),
                        fontSize: isDesktop ? 12.0 : 11.0,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // 2. The Architectural Dossier (Glass Bentos)
                  _buildPipelineTopology(project, scheme, isDesktop),
                  if (project.problem != null)
                    _buildDossierRow('CORE PROBLEM', project.problem!, const Color(0xFFF87171), isDesktop, isDark),
                  if (project.architecture != null)
                    _buildDossierRow('ARCHITECTURE', project.architecture!, AppColors.accentIndigo, isDesktop, isDark),
                  if (project.solution != null)
                    _buildDossierRow('ENGINEERING SOLUTION', project.solution!, AppColors.accentGreen, isDesktop, isDark),
                  if (project.technicalDecisions != null && project.technicalDecisions!.isNotEmpty)
                    _buildDossierRow('DECISION', project.technicalDecisions!.first, const Color(0xFFFDE68A), isDesktop, isDark),
                  if (project.lessonsLearned != null)
                    _buildDossierRow('LESSON LEARNED', project.lessonsLearned!, const Color(0xFFFBBF24), isDesktop, isDark),

                  const SizedBox(height: 8),
                  Container(height: 1, color: isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
                  const SizedBox(height: 16),

                  // 3. Key Highlights & Measurable Results
                  for (int i = 0; i < (isDesktop ? math.min(3, project.highlights.length) : math.min(2, project.highlights.length)); i++)
                    _buildHighlightRow(project.highlights[i], scheme, isDesktop, isDark),

                  if (project.results != null && project.results!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 1.5),
                          child: Icon(Icons.check_circle_outline, color: AppColors.accentGreen, size: isDesktop ? 13 : 11),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'MEASURABLE OUTCOME: ',
                                  style: TextStyle(
                                    fontFamily: 'Courier',
                                    color: AppColors.accentGreen,
                                    fontSize: isDesktop ? 10.5 : 9.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                TextSpan(
                                  text: project.results!.first,
                                  style: TextStyle(
                                    color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF1E293B),
                                    fontSize: isDesktop ? 11 : 9.5,
                                  ),
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 16),

                  // 4. Tech Stack Chips
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      for (final tech in project.stack)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
                          ),
                          child: Text(
                            tech.toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'Courier',
                              color: isDark ? scheme.primary : const Color(0xFF4338CA),
                              fontSize: isDesktop ? 9.5 : 8.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  ),
),
);
  }

  Widget _buildPipelineTopology(Project project, ColorScheme scheme, bool isDesktop) {
    final isDark = scheme.brightness == Brightness.dark;
    List<String> pipeline;
    if (project.name.contains('NatHealth')) {
      pipeline = const ['NFC APDU', 'Keystore JWT', 'Offline SQLite', 'WorkManager', 'HTTPS TPA'];
    } else if (project.name.contains('ESKADENIA')) {
      pipeline = const ['Feature PKG', 'MVVM Models', 'Service Locator', 'Cache Store', 'Hospital REST'];
    } else if (project.name.contains('FAIS')) {
      pipeline = const ['Onboarding UI', 'Inspection Form', 'Blob Storage', 'WorkManager Sync', 'Core ERP'];
    } else if (project.name.contains('Solutions Now')) {
      pipeline = const ['GPS Stream', 'Native Service', 'Local DB', 'Batch Sync', 'Fleet Command'];
    } else {
      pipeline = project.stack.take(5).toList();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 10 : 8, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withValues(alpha: 0.35) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: scheme.primary.withValues(alpha: isDark ? 0.25 : 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF34D399),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'PRODUCTION PIPELINE TOPOLOGY',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Courier',
                    color: scheme.primary,
                    fontSize: isDesktop ? 9.0 : 8.0,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < pipeline.length; i++) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: isDark ? 0.08 : 0.06),
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: scheme.primary.withValues(alpha: isDark ? 0.3 : 0.25)),
                    ),
                    child: Text(
                      pipeline[i].toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Courier',
                        color: isDark ? Colors.white.withValues(alpha: 0.95) : const Color(0xFF0F172A),
                        fontSize: isDesktop ? 9.5 : 8.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (i < pipeline.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: isDesktop ? 11 : 9.5,
                        color: scheme.primary.withValues(alpha: 0.7),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDossierRow(String label, String value, Color accentColor, bool isDesktop, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
            padding: EdgeInsets.all(isDesktop ? 12 : 10),
            decoration: BoxDecoration(
              color: isDark ? accentColor.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.90),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: accentColor.withValues(alpha: isDark ? 0.28 : 0.4), width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: isDark ? 0.05 : 0.04),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.api_rounded, size: 12, color: accentColor),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        color: accentColor,
                        fontSize: isDesktop ? 10.0 : 9.0,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    color: isDark ? Colors.white.withValues(alpha: 0.95) : const Color(0xFF1E293B),
                    fontSize: isDesktop ? 12.5 : 11.0,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildHighlightRow(String highlight, ColorScheme scheme, bool isDesktop, bool isDark) {
    final colonIndex = highlight.indexOf(':');
    final hasColon = colonIndex != -1;
    final prefix = hasColon ? highlight.substring(0, colonIndex + 1) : '';
    final rest = hasColon ? highlight.substring(colonIndex + 1) : highlight;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '§ ',
            style: TextStyle(
              fontFamily: 'Courier',
              color: scheme.primary,
              fontWeight: FontWeight.w900,
              fontSize: isDesktop ? 12.5 : 11.0,
            ),
          ),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  if (hasColon)
                    TextSpan(
                      text: '$prefix ',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        color: isDark ? const Color(0xFFFDE68A) : const Color(0xFFB45309),
                        fontWeight: FontWeight.w800,
                        fontSize: isDesktop ? 12.0 : 10.5,
                      ),
                    ),
                  TextSpan(
                    text: rest.trim(),
                    style: TextStyle(
                      color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF334155),
                      fontSize: isDesktop ? 12.0 : 10.5,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFootnote(ColorScheme scheme) {
    return Text(
      '✦ SELECT ANY ENTERPRISE CASE STUDY TO LOAD ARCHITECTURAL DOSSIER ✦',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Courier',
        color: scheme.onSurface.withValues(alpha: 0.5),
        fontSize: 9.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}
