import 'package:flutter/material.dart';

import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/l10n/app_localizations.dart';

class ConsultingTrack {
  final String tag;
  final String title;
  final String description;
  final IconData icon;
  final Color accent;
  final String inquirySubject;
  final ValueChanged<String> onInquire;

  const ConsultingTrack({
    required this.tag,
    required this.title,
    required this.description,
    required this.icon,
    required this.accent,
    required this.inquirySubject,
    required this.onInquire,
  });
}

class BentoTrackCard extends StatefulWidget {
  final ConsultingTrack track;

  const BentoTrackCard({
    super.key,
    required this.track,
  });

  @override
  State<BentoTrackCard> createState() => _BentoTrackCardState();
}

class _BentoTrackCardState extends State<BentoTrackCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.track;
    final isDark = context.isDarkMode;
    final accentText = context.adaptiveAccentText(t.accent);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover ? 1.02 : 1.0,
        duration: AppMotion.cardHover,
        curve: AppMotion.emphasized,
        child: AnimatedContainer(
          duration: AppMotion.cardHover,
          curve: AppMotion.emphasized,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark
                ? (_hover
                    ? Colors.white.withValues(alpha: 0.07)
                    : Colors.white.withValues(alpha: 0.035))
                : (_hover ? Colors.white : AppColors.ink50),
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: _hover
                  ? (isDark ? t.accent : accentText).withValues(alpha: 0.8)
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : AppColors.ink200),
              width: _hover ? 1.4 : 1.1,
            ),
            boxShadow: [
              if (_hover)
                BoxShadow(
                  color: t.accent.withValues(alpha: isDark ? 0.25 : 0.12),
                  blurRadius: 28,
                  offset: const Offset(0, 10),
                  spreadRadius: 2,
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: t.accent.withValues(alpha: isDark ? 0.16 : 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(
                        color: (isDark ? t.accent : accentText)
                            .withValues(alpha: isDark ? 0.45 : 0.4),
                      ),
                    ),
                    child: Icon(t.icon, size: 20, color: accentText),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: t.accent.withValues(alpha: isDark ? 0.12 : 0.08),
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                        border: Border.all(
                          color: (isDark ? t.accent : accentText)
                              .withValues(alpha: isDark ? 0.3 : 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: accentText,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                t.tag,
                                style: TextStyle(
                                  fontFamily: AppTypography.monoFont,
                                  color: accentText,
                                  fontSize: AppTypography.label,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                t.title,
                style: TextStyle(
                  fontFamily: AppTypography.displayFont,
                  color: context.onSurface,
                  fontSize: AppTypography.body,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                t.description,
                style: TextStyle(
                  color: context.mutedText,
                  fontSize: AppTypography.label,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Semantics(
                button: true,
                label: 'Inquire about ${t.title} consulting track',
                child: InkWell(
                  onTap: () {
                    SoundService.instance.playClick();
                    t.onInquire(t.inquirySubject);
                  },
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            AppLocalizations.of(context)!.uiInquireTrack,
                            style: TextStyle(
                              fontFamily: AppTypography.monoFont,
                              color: accentText,
                              fontSize: AppTypography.label,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        AnimatedPadding(
                          duration: AppMotion.cardHover,
                          curve: AppMotion.emphasized,
                          padding: EdgeInsets.only(left: _hover ? 6.0 : 0.0),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 13,
                            color: accentText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
