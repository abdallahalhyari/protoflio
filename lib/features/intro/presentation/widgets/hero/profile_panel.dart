import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/intro/presentation/widgets/hero_motion.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/utils/career_facts.dart';
import 'package:profile/shared/widgets/retrying_asset_image.dart';

/// Beside the cover's statement: who you'd be hiring. A portrait, then the
/// four facts a recruiter screens for first: role, experience, where I'm
/// based, and where I've worked. Plain facts, no demo.
class ProfilePanel extends StatelessWidget {
  final bool isWide;
  final Animation<double> reveal;

  const ProfilePanel({
    super.key,
    required this.isWide,
    required this.reveal,
  });

  /// The photo's own proportions (544 × 650), so nothing is cropped.
  static const double _photoAspect = 544 / 650;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final view = MediaQuery.sizeOf(context);
    // Short laptops get a smaller photo so the cover fits without scrolling.
    final photoWidth = isWide ? (view.height < 860 ? 196.0 : 236.0) : 148.0;

    final facts = [
      (l10n.cardFieldRole, l10n.cardRole),
      (
        l10n.aboutExperienceLabel,
        l10n.aboutExperienceValue(CareerFacts.yearsOfExperience()),
      ),
      (l10n.heroFactBasedLabel, l10n.cardBase),
      (l10n.coverWorkedAtLabel, l10n.coverWorkedAtValue),
    ];

    final photo = Container(
      width: photoWidth,
      height: photoWidth / _photoAspect,
      decoration: BoxDecoration(
        // The studio backdrop is white; on ink it reads as a print.
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: context.glassBorderStrong),
      ),
      clipBehavior: Clip.antiAlias,
      child: RetryingAssetImage(
        'assets/my_image.webp',
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        filterQuality: FilterQuality.high,
        cacheWidth: (photoWidth * 2).round(),
        semanticLabel: l10n.semanticPortrait,
      ),
    );

    return HeroStep(
      animation: reveal,
      begin: 0.3,
      end: 1.0,
      rise: 0.06,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            photo,
            const SizedBox(height: AppSpacing.lg),
            for (var i = 0; i < facts.length; i++)
              _FactRow(
                label: facts[i].$1,
                value: facts[i].$2,
                isFirst: i == 0,
              ),
          ],
        ),
      ),
    );
  }
}

/// One fact: a muted label in its own column, the value beside it, a rule
/// between rows. Stacks on narrow screens or large text.
class _FactRow extends StatelessWidget {
  const _FactRow({
    required this.label,
    required this.value,
    required this.isFirst,
  });

  final String label;
  final String value;
  final bool isFirst;

  static const double _labelColumn = 104;

  @override
  Widget build(BuildContext context) {
    final labelText = Text(
      label,
      style: TextStyle(
        fontSize: AppTypography.body,
        height: 1.45,
        color: context.mutedText,
      ),
    );
    final valueText = Text(
      value,
      style: TextStyle(
        fontSize: AppTypography.body,
        fontWeight: FontWeight.w600,
        height: 1.45,
        color: context.onSurface,
      ),
    );

    return MergeSemantics(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
        decoration: BoxDecoration(
          border:
              isFirst ? null : Border(top: BorderSide(color: context.divider)),
        ),
        child: LayoutBuilder(
          builder: (context, c) => c.maxWidth >= 300
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: _labelColumn, child: labelText),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: valueText),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [labelText, valueText],
                ),
        ),
      ),
    );
  }
}
