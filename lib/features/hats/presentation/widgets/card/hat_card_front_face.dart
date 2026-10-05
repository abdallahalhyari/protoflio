import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/hats/domain/entities/hat_info.dart';
import 'package:profile/features/hats/presentation/utils/hat_labels.dart';
import 'package:profile/features/hats/presentation/widgets/network_hat_image.dart';
import 'package:profile/features/hats/presentation/widgets/card/hat_card_shared.dart';
import 'package:profile/shared/utils/bidi.dart';

const double kFanVisibleWidth = 140;

class CardTitle extends StatelessWidget {
  const CardTitle({
    super.key,
    required this.hat,
    required this.isStandalone,
  });

  final HatInfo hat;
  final bool isStandalone;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      hatTitleLabel(AppLocalizations.of(context)!, hat.title).toUpperCase(),
      textAlign: TextAlign.center,
      maxLines: 1,
      style: TextStyle(
        fontFamily: AppTypography.displayFont,
        color: Colors.white,
        fontSize: AppTypography.title + 1,
        fontWeight: FontWeight.w900,
        letterSpacing: latinTracking(context, 2.2),
      ),
    );
    if (isStandalone) return text;
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: kFanVisibleWidth),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: text,
        ),
      ),
    );
  }
}

class CardFrontFace extends StatelessWidget {
  const CardFrontFace({
    super.key,
    required this.hat,
    required this.index,
    required this.isHovered,
    required this.isStandalone,
    required this.tiltOffset,
    required this.onTap,
  });

  final HatInfo hat;
  final int index;
  final bool isHovered;
  final bool isStandalone;
  final ValueNotifier<Offset> tiltOffset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = hat.color;
    final ordinal = (index + 1).toString().padLeft(2, '0');
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 255,
            height: 370,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.playingCard),
              border: Border.all(
                color: isHovered
                    ? accent.withValues(alpha: 1)
                    : accent.withValues(alpha: 0.55),
                width: isHovered ? 2.2 : 1.4,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.darkCanvasElevated,
                  AppColors.darkCanvas,
                  accent.withValues(alpha: 0.22),
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black.withValues(alpha: isHovered ? 0.72 : 0.55),
                  blurRadius: isHovered ? 32 : 18,
                  offset: Offset(0, isHovered ? 14 : 8),
                ),
                BoxShadow(
                  color: accent.withValues(alpha: isHovered ? 0.55 : 0.32),
                  blurRadius: isHovered ? 28 : 16,
                  spreadRadius: isHovered ? 2 : 1,
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CardOrdinalHeader(ordinal: ordinal, accent: accent),
                const SizedBox(height: 8),
                Expanded(
                  child: Center(
                    child: Hero(
                      tag: 'hat_card_${hat.heroTag}',
                      child: HatImage(
                        path: hat.image,
                        height: 148,
                        semanticLabel: hatTitleLabel(
                            AppLocalizations.of(context)!, hat.title),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                CardTitle(hat: hat, isStandalone: isStandalone),
                const SizedBox(height: 6),
                AccentUnderRule(
                  accent: accent,
                  alignment:
                      isStandalone ? null : AlignmentDirectional.centerStart,
                ),
                const SizedBox(height: 10),
                FlipHintRow(
                  text: isStandalone
                      ? (AppLocalizations.of(context)?.flipHintTap ??
                          'TAP TO FLIP')
                      : (AppLocalizations.of(context)?.flipHintClick ??
                          'CLICK TO FLIP'),
                  isStandalone: isStandalone,
                  showTrailingIcon: isStandalone,
                ),
              ],
            ),
          ),
          SpecularGleam(isHovered: isHovered, tiltOffset: tiltOffset),
        ],
      ),
    );
  }
}
