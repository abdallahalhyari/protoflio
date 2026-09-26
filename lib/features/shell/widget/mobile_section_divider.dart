import 'package:flutter/material.dart';

import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';

/// Between-section separator on mobile continuous scroll: a short
/// centred rule that fades out at both ends.
///
/// It used to carry a "02 · EXPERIENCE" label, but every section now opens
/// with a masthead kicker ("FEATURE 02 · …") straight after it, so the
/// label repeated itself. [number] and [title] remain for callers and are
/// exposed to screen readers only through the section's own header.
class MobileSectionDivider extends StatelessWidget {
  const MobileSectionDivider({
    super.key,
    required this.number,
    required this.title,
  });

  final String number;
  final String title;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final accent = Theme.of(context).colorScheme.primary;
    return ExcludeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Center(
          child: Container(
            width: 72,
            height: 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              gradient: LinearGradient(
                colors: [
                  accent.withValues(alpha: 0),
                  accent.withValues(alpha: isDark ? 0.7 : 0.5),
                  accent.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
