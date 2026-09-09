import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/tokens.dart';
import '../../../service/sound_service.dart';
import '../data/projects_data.dart';
import '../model/project.dart';

class ProjectsPage extends StatefulWidget {
  final PageController? controller;
  final int? pageIndex;

  const ProjectsPage({super.key, this.controller, this.pageIndex});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _selectProject(int index) {
    if (_selectedIndex == index) return;
    SoundService.instance.playPageTurn();
    setState(() => _selectedIndex = index);
  }

  void _nextProject() {
    SoundService.instance.playClick();
    setState(() => _selectedIndex = (_selectedIndex + 1) % kProjects.length);
  }

  void _prevProject() {
    SoundService.instance.playClick();
    setState(() => _selectedIndex = (_selectedIndex - 1 + kProjects.length) % kProjects.length);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= 960;
    final loc = AppLocalizations.of(context)!;
    final currentProject = kProjects[_selectedIndex];

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            isDesktop ? AppSpacing.xxl : AppSpacing.md,
            AppSpacing.sm,
            isDesktop ? AppSpacing.xxl : AppSpacing.md,
            AppSpacing.xs,
          ),
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

                    // Right Column: Feature Magazine Case Study Spread (Self-contained, zero nested scroll!)
                    Expanded(
                      flex: 7,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: _buildMagazineArticle(currentProject, _selectedIndex, scheme, size, isDesktop),
                      ),
                    ),
                  ],
                )
              // MOBILE: Compact paginated spread (Zero nested scroll!)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(scheme, loc, size, isDesktop),
                    const SizedBox(height: 8),

                    // Compact Project Tabs
                    _buildMobileProjectTabs(scheme),
                    const SizedBox(height: 8),
                    Container(height: 1, color: scheme.onSurface.withValues(alpha: 0.12)),
                    const SizedBox(height: 8),

                    // Selected Project Case Study (Fitted to screen height)
                    Expanded(
                      child: Center(
                        child: _buildMagazineArticle(currentProject, _selectedIndex, scheme, size, isDesktop),
                      ),
                    ),

                    const SizedBox(height: 6),
                    // Mobile Pagination Bar (< PREV · NEXT >)
                    _buildMobilePagination(scheme),
                    const SizedBox(height: 4),
                    _buildFootnote(scheme),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme scheme, AppLocalizations loc, Size size, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(width: 18, height: 2, color: scheme.primary),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      isDesktop ? 'INDEX // CASE STUDIES & DEPLOYMENTS' : 'INDEX // CASE STUDIES',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        color: scheme.primary,
                        fontSize: isDesktop ? 10.5 : 9.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: isDesktop ? 2 : 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                loc.navProjects.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Tenada',
                  color: scheme.onSurface,
                  fontSize: (size.width * 0.038).clamp(20.0, 36.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
        if (isDesktop)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: scheme.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('✦', style: TextStyle(color: Color(0xFFFBBF24), fontSize: 10)),
                const SizedBox(width: 5),
                Text(
                  '4 SUITES',
                  style: TextStyle(
                    fontFamily: 'Courier',
                    color: scheme.primary,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDesktopProjectTile({
    required Project project,
    required int index,
    required bool isSelected,
    required ColorScheme scheme,
  }) {
    return InkWell(
      onTap: () => _selectProject(index),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? scheme.primary.withValues(alpha: 0.14)
              : Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? scheme.primary
                : scheme.onSurface.withValues(alpha: 0.12),
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Left Index Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: isSelected ? scheme.primary : Colors.white12,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '0${index + 1}',
                style: TextStyle(
                  fontFamily: 'Courier',
                  color: isSelected ? Colors.black : Colors.white70,
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
                      color: isSelected ? scheme.primary : scheme.onSurface.withValues(alpha: 0.5),
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
                      color: isSelected ? Colors.white : scheme.onSurface.withValues(alpha: 0.85),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.arrow_forward : Icons.chevron_right,
              color: isSelected ? scheme.primary : scheme.onSurface.withValues(alpha: 0.3),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileProjectTabs(ColorScheme scheme) {
    return Row(
      children: [
        for (int i = 0; i < kProjects.length; i++) ...[
          if (i > 0) const SizedBox(width: 4),
          Expanded(
            child: InkWell(
              onTap: () => _selectProject(i),
              borderRadius: BorderRadius.circular(6),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                decoration: BoxDecoration(
                  color: _selectedIndex == i
                      ? scheme.primary.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _selectedIndex == i
                        ? scheme.primary
                        : scheme.onSurface.withValues(alpha: 0.15),
                    width: _selectedIndex == i ? 1.5 : 1.0,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '0${i + 1}',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        color: _selectedIndex == i ? scheme.primary : scheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 9.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      kProjects[i].company.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        color: _selectedIndex == i ? Colors.white : scheme.onSurface.withValues(alpha: 0.7),
                        fontSize: 8.5,
                        fontWeight: _selectedIndex == i ? FontWeight.w800 : FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMobilePagination(ColorScheme scheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton.icon(
          onPressed: _prevProject,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white70,
            side: const BorderSide(color: Colors.white24),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          ),
          icon: const Icon(Icons.chevron_left, size: 16),
          label: const Text('PREV', style: TextStyle(fontFamily: 'Courier', fontSize: 10, fontWeight: FontWeight.w700)),
        ),
        Text(
          'DOSSIER 0${_selectedIndex + 1} / 0${kProjects.length}',
          style: TextStyle(
            fontFamily: 'Courier',
            color: scheme.primary,
            fontSize: 10.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        OutlinedButton.icon(
          onPressed: _nextProject,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white70,
            side: const BorderSide(color: Colors.white24),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          ),
          icon: const Icon(Icons.chevron_right, size: 16),
          label: const Text('NEXT', style: TextStyle(fontFamily: 'Courier', fontSize: 10, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }

  Widget _buildMagazineArticle(Project project, int index, ColorScheme scheme, Size size, bool isDesktop) {
    return Container(
      constraints: BoxConstraints(maxWidth: isDesktop ? 780 : 960),
      decoration: BoxDecoration(
        color: const Color(0xFF0D121B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.45), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 22,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.12),
            blurRadius: 20,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Column(
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
                                isDesktop ? 'FEATURE ARTICLE // VOL. 0${index + 1}' : 'VOL. 0${index + 1}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Courier',
                                  color: Colors.white.withValues(alpha: 0.6),
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
                          onTap: () => launchUrl(Uri.parse(project.url!)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              'VISIT ↗',
                              style: TextStyle(
                                fontFamily: 'Courier',
                                color: scheme.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Project Headline
                  Text(
                    project.name.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Tenada',
                      color: Colors.white,
                      fontSize: isDesktop ? 22 : 17,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      height: 1.1,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Tagline
                  Text(
                    project.tagline,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: isDesktop ? 13 : 11.5,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 8),
                  Container(height: 1, color: Colors.white12),
                  const SizedBox(height: 8),

                  // Key Highlights with Bold Lead-ins (Showing up to 3 on desktop, 2 on mobile)
                  for (int i = 0; i < (isDesktop ? math.min(3, project.highlights.length) : math.min(2, project.highlights.length)); i++)
                    _buildHighlightRow(project.highlights[i], scheme, isDesktop),

                  const SizedBox(height: 8),

                  // Tech Stack Chips
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      for (final tech in project.stack)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Text(
                            tech.toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'Courier',
                              color: scheme.primary,
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
    );
  }

  Widget _buildHighlightRow(String highlight, ColorScheme scheme, bool isDesktop) {
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
                        color: const Color(0xFFFDE68A),
                        fontWeight: FontWeight.w800,
                        fontSize: isDesktop ? 12.0 : 10.5,
                      ),
                    ),
                  TextSpan(
                    text: rest.trim(),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
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
