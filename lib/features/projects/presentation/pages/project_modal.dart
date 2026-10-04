import 'package:flutter/material.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/theme/tokens.dart';
import 'package:profile/service/analytics_service.dart';
import 'package:profile/service/sound_service.dart';
import 'package:profile/features/case_study/case_study_router.dart';
import 'package:profile/features/projects/domain/entities/project.dart';
import 'package:profile/shared/widget/app_toast.dart';
import 'package:profile/shared/widget/conditional_blur.dart';
import 'package:profile/features/projects/presentation/widgets/modal/project_hero_header.dart';
import 'package:profile/features/projects/presentation/widgets/modal/project_dateline_row.dart';
import 'package:profile/features/projects/presentation/widgets/modal/project_title_section.dart';
import 'package:profile/features/projects/presentation/widgets/modal/project_dossier_section.dart';
import 'package:profile/features/projects/presentation/widgets/modal/project_outcomes_section.dart';
import 'package:profile/features/projects/presentation/widgets/modal/project_tech_stack_section.dart';

Future<void> showProjectCaseStudy(
  BuildContext context, {
  required Project project,
  required int index,
}) async {
  SoundService.instance.playClick();
  Analytics.ctaProject(project.company);

  final slug = CaseStudyRouter.slugForCompany(project.company);
  if (slug != null) {
    await CaseStudyRouter.push(context, slug);
    return;
  }

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
      if (AppMedia.reduceMotion(context)) {
        return FadeTransition(opacity: animation, child: child);
      }
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: AppMotion.emphasizedDecel,
        reverseCurve: AppMotion.emphasizedAccel,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final isDesktop = AppBreakpoints.isDesktop(context);
    final isDark = scheme.brightness == Brightness.dark;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.transparent),
          ),
        ),
        Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? AppSpacing.lg : AppSpacing.md,
              vertical: isDesktop ? AppSpacing.xxl : AppSpacing.xl,
            ),
            child: RepaintBoundary(
              child: ConditionalBlur(
                borderRadius: BorderRadius.circular(AppRadius.md),
                sigma: 16,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.03)
                        : Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: isDark
                          ? scheme.primary.withValues(alpha: 0.5)
                          : AppColors.slate300,
                      width: isDark ? 1.5 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.5)
                            : AppColors.slate900
                                .withValues(alpha: AppAlpha.whisper),
                        blurRadius: 22,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: scheme.primary
                            .withValues(alpha: isDark ? 0.15 : 0.08),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ProjectHeroHeader(project: project, isDesktop: isDesktop),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? AppSpacing.lg : AppSpacing.md,
                          vertical: isDesktop ? AppSpacing.md : AppSpacing.smd,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ProjectDatelineRow(
                              project: project,
                              index: index,
                              isDesktop: isDesktop,
                              isDark: isDark,
                              scheme: scheme,
                              onOpenUrl: (url) => openProjectUrl(context, url),
                            ),
                            const SizedBox(height: 6),
                            ProjectTitleSection(
                              project: project,
                              isDesktop: isDesktop,
                              isDark: isDark,
                            ),
                            const SizedBox(height: AppSpacing.smd),
                            if (project.context != null) ...[
                              Text(
                                project.context!,
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.8)
                                      : AppColors.slate700,
                                  fontSize: isDesktop ? 12.0 : 11.0,
                                  height: 1.45,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                            ],
                            ProjectDossierSection(
                              project: project,
                              isDesktop: isDesktop,
                              isDark: isDark,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Container(height: 1, color: context.divider),
                            const SizedBox(height: AppSpacing.md),
                            ProjectOutcomesSection(
                              project: project,
                              isDesktop: isDesktop,
                              isDark: isDark,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            ProjectTechStackSection(
                              stack: project.stack,
                              isDesktop: isDesktop,
                              isDark: isDark,
                              scheme: scheme,
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

  static Future<void> openProjectUrl(BuildContext context, String url) async {
    SoundService.instance.playClick();
    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      final loc = AppLocalizations.of(context)!;
      AppToast.show(
        context,
        message: loc.projectOpenError(url),
        status: ToastStatus.critical,
      );
    }
  }
}
