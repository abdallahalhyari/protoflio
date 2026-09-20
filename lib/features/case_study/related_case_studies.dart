import 'package:flutter/material.dart';

import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
import 'case_study_router.dart';
import 'case_study_widgets.dart';

/// Bottom-of-page navigation: shows the three sibling case studies with
/// tap-to-navigate cards. Encourages recruiters to keep reading after
/// finishing one case study instead of bouncing back to the section grid.
class RelatedCaseStudies extends StatelessWidget {
  const RelatedCaseStudies({
    super.key,
    required this.currentSlug,
    required this.isDesktop,
  });

  final String currentSlug;
  final bool isDesktop;

  static const Map<String, ({String title, String subtitle})> _summary = {
    'nathealth': (
      title: 'NatHealth NFC Platform',
      subtitle: 'ISO-7816 APDU · WorkManager · JWT Keystore',
    ),
    'eskadenia': (
      title: 'ESKADENIA Enterprise Suite',
      subtitle: 'MVVM refactor · 60fps · −35% crashes',
    ),
    'solutions': (
      title: 'Loyalty + Ephemeral Social',
      subtitle: 'Design system · Camera pipeline · AWS S3',
    ),
    'fais': (
      title: 'M-Commerce & Streaming',
      subtitle: 'Checkout funnel · Idempotent APIs · Media',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final siblings = _summary.keys.where((s) => s != currentSlug).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionKicker(number: '99', label: 'MORE CASE STUDIES'),
        const SizedBox(height: AppSpacing.md),
        if (isDesktop)
          Row(
            children: [
              for (int i = 0; i < siblings.length; i++) ...[
                Expanded(
                    child: _RelatedCard(
                        slug: siblings[i], data: _summary[siblings[i]]!)),
                if (i < siblings.length - 1)
                  const SizedBox(width: AppSpacing.md),
              ],
            ],
          )
        else
          Column(
            children: [
              for (final s in siblings) ...[
                _RelatedCard(slug: s, data: _summary[s]!),
                if (s != siblings.last) const SizedBox(height: AppSpacing.md),
              ],
            ],
          ),
      ],
    );
  }
}

class _RelatedCard extends StatefulWidget {
  const _RelatedCard({required this.slug, required this.data});

  final String slug;
  final ({String title, String subtitle}) data;

  @override
  State<_RelatedCard> createState() => _RelatedCardState();
}

class _RelatedCardState extends State<_RelatedCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () async {
          final nav = Navigator.of(context, rootNavigator: true);
          await nav.maybePop();
          if (!mounted || !context.mounted) return;
          await CaseStudyRouter.push(context, widget.slug);
        },
        child: AnimatedContainer(
          duration: AppMotion.cardHover,
          curve: AppMotion.emphasizedDecel,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: _hovered
                ? scheme.primary.withValues(alpha: isDark ? 0.10 : 0.08)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : Colors.white.withValues(alpha: 0.7)),
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: scheme.primary
                  .withValues(alpha: _hovered ? 0.55 : (isDark ? 0.15 : 0.2)),
              width: _hovered ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.title,
                      style: TextStyle(
                        fontFamily: AppTypography.displayFont,
                        fontSize: AppTypography.subtitle + 2,
                        fontWeight: FontWeight.w900,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.data.subtitle,
                      style: TextStyle(
                        fontSize: AppTypography.small,
                        color: scheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedRotation(
                turns: _hovered ? 0 : -0.02,
                duration: AppMotion.cardHover,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: scheme.primary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
