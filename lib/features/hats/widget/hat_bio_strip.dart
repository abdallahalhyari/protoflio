import 'package:flutter/material.dart';

import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';

class HatBioStrip extends StatelessWidget {
  final bool isMobile;

  const HatBioStrip({
    super.key,
    required this.isMobile,
  });

  static const String bio =
      'Senior mobile engineer with 4+ years shipping enterprise Flutter & '
      'Android systems at scale — offline-first pipelines, NFC + hardware-bound '
      'auth, RabbitMQ event flows, WorkManager sync. Based in Amman, relocating '
      'to Brno for 2027.';

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    if (isMobile) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.black.withValues(alpha: 0.45)
              : Colors.white.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(AppRadius.smd),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.12)
                : AppColors.slate200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Text(
          bio,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isDark ? Colors.white.withValues(alpha: 0.9) : AppColors.slate700,
            fontSize: AppTypography.captionSm,
            height: 1.45,
            letterSpacing: 0.2,
          ),
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.smd),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                    color: Theme.of(context).colorScheme.primary, width: 3),
              ),
              color: isDark
                  ? Colors.white.withValues(alpha: 0.03)
                  : Colors.white.withValues(alpha: 0.85),
              borderRadius:
                  const BorderRadius.horizontal(right: Radius.circular(8)),
            ),
            child: Text(
              bio,
              style: TextStyle(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.92)
                    : AppColors.slate800,
                fontSize: AppTypography.smallLoose,
                height: 1.6,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _bioMetaBlock('BASED', 'AMMAN · JORDAN', isDark),
              const SizedBox(height: 8),
              _bioMetaBlock('NEXT', 'BRNO · CZECH REPUBLIC · 2027', isDark),
              const SizedBox(height: 8),
              _bioMetaBlock('OPEN FOR', 'SENIOR ROLES · CONSULTING', isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bioMetaBlock(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark
                ? Colors.white.withValues(alpha: 0.7)
                : AppColors.slate500,
            fontSize: AppTypography.editorialSm,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.4,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.slate900,
            fontSize: AppTypography.captionSm,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
