import 'package:flutter/material.dart';

import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';

/// Editorial section header shared by the paged sections: a heavy accent
/// rule, a letter-spaced "FEATURE 0X · …" kicker, the display-font title,
/// an italic subtitle, an optional count badge on the right (desktop),
/// and a hairline rule underneath.
class SectionMasthead extends StatelessWidget {
  const SectionMasthead({
    super.key,
    required this.kicker,
    required this.title,
    required this.subtitle,
    required this.isDesktop,
    this.badgeIcon,
    this.badgeLabel,
  });

  final String kicker;
  final String title;
  final String subtitle;
  final bool isDesktop;
  final IconData? badgeIcon;
  final String? badgeLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final accentText = context.adaptiveAccentText(scheme.primary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(height: 2, color: scheme.primary.withValues(alpha: 0.9)),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    kicker,
                    style: TextStyle(
                      color: accentText,
                      fontSize: isDesktop ? 11 : 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Semantics(
                    header: true,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        title,
                        style: TextStyle(
                          fontFamily: AppTypography.displayFont,
                          color: scheme.onSurface,
                          fontSize: (width * 0.05).clamp(24.0, 48.0),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: scheme.onSurface.withValues(alpha: 0.75),
                      fontSize: isDesktop ? 12.5 : 11.5,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            if (isDesktop && badgeLabel != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border:
                      Border.all(color: scheme.primary.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (badgeIcon != null) ...[
                      Icon(badgeIcon,
                          size: AppTypography.caption + 1, color: accentText),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      badgeLabel!,
                      style: TextStyle(
                        color: accentText,
                        fontSize: AppTypography.editorial,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Container(height: 0.75, color: scheme.primary.withValues(alpha: 0.5)),
      ],
    );
  }
}
