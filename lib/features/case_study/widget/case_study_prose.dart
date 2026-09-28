import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show Bidi;

import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';

/// Section kicker: numeric label + uppercase title + rule.
class SectionKicker extends StatelessWidget {
  const SectionKicker({super.key, required this.number, required this.label});

  final String number;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(children: [
      Text(
        number,
        style: TextStyle(
          fontFamily: AppTypography.displayFont,
          fontSize: AppTypography.heading,
          fontWeight: FontWeight.w900,
          color: context.adaptiveAccentText(scheme.primary),
        ),
      ),
      const SizedBox(width: AppSpacing.md),
      Expanded(
        child: Text(
          label,
          style: TextStyle(
            fontSize: AppTypography.overline,
            letterSpacing: 3,
            fontWeight: FontWeight.w800,
            color: scheme.onSurface.withValues(alpha: 0.9),
          ),
        ),
      ),
      Container(
        height: 1,
        width: 80,
        color: scheme.onSurface.withValues(alpha: 0.15),
      ),
    ]);
  }
}

/// Body prose, wider line-height for long reads.
class Prose extends StatelessWidget {
  const Prose(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Text(
      text,
      style: TextStyle(
        fontSize: AppTypography.body + 1,
        height: 1.65,
        color: scheme.onSurface.withValues(alpha: 0.85),
      ),
    );
  }
}

/// Vertical bullet list with primary-tinted markers.
class BulletList extends StatelessWidget {
  const BulletList({super.key, required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((t) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.smd),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: context.adaptiveAccentText(scheme.primary),
                          borderRadius: BorderRadius.circular(AppRadius.xxs),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.smd),
                    Expanded(
                      child: Text(
                        t,
                        style: TextStyle(
                          fontSize: AppTypography.body,
                          height: 1.55,
                          color: scheme.onSurface.withValues(alpha: 0.82),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

/// One quiet line telling Czech and Arabic readers that the technical
/// chapters that follow are in English (only the reading frame and the
/// summaries are translated). Renders nothing when [text] is empty, which
/// is the English locale's value.
class CaseStudyLanguageNote extends StatelessWidget {
  const CaseStudyLanguageNote(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    return LocaleDirection(
      child: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.md),
        child: Row(
          children: [
            Icon(Icons.translate_rounded, size: 16, color: context.mutedText),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: AppTypography.small,
                  fontStyle: FontStyle.italic,
                  color: context.mutedText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Case studies lay out left-to-right, because their technical chapters are
/// English (see CaseStudyRouter). Translated parts (summaries, notes,
/// captions) take the reader's own direction, so an Arabic sentence keeps
/// its alignment and its punctuation on the right side.
class LocaleDirection extends StatelessWidget {
  const LocaleDirection({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode;
    return Directionality(
      textDirection:
          Bidi.isRtlLanguage(code) ? TextDirection.rtl : TextDirection.ltr,
      child: child,
    );
  }
}
