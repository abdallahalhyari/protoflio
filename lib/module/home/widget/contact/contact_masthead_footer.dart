import 'package:flutter/material.dart';

import '../../../../theme/surface_tone.dart';
import '../../../../theme/tokens.dart';
import 'social_chip.dart';

class ContactMastheadFooter extends StatelessWidget {
  final String linkedInHandle;
  final String githubHandle;
  final VoidCallback onOpenLinkedIn;
  final VoidCallback onOpenGithub;

  const ContactMastheadFooter({
    super.key,
    required this.linkedInHandle,
    required this.githubHandle,
    required this.onOpenLinkedIn,
    required this.onOpenGithub,
  });

  @override
  Widget build(BuildContext context) {
    const availabilityGreen = AppColors.accentGreen;
    final isMobile = MediaQuery.sizeOf(context).width < 640;
    final isDark = context.isDarkMode;

    Widget rule() => Expanded(
          child: Container(
            height: 1,
            color: isDark
                ? Colors.white.withValues(alpha: 0.15)
                : AppColors.slate300,
          ),
        );

    Widget block(String label, String value) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.72)
                    : AppColors.slate500,
                fontSize: 9.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.slate900,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
          ],
        );

    final blocks = [
      block('PRIMARY LOCATION', 'AMMAN · RELOCATING BRNO 2027'),
      block('EU WORK STATUS', 'ELIGIBLE / NO PERMIT REQ.'),
      block('RESPONSE SLA', 'GUARANTEED WITHIN 24 HOURS'),
      block('ENGAGEMENT SCOPE', 'SENIOR ROLES · ADVISORY'),
    ];

    return Column(
      children: [
        // Social quick-pills
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            SocialChip(
              label: 'LINKEDIN · $linkedInHandle',
              icon: Icons.link_rounded,
              onTap: onOpenLinkedIn,
            ),
            SocialChip(
              label: 'GITHUB · $githubHandle',
              icon: Icons.code_rounded,
              onTap: onOpenGithub,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        // Trust and identity badge
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : AppColors.slate100,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : AppColors.slate200,
                width: 1,
              ),
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              spacing: 6,
              runSpacing: 4,
              children: [
                const Icon(Icons.shield_outlined,
                    size: 13, color: availabilityGreen),
                Text(
                  'VERIFIED SENIOR MOBILE ARCHITECT · DIRECT COMMUNICATION',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : AppColors.slate600,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Masthead Colophon Rule
        Row(
          children: [
            rule(),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '// COLOPHON & DISPATCH',
                    style: TextStyle(
                      color: isDark ? Colors.white.withValues(alpha: 0.60) : AppColors.slate400,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
            rule(),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (isMobile)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 8,
            children: [
              for (final b in blocks)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.04)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : AppColors.slate200,
                    ),
                  ),
                  child: b,
                ),
            ],
          )
        else
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.sm,
            children: [
              blocks[0],
              Container(
                width: 1,
                height: 28,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.2)
                    : AppColors.slate300,
              ),
              blocks[1],
              Container(
                width: 1,
                height: 28,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.2)
                    : AppColors.slate300,
              ),
              blocks[2],
              Container(
                width: 1,
                height: 28,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.2)
                    : AppColors.slate300,
              ),
              blocks[3],
            ],
          ),
      ],
    );
  }
}
