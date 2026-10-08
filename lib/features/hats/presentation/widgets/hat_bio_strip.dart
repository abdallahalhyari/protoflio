import 'package:flutter/material.dart';

import 'package:profile/shared/utils/career_facts.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/utils/bidi.dart';

class HatBioStrip extends StatelessWidget {
  final bool isMobile;

  const HatBioStrip({
    super.key,
    required this.isMobile,
  });

  static String get bio =>
      'Senior mobile engineer with ${CareerFacts.yearsOfExperience()}+ years shipping enterprise Flutter & '
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
            color: context.divider,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Text(
          ltrContent(context, bio),
          // Phones show the whole bio (it was cut at "WorkMa…"); the
          // desktop header keeps its height bounded for the card felt.
          maxLines: isMobile ? null : 3,
          overflow: isMobile ? null : TextOverflow.ellipsis,
          style: TextStyle(
            color: context.onSurface,
            fontSize: AppTypography.label,
            height: 1.45,
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
              ltrContent(context, bio),
              style: TextStyle(
                color: context.onSurface,
                fontSize: AppTypography.body,
                height: 1.6,
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
              _bioMetaBlock(context, 'BASED', 'Amman, Jordan', isDark),
              const SizedBox(height: AppSpacing.lg),
              _bioMetaBlock(
                  context, 'NEXT', 'Brno, Czech Republic, 2027', isDark),
              const SizedBox(height: AppSpacing.lg),
              _bioMetaBlock(
                  context, 'Open for', 'Senior roles, consulting', isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bioMetaBlock(
      BuildContext context, String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: context.mutedText,
            fontSize: AppTypography.label,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: context.onSurface,
            fontSize: AppTypography.label,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
