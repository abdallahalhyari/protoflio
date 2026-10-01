import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/features/hats/model/hat_info.dart';
import 'package:profile/features/hats/data/hat_labels.dart';
import 'package:profile/features/hats/widget/card/hat_card_shared.dart';

class CardBackFace extends StatelessWidget {
  const CardBackFace({
    super.key,
    required this.hat,
    required this.isHovered,
    required this.tiltOffset,
    required this.onTap,
  });

  final HatInfo hat;
  final bool isHovered;
  final ValueNotifier<Offset> tiltOffset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = hat.color;
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
              border:
                  Border.all(color: accent.withValues(alpha: 0.65), width: 1.4),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.darkCanvas,
                  accent.withValues(alpha: 0.14),
                  AppColors.darkCanvasElevated,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.65),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: accent.withValues(alpha: 0.28),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: 'REVERSE · ',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: AppTypography.caption,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                          TextSpan(
                            text: hatTitleLabel(
                                    AppLocalizations.of(context)!, hat.title)
                                .toUpperCase(),
                            style: TextStyle(
                              color: accent,
                              fontSize: AppTypography.overline,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.8,
                            ),
                          ),
                        ]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.autorenew_rounded,
                        size: 14, color: Colors.white.withValues(alpha: 0.6)),
                  ],
                ),
                const SizedBox(height: 10),
                AccentUnderRule(
                  accent: accent,
                  height: 1,
                  width: double.infinity,
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                    border: Border(
                      left: BorderSide(color: accent, width: 2.5),
                    ),
                  ),
                  child: Text(
                    hat.titleDesc,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: AppTypography.overline,
                      fontWeight: FontWeight.w800,
                      height: 1.4,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Text(
                    hat.desc,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontSize: AppTypography.overlineTight,
                      height: 1.55,
                      letterSpacing: 0.15,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const FlipHintRow(
                  text: 'TAP TO RETURN',
                  isStandalone: false,
                  showTrailingIcon: true,
                  leadingIcon: Icons.autorenew_rounded,
                  trailingIcon: Icons.touch_app_rounded,
                  spaceBetween: true,
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
