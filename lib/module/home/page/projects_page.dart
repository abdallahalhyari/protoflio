import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../data/projects_data.dart';
import '../widget/projects/interactive_project_card.dart';
import '../widget/screen_shell.dart';

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
       physics: widget.isContinuousMobile ? const NeverScrollableScrollPhysics() : null,
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
