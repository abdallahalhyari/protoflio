import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/about/presentation/widgets/about_card.dart';
import 'package:profile/features/about/presentation/widgets/journey.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/utils/career_facts.dart';

/// The engineering profile: a fact panel, then the short story.
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key, required this.isDesktop});

  final bool isDesktop;

  static const _stack = [
    'Flutter',
    'Dart',
    'Android',
    'Kotlin',
    'Java',
    'NFC / ISO 7816',
    'RSA · AES · PBKDF2',
    'WorkManager',
    'REST · SOAP',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rule = context.glassBorderStrong;

    Widget row(String label, Widget value, {bool first = false}) {
      return DecoratedBox(
        decoration: BoxDecoration(
          border: first ? null : Border(top: BorderSide(color: rule)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 108,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: AppTypography.body,
                    height: 1.4,
                    color: context.mutedText,
                  ),
                ),
              ),
              Expanded(child: value),
            ],
          ),
        ),
      );
    }

    Widget text(String value) => Text(
          value,
          style: TextStyle(
            fontSize: AppTypography.body,
            height: 1.45,
            fontWeight: FontWeight.w500,
            color: context.onSurface,
          ),
        );

    final panel = AboutCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          row(l10n.aboutEngineerLabel, text(l10n.aboutEngineerValue),
              first: true),
          row(
            l10n.aboutExperienceLabel,
            text(l10n.aboutExperienceValue(CareerFacts.yearsOfExperience())),
          ),
          row(l10n.aboutFocusLabel, text(l10n.aboutFocusValue)),
          row(
            l10n.aboutStackLabel,
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [for (final t in _stack) MonoTag(t)],
            ),
          ),
          row(l10n.heroFactLanguagesLabel, text(l10n.heroFactLanguagesValue)),
          row(l10n.heroFactStudyLabel, text(l10n.heroFactStudyValue)),
        ],
      ),
    );

    final story = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.aboutStoryShort,
            style: TextStyle(
              fontSize: AppTypography.lead,
              height: 1.65,
              color: context.onSurface.withValues(alpha: 0.88),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Journey(),
        ],
      ),
    );

    if (!isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [story, const SizedBox(height: AppSpacing.lg), panel],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: panel),
        const SizedBox(width: AppSpacing.xl),
        Expanded(flex: 6, child: story),
      ],
    );
  }
}
