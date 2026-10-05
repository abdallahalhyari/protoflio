import 'package:flutter/material.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

/// Section header shared by the paged sections: the title, one line of
/// plain-language subtitle, and a hairline rule underneath.
///
/// Deliberately still. The cover's credential card is the site's one
/// orchestrated motion; section headers just sit where they are.
class SectionMasthead extends StatelessWidget {
  const SectionMasthead({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isDesktop,
  });

  final String title;
  final String subtitle;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final titleSize = isDesktop ? AppTypography.display : AppTypography.heading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            style: TextStyle(
              color: scheme.onSurface,
              fontSize: titleSize,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.02 * titleSize,
              height: 1.1,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ConstrainedBox(
          // ~65 characters at lead size.
          constraints: const BoxConstraints(maxWidth: 560),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              subtitle,
              style: TextStyle(
                color: context.mutedText,
                fontSize: isDesktop ? AppTypography.lead : AppTypography.body,
                height: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(height: 1, color: context.divider),
      ],
    );
  }
}
