import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/shared/utils/grid_math.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/contact/presentation/widgets/consulting_track.dart';

/// Executive engagement scopes (Architecture Audit, Full-Lifecycle App Engineering, Tech Leadership).
class EngagementMatrixSection extends StatelessWidget {
  final bool isDesktop;
  final void Function(String subject, String body) onInquire;

  const EngagementMatrixSection({
    super.key,
    required this.isDesktop,
    required this.onInquire,
  });

  static const _sky = AppColors.teal;
  static const _accent = AppColors.teal;
  static const _availabilityGreen = AppColors.tealLight;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = context.isDarkMode;

    final tracks = [
      ConsultingTrack(
        tag: 'System audit',
        title: 'Architecture & Resilience Audit',
        description:
            'Clean Architecture restructuring, state-machine resilience, concurrency bottleneck triage, and multi-package decoupling.',
        icon: Icons.account_tree_rounded,
        accent: _sky,
        inquirySubject:
            '[Architecture Audit Inquiry] Mobile System Audit - Abdallah Alhyari',
        onInquire: (subject) => onInquire(
          subject,
          'Hi Abdallah,\n\nI would like to discuss an architectural audit for our mobile codebase...',
        ),
      ),
      ConsultingTrack(
        tag: 'Production apps',
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
        tag: 'Tech leadership',
        title: 'Fractional Lead & Mentorship',
        description:
            'Code review governance, automated UI & integration test harnesses, mobile CI/CD pipelines, and upskilling engineering squads.',
        icon: Icons.military_tech_rounded,
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
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    l10n.contactEngagementScopes,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : AppColors.ink500,
                      fontSize: AppTypography.label,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = columnWidth(
                  constraints.maxWidth, isDesktop ? 3 : 1, AppSpacing.md);
              if (cardWidth <= 0) return const SizedBox.shrink();

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
