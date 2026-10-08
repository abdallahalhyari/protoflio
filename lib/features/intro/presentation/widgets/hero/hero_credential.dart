import 'package:flutter/material.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/intro/presentation/widgets/hero_motion.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/widgets/retrying_asset_image.dart';

/// Right column of the cover: the portrait over the facts a recruiter
/// screens for, laid out like the header of a CV. Availability is the
/// first row and links to Contact.
class HeroCredential extends StatelessWidget {
  final bool isDark;
  final bool isWide;
  final Animation<double> reveal;
  final VoidCallback? onContactMe;

  const HeroCredential({
    super.key,
    required this.isDark,
    required this.isWide,
    required this.reveal,
    this.onContactMe,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rule = context.glassBorderStrong;
    final teal = isDark ? AppColors.tealLight : AppColors.tealDeep;

    final facts = [
      (l10n.heroFactAvailableLabel, l10n.heroFactAvailableValue, true),
      (l10n.heroFactPermitLabel, l10n.heroFactPermitValue, false),
      (l10n.heroFactBasedLabel, l10n.heroFactBasedValue, false),
      (l10n.heroFactFocusLabel, l10n.heroFactFocusValue, false),
      (l10n.heroFactLanguagesLabel, l10n.heroFactLanguagesValue, false),
      (l10n.heroFactStudyLabel, l10n.heroFactStudyValue, false),
    ];

    Widget row(String label, String value, bool live) {
      final content = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 104,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: AppTypography.body,
                  height: 1.4,
                  color: context.onSurface.withValues(alpha: 0.62),
                ),
              ),
            ),
            if (live) ...[
              Padding(
                padding: const EdgeInsets.only(top: 6, right: 8),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration:
                      BoxDecoration(color: teal, shape: BoxShape.circle),
                ),
              ),
            ],
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: AppTypography.body,
                  height: 1.4,
                  fontWeight: live ? FontWeight.w700 : FontWeight.w500,
                  color: live ? teal : context.onSurface,
                ),
              ),
            ),
          ],
        ),
      );
      final decorated = DecoratedBox(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: rule))),
        child: content,
      );
      if (!live || onContactMe == null) return decorated;
      return Semantics(
        button: true,
        child: InkWell(
          onTap: () {
            SoundService.instance.playClick();
            onContactMe!();
          },
          child: decorated,
        ),
      );
    }

    return HeroStep(
      animation: reveal,
      begin: 0.3,
      end: 1.0,
      rise: 0.08,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.cardStock,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: rule),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // The portrait is a cut-out, so it sits on a tinted studio
              // backdrop, head and shoulders whole, flush with the bottom.
              AspectRatio(
                aspectRatio: isWide ? 1.45 : 1.35,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              AppColors.teal.withValues(alpha: 0.45),
                              AppColors.gold.withValues(alpha: 0.30),
                            ]
                          : [
                              AppColors.tealLight.withValues(alpha: 0.45),
                              AppColors.goldSoft.withValues(alpha: 0.55),
                            ],
                    ),
                  ),
                  child: Semantics(
                    image: true,
                    label: l10n.semanticPortrait,
                    excludeSemantics: true,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Hero(
                        tag: 'abdallah_avatar_headshot',
                        child: RetryingAssetImage(
                          'assets/my_image.webp',
                          fit: BoxFit.contain,
                          alignment: Alignment.bottomCenter,
                          cacheWidth: 544,
                          filterQuality: FilterQuality.high,
                          semanticLabel: l10n.semanticPortrait,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(height: 3, color: AppColors.gold),
              for (final f in facts) row(f.$1, f.$2, f.$3),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}
