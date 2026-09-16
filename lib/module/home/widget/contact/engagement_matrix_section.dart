import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import '../../../../theme/surface_tone.dart';
import '../../../../theme/tokens.dart';
import 'consulting_track.dart';

/// Executive engagement scopes (Architecture Audit, Full-Lifecycle App Engineering, Tech Leadership).
class EngagementMatrixSection extends StatelessWidget {
  final bool isDesktop;
  final void Function(String subject, String body) onInquire;

  const EngagementMatrixSection({
    super.key,
    required this.isDesktop,
    required this.onInquire,
  });

  static const _sky = AppColors.accentSky;
  static const _accent = AppColors.accentViolet;
  static const _availabilityGreen = AppColors.accentGreenLight;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = context.isDarkMode;

    final tracks = [
      ConsultingTrack(
        tag: 'SYSTEM AUDIT',
        title: 'Architecture & Resilience Audit',
        description:
            'Clean Architecture restructuring, state-machine resilience, concurrency bottleneck triage, and multi-package decoupling.',
        icon: Icons.account_tree_outlined,
        accent: _sky,
        inquirySubject:
            '[Architecture Audit Inquiry] Mobile System Audit - Abdallah Alhyari',
        onInquire: (subject) => onInquire(
          subject,
          'Hi Abdallah,\n\nI would like to discuss an architectural audit for our mobile codebase...',
        ),
      ),
      ConsultingTrack(
        tag: 'PRODUCTION APPS',
        title: 'Full-Lifecycle App Engineering',
        description:
            'Zero-to-one cross-platform app delivery, native iOS Swift & Android Kotlin platform channels, 120 FPS buttery rendering.',
        icon: Icons.devices_rounded,
        accent: _accent,
        inquirySubject:
            '[Engineering Inquiry] Production Mobile App - Abdallah Alhyari',
        onInquire: (subject) => onInquire(
          subject,
          'Hi Abdallah,\n\nWe have an upcoming mobile application project and would love to collaborate...',
        ),
      ),
      ConsultingTrack(
        tag: 'TECH LEADERSHIP',
        title: 'Fractional Lead & Mentorship',
        description:
            'Code review governance, automated UI & integration test harnesses, mobile CI/CD pipelines, and upskilling engineering squads.',
        icon: Icons.military_tech_outlined,
        accent: _availabilityGreen,
        inquirySubject:
            '[Advisory Inquiry] Mobile Leadership & Mentorship - Abdallah Alhyari',
        onInquire: (subject) => onInquire(
          subject,
          'Hi Abdallah,\n\nWe are looking for senior mobile leadership / fractional guidance for our engineering team...',
        ),
      ),
    ];

    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: _accent,
                  borderRadius: BorderRadius.circular(AppRadius.xxs),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.contactEngagementScopes,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : AppColors.slate500,
                      fontSize: AppTypography.caption,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = isDesktop
                  ? (constraints.maxWidth - 2 * AppSpacing.md) / 3
                  : constraints.maxWidth;

              return Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  for (final track in tracks)
                    SizedBox(
                      width: cardWidth,
                      child: BentoTrackCard(track: track),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
