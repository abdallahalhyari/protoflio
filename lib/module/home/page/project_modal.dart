import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:profile/l10n/app_localizations.dart';

import '../../../theme/tokens.dart';
import '../../../service/analytics_service.dart';
import '../../../service/sound_service.dart';
import '../model/project.dart';
import '../widget/conditional_blur.dart';
import '../widget/projects/nfc_architecture_diagram.dart';
import '../widget/projects/pipeline_topology_diagram.dart';
import '../widget/projects/project_dossier_card.dart';

Future<void> showProjectCaseStudy(
  BuildContext context, {
  required Project project,
  required int index,
}) async {
  SoundService.instance.playClick();
  Analytics.ctaProject(project.company);

  await showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close Case Study',
    barrierColor: Colors.black.withValues(alpha: 0.65),
    transitionDuration: AppMotion.md,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: _ProjectCaseStudyModal(
            project: project,
            index: index,
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curvedAnimation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.0).animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );
}

class _ProjectCaseStudyModal extends StatelessWidget {
  final Project project;
  final int index;

  const _ProjectCaseStudyModal({
    required this.project,
    required this.index,
  });

  String _ordinal(int index) => (index + 1).toString().padLeft(2, '0');

  Future<void> _openProjectUrl(BuildContext context, String url) async {
    SoundService.instance.playClick();
    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      final loc = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.projectOpenError(url)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= AppBreakpoints.tablet;
    final isDark = scheme.brightness == Brightness.dark;

    return Stack(
      children: [
        // Dismiss Area
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.transparent),
          ),
        ),
        // Modal Content
        Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 24 : 16,
              vertical: isDesktop ? 64 : 48,
            ),
            child: RepaintBoundary(
              child: ConditionalBlur(
                borderRadius: BorderRadius.circular(AppRadius.md),
                sigma: 16,
                child: Container(
                  constraints: BoxConstraints(maxWidth: isDesktop ? 780 : 960),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: isDark ? scheme.primary.withValues(alpha: 0.5) : AppColors.slate300,
                      width: isDark ? 1.5 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black.withValues(alpha: 0.5) : AppColors.slate900.withValues(alpha: 0.06),
                        blurRadius: 22,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: scheme.primary.withValues(alpha: isDark ? 0.15 : 0.08),
                        blurRadius: 20,
                      ),
                    ],
                  ),
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
                      if (project.heroImagePath != null)
                        Container(
                          width: double.infinity,
                          height: isDesktop ? 300 : 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(project.heroImagePath!),
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  isDark ? Colors.black.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.5),
                                ],
                              ),
                            ),
                            alignment: Alignment.topRight,
                            padding: const EdgeInsets.all(12),
                            child: IconButton(
                              icon: const Icon(Icons.close_rounded, color: Colors.white),
                              onPressed: () => Navigator.of(context).pop(),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black45,
                              ),
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
                                          borderRadius: BorderRadius.circular(AppRadius.xs),
                                        ),
                                        child: Text(
                                          project.company.toUpperCase(),
                                          style: TextStyle(
                                            fontFamily: 'Courier',
                                            color: scheme.primary,
                                            fontSize: AppTypography.editorialSm,
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
                                            color: isDark ? Colors.white.withValues(alpha: 0.6) : AppColors.slate500,
                                            fontSize: AppTypography.editorialSm,
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
                                    onTap: () => _openProjectUrl(context, project.url!),
                                    borderRadius: BorderRadius.circular(AppRadius.xs),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: scheme.primary.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(AppRadius.xs),
                                        border: Border.all(color: scheme.primary.withValues(alpha: 0.5)),
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
                                          Icon(Icons.arrow_outward, size: 11, color: scheme.primary),
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
                                  fontFamily: AppTypography.displayFont,
                                  color: isDark ? Colors.white : AppColors.slate900,
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
                                color: isDark ? Colors.white.withValues(alpha: 0.85) : AppColors.slate700,
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
                                  color: isDark ? Colors.white.withValues(alpha: 0.8) : AppColors.slate700,
                                  fontSize: isDesktop ? 12.0 : 11.0,
                                  height: 1.45,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // 2. The Architectural Dossier (Glass Bentos)
                            PipelineTopologyDiagram(
                              project: project,
                              isDesktop: isDesktop,
                              isDark: isDark,
                            ),
                            if (project.problem != null)
                              ProjectDossierCard(
                                label: 'CORE PROBLEM',
                                value: project.problem!,
                                accentColor: const Color(0xFFF87171),
                                isDesktop: isDesktop,
                                isDark: isDark,
                              ),
                            if (project.architecture != null)
                              ProjectDossierCard(
                                label: 'ARCHITECTURE',
                                value: project.architecture!,
                                accentColor: AppColors.accentIndigo,
                                isDesktop: isDesktop,
                                isDark: isDark,
                              ),
                            if (project.hasArchitectureDiagram)
                              NfcArchitectureDiagram(
                                isDesktop: isDesktop,
                                isDark: isDark,
                              ),
                            if (project.solution != null)
                              ProjectDossierCard(
                                label: 'ENGINEERING SOLUTION',
                                value: project.solution!,
                                accentColor: AppColors.accentGreen,
                                isDesktop: isDesktop,
                                isDark: isDark,
                              ),
                            if (project.technicalDecisions != null && project.technicalDecisions!.isNotEmpty)
                              ProjectDossierCard(
                                label: 'DECISION',
                                value: project.technicalDecisions!.first,
                                accentColor: AppColors.accentAmberSoft,
                                isDesktop: isDesktop,
                                isDark: isDark,
                              ),
                            if (project.lessonsLearned != null)
                              ProjectDossierCard(
                                label: 'LESSON LEARNED',
                                value: project.lessonsLearned!,
                                accentColor: AppColors.accentAmber,
                                isDesktop: isDesktop,
                                isDark: isDark,
                              ),

                            const SizedBox(height: 8),
                            Container(height: 1, color: isDark ? Colors.white12 : AppColors.slate200),
                            const SizedBox(height: 16),

                            // 3. Key Highlights & Measurable Results
                            for (int i = 0; i < project.highlights.length; i++)
                              ProjectHighlightRow(
                                highlight: project.highlights[i],
                                isDesktop: isDesktop,
                                isDark: isDark,
                              ),

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
                                              color: isDark ? Colors.white.withValues(alpha: 0.9) : AppColors.slate800,
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
                                      color: isDark ? Colors.white.withValues(alpha: 0.06) : AppColors.slate100,
                                      borderRadius: BorderRadius.circular(AppRadius.xs),
                                      border: Border.all(color: isDark ? Colors.white12 : AppColors.slate200),
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
              ),
            ),
          ),
        ),
      ],
    );
  }
}
