import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../data/projects_data.dart';
import '../model/project.dart';
import '../widget/screen_shell.dart';
import 'project_modal.dart';

class ProjectsPage extends StatefulWidget {
  final bool isContinuousMobile;

  const ProjectsPage({
    super.key,
    this.isContinuousMobile = false,
  });

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  int _mobileSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= AppBreakpoints.tablet;
    final loc = AppLocalizations.of(context)!;
    final isDark = scheme.brightness == Brightness.dark;

    return AppScreenShell(
     maxWidth: 1200,
     verticalPadding: AppSpacing.xl,
     reserveBottomNav: !widget.isContinuousMobile,
     reserveMobileTop: !widget.isContinuousMobile,
     child: SingleChildScrollView(
       padding: EdgeInsets.zero,
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
         children: [
           _buildHeader(scheme, loc, size, isDesktop),
           const SizedBox(height: AppSpacing.lg),
           if (isDesktop)
             Column(
               children: [
                 Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Expanded(
                       child: SizedBox(
                         height: 360,
                         child: InteractiveProjectCard(
                           project: kProjects[0],
                           index: 0,
                           scheme: scheme,
                           isDark: isDark,
                           isDesktop: isDesktop,
                         ),
                       ),
                     ),
                     const SizedBox(width: AppSpacing.lg),
                     Expanded(
                       child: SizedBox(
                         height: 360,
                         child: InteractiveProjectCard(
                           project: kProjects[1],
                           index: 1,
                           scheme: scheme,
                           isDark: isDark,
                           isDesktop: isDesktop,
                         ),
                       ),
                     ),
                   ],
                 ),
                 const SizedBox(height: AppSpacing.lg),
                 Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Expanded(
                       child: SizedBox(
                         height: 360,
                         child: InteractiveProjectCard(
                           project: kProjects[2],
                           index: 2,
                           scheme: scheme,
                           isDark: isDark,
                           isDesktop: isDesktop,
                         ),
                       ),
                     ),
                     const SizedBox(width: AppSpacing.lg),
                     if (kProjects.length > 3)
                       Expanded(
                         child: SizedBox(
                           height: 360,
                           child: InteractiveProjectCard(
                             project: kProjects[3],
                             index: 3,
                             scheme: scheme,
                             isDark: isDark,
                             isDesktop: isDesktop,
                           ),
                         ),
                       )
                     else
                       const Spacer(),
                   ],
                 ),
               ],
             )
           else
             Column(
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: [
                 for (int i = 0; i < kProjects.length; i++) ...[
                   Container(
                     decoration: i == _mobileSelectedIndex
                         ? BoxDecoration(
                             borderRadius: BorderRadius.circular(AppRadius.md),
                             border: Border.all(
                               color: scheme.primary.withValues(alpha: 0.35),
                               width: 1,
                             ),
                           )
                         : null,
                     child: InteractiveProjectCard(
                       project: kProjects[i],
                       index: i,
                       scheme: scheme,
                       isDark: isDark,
                       isDesktop: isDesktop,
                     ),
                   ),
                   if (i < kProjects.length - 1) const SizedBox(height: AppSpacing.md),
                 ],
                 const SizedBox(height: AppSpacing.md),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     OutlinedButton.icon(
                       onPressed: () => setState(() {
                         _mobileSelectedIndex = (_mobileSelectedIndex - 1 + kProjects.length) % kProjects.length;
                       }),
                       style: OutlinedButton.styleFrom(
                         minimumSize: const Size(88, 36),
                         padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                       ),
                       icon: const Icon(Icons.chevron_left_rounded, size: 16),
                       label: const Text('PREV'),
                     ),
                     Flexible(
                       child: Padding(
                         padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                         child: Text(
                           'CASE ${_mobileSelectedIndex + 1}/${kProjects.length}',
                           textAlign: TextAlign.center,
                           style: TextStyle(
                             color: scheme.primary,
                             fontFamily: 'Courier',
                             fontWeight: FontWeight.w900,
                             letterSpacing: 1.2,
                             fontSize: 10,
                           ),
                         ),
                       ),
                     ),
                     OutlinedButton.icon(
                       onPressed: () => setState(() {
                         _mobileSelectedIndex = (_mobileSelectedIndex + 1) % kProjects.length;
                       }),
                       style: OutlinedButton.styleFrom(
                         minimumSize: const Size(88, 36),
                         padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                       ),
                       icon: const Icon(Icons.chevron_right_rounded, size: 16),
                       label: const Text('NEXT'),
                     ),
                   ],
                 ),
               ],
             ),
         ],
       ),
     ),
    );
  }

  Widget _buildHeader(ColorScheme scheme, AppLocalizations loc, Size size, bool isDesktop) {
    final isDark = scheme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: scheme.primary.withValues(alpha: 0.3)),
              ),
              child: Text(
                'CASE STUDIES',
                style: TextStyle(
                  fontFamily: 'Courier',
                  color: scheme.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Container(height: 1, color: isDark ? Colors.white24 : Colors.black12),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'SELECTED WORK',
          style: TextStyle(
            fontFamily: 'Courier',
            color: scheme.primary,
            fontWeight: FontWeight.w900,
            fontSize: 10,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          loc.navProjects,
          style: TextStyle(
            fontFamily: AppTypography.displayFont,
            color: isDark ? Colors.white : AppColors.slate900,
            fontSize: isDesktop ? 48 : 36,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            height: 1.1,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'In-depth looks at architecture, implementation, and measurable outcomes.',
          style: TextStyle(
            color: isDark ? Colors.white.withValues(alpha: 0.7) : AppColors.slate600,
            fontSize: isDesktop ? 16 : 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

}

class InteractiveProjectCard extends StatefulWidget {
  final Project project;
  final int index;
  final ColorScheme scheme;
  final bool isDark;
  final bool isDesktop;

  const InteractiveProjectCard({
    super.key,
    required this.project,
    required this.index,
    required this.scheme,
    required this.isDark,
    required this.isDesktop,
  });

  @override
  State<InteractiveProjectCard> createState() => _InteractiveProjectCardState();
}

class _InteractiveProjectCardState extends State<InteractiveProjectCard> {
  bool _isHovered = false;
  Offset _mousePos = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Read case study for ${widget.project.name}',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        onHover: (e) => setState(() => _mousePos = e.localPosition),
        child: AnimatedScale(
          scale: _isHovered && widget.isDesktop ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            elevation: widget.isDark ? 0 : (_isHovered ? 12 : 4),
            shadowColor: widget.isDark ? Colors.transparent : Colors.black.withValues(alpha: 0.15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              side: BorderSide(
                color: widget.isDark
                    ? (_isHovered ? widget.scheme.primary.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.1))
                    : (_isHovered ? widget.scheme.primary.withValues(alpha: 0.2) : Colors.transparent),
                width: 1,
              ),
            ),
            color: widget.isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
            child: InkWell(
              onTap: () => showProjectCaseStudy(context, project: widget.project, index: widget.index),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: widget.isDesktop ? 300 : 270,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image Header with Parallax & Spotlight
                    if (widget.project.heroImagePath != null)
                      SizedBox(
                        height: widget.isDesktop ? 220 : 180,
                        child: ClipRect(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              AnimatedScale(
                                scale: _isHovered && widget.isDesktop ? 1.08 : 1.0,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOutCubic,
                                child: Image.asset(
                                  widget.project.heroImagePath!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Gradient Overlay
                              AnimatedOpacity(
                                opacity: _isHovered ? 1.0 : 0.8,
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.9),
                                        Colors.black.withValues(alpha: 0.1),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Spotlight
                              if (_isHovered && widget.isDesktop)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: RadialGradient(
                                        center: FractionalOffset(
                                          (_mousePos.dx / 400).clamp(0.0, 1.0),
                                          (_mousePos.dy / 200).clamp(0.0, 1.0),
                                        ),
                                        radius: 0.6,
                                        colors: [
                                          widget.scheme.primary.withValues(alpha: 0.3),
                                          Colors.transparent,
                                        ],
                                        stops: const [0.0, 1.0],
                                      ),
                                    ),
                                  ),
                                ),
                              // Label
                              Positioned(
                                left: AppSpacing.md,
                                bottom: AppSpacing.md,
                                child: Text(
                                  widget.project.company.toUpperCase(),
                                  style: const TextStyle(
                                    fontFamily: 'Courier',
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: widget.isDesktop ? 220 : 180,
                        child: Container(
                          color: widget.scheme.primary.withValues(alpha: 0.1),
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Text(
                            widget.project.company.toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'Courier',
                              color: widget.scheme.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    // Body
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: TextStyle(
                                  fontFamily: AppTypography.displayFont,
                                  color: _isHovered
                                      ? widget.scheme.primary
                                      : (widget.isDark ? Colors.white : AppColors.slate900),
                                  fontSize: widget.isDesktop ? 22 : 18,
                                  fontWeight: FontWeight.w900,
                                  height: 1.1,
                                ),
                                child: Text(
                                  widget.project.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.project.tagline,
                                style: TextStyle(
                                  color: widget.isDark ? Colors.white.withValues(alpha: 0.7) : AppColors.slate600,
                                  fontSize: widget.isDesktop ? 13 : 12,
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          AnimatedSlide(
                            offset: _isHovered && widget.isDesktop ? const Offset(0.05, 0) : Offset.zero,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                            child: Row(
                              children: [
                                Text(
                                  'READ CASE STUDY',
                                  style: TextStyle(
                                    fontFamily: 'Courier',
                                    color: widget.scheme.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(Icons.arrow_forward_rounded, size: 14, color: widget.scheme.primary),
                              ],
                            ),
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
      ),
    );
  }
}
