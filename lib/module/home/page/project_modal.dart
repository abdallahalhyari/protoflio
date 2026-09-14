import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:profile/l10n/app_localizations.dart';

import '../../../theme/tokens.dart';
import '../../../service/analytics_service.dart';
import '../../../service/sound_service.dart';
import '../model/project.dart';
import '../widget/conditional_blur.dart';

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
                                            color: isDark ? Colors.white.withValues(alpha: 0.6) : AppColors.slate500,
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
                            _buildPipelineTopology(project, scheme, isDesktop, isDark),
                            if (project.problem != null)
                              _buildDossierRow('CORE PROBLEM', project.problem!, const Color(0xFFF87171), isDesktop, isDark),
                            if (project.architecture != null)
                              _buildDossierRow('ARCHITECTURE', project.architecture!, AppColors.accentIndigo, isDesktop, isDark),
                            if (project.hasArchitectureDiagram)
                              _buildNatHealthArchitectureDiagram(scheme, isDesktop, isDark),
                            if (project.solution != null)
                              _buildDossierRow('ENGINEERING SOLUTION', project.solution!, AppColors.accentGreen, isDesktop, isDark),
                            if (project.technicalDecisions != null && project.technicalDecisions!.isNotEmpty)
                              _buildDossierRow('DECISION', project.technicalDecisions!.first, const Color(0xFFFDE68A), isDesktop, isDark),
                            if (project.lessonsLearned != null)
                              _buildDossierRow('LESSON LEARNED', project.lessonsLearned!, const Color(0xFFFBBF24), isDesktop, isDark),

                            const SizedBox(height: 8),
                            Container(height: 1, color: isDark ? Colors.white12 : AppColors.slate200),
                            const SizedBox(height: 16),

                            // 3. Key Highlights & Measurable Results
                            for (int i = 0; i < project.highlights.length; i++)
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

  Widget _buildPipelineTopology(Project project, ColorScheme scheme, bool isDesktop, bool isDark) {
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
        color: isDark ? Colors.black.withValues(alpha: 0.35) : AppColors.slate50,
        borderRadius: BorderRadius.circular(AppRadius.chip),
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
                        color: isDark ? Colors.white.withValues(alpha: 0.95) : AppColors.slate900,
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
          borderRadius: BorderRadius.circular(AppRadius.smd),
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
                color: isDark ? Colors.white.withValues(alpha: 0.95) : AppColors.slate800,
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
                      color: isDark ? Colors.white.withValues(alpha: 0.9) : AppColors.slate700,
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

  Widget _buildNatHealthArchitectureDiagram(ColorScheme scheme, bool isDesktop, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(isDesktop ? 16 : 12),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: isDark ? 0.05 : 0.02),
        borderRadius: BorderRadius.circular(AppRadius.smd),
        border: Border.all(color: scheme.primary.withValues(alpha: isDark ? 0.15 : 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.account_tree_rounded, size: 12, color: scheme.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'SYSTEM ARCHITECTURE TOPOLOGY',
                  style: TextStyle(
                    fontFamily: 'Courier',
                    color: scheme.primary,
                    fontSize: isDesktop ? 10.0 : 9.0,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildArchNode('NFC Hardware\n(ISO-7816)', Icons.nfc_rounded, scheme, isDark),
                _buildArchArrow(scheme, isDark),
                _buildArchNode('Native Kotlin\nAPDU Channel', Icons.android_rounded, scheme, isDark),
                _buildArchArrow(scheme, isDark),
                _buildArchNode('Flutter UI\n(Clean Arch)', Icons.layers_rounded, scheme, isDark),
                _buildArchArrow(scheme, isDark),
                Column(
                  children: [
                    _buildArchNode('WorkManager\n(Offline Queue)', Icons.sync_rounded, scheme, isDark),
                    const SizedBox(height: 6),
                    _buildArchNode('SQLite DB\n(Encrypted Cache)', Icons.storage_rounded, scheme, isDark),
                  ],
                ),
                _buildArchArrow(scheme, isDark),
                _buildArchNode('TPA Backend\n(REST API)', Icons.cloud_done_rounded, scheme, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArchNode(String label, IconData icon, ColorScheme scheme, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.black45 : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: scheme.primary),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white70 : AppColors.slate700,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArchArrow(ColorScheme scheme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Icon(
        Icons.arrow_right_alt_rounded,
        size: 16,
        color: scheme.primary.withValues(alpha: 0.5),
      ),
    );
  }
}
