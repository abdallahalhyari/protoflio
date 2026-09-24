import 'package:flutter/material.dart';

import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/features/engineering/model/architecture_topic.dart';

/// Card container displaying architecture rationale, summary, and technical safeguards.
class ArchitectureDetailsCard extends StatelessWidget {
  final ArchitectureTopic topic;
  final bool isDesktop;

  const ArchitectureDetailsCard({
    super.key,
    required this.topic,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;
    final accentText = context.adaptiveAccentText(scheme.primary);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.cardGlass,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.glassBorder),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: AppColors.slate900.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ListView(
        primary: false,
        padding: EdgeInsets.zero,
        shrinkWrap: !isDesktop,
        physics: isDesktop
            ? const ClampingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        children: [
          // Section Title
          Text(
            topic.title,
            style: TextStyle(
              fontSize: AppTypography.titleSm,
              fontWeight: FontWeight.w800,
              color: context.onSurface,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            topic.summary,
            style: TextStyle(
              fontSize: AppTypography.small,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.85)
                  : AppColors.slate700,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),

          // Architectural Rationale Container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: isDark ? 0.12 : 0.08),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: scheme.primary.withValues(alpha: isDark ? 0.35 : 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.psychology_outlined,
                        color: accentText, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'ARCHITECTURAL RATIONALE (WHY THIS CHOICE)',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: accentText,
                          fontSize: AppTypography.micro,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  topic.whyChosen,
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.slate800,
                    fontSize: AppTypography.overline,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Technical Highlights
          Text(
            'KEY IMPLEMENTATION SAFEGUARDS',
            style: TextStyle(
              fontFamily: AppTypography.monoFont,
              color: accentText,
              fontSize: AppTypography.editorial,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          for (final item in topic.technicalHighlights) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3, right: 4),
                    child: Icon(Icons.diamond,
                        size: AppTypography.caption, color: accentText),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.8)
                            : AppColors.slate700,
                        fontSize: AppTypography.captionSm,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
