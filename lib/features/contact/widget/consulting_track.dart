import 'package:flutter/material.dart';

import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';

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

  Color _adaptiveAccent(BuildContext context, Color color) {
    if (context.isDarkMode) return color;
    final val = color.toARGB32();
    if (val == 0xFF38BDF8) return AppColors.accentSkyDeep;
    if (val == 0xFF34D399) return AppColors.accentGreenDeep;
    if (val == 0xFF818CF8) return AppColors.accentIndigoDeepText;
    if (val == 0xFF8B5CF6) return AppColors.accentVioletDeep;
    return color;
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.track;
    final isDark = context.isDarkMode;
    final accentText = _adaptiveAccent(context, t.accent);
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: AppMotion.snap,
        curve: AppMotion.emphasized,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark
              ? (_hover
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.white.withValues(alpha: 0.04))
              : (_hover ? Colors.white : AppColors.slate50),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: _hover
                ? (isDark ? t.accent : accentText).withValues(alpha: 0.6)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : AppColors.slate200),
            width: 1.2,
          ),
          boxShadow: [
            if (_hover)
              BoxShadow(
                color: t.accent.withValues(alpha: isDark ? 0.15 : 0.08),
                blurRadius: 18,
                offset: const Offset(0, 6),
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
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: t.accent.withValues(alpha: isDark ? 0.14 : 0.10),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: (isDark ? t.accent : accentText)
                          .withValues(alpha: isDark ? 0.35 : 0.4),
                      width: 1,
                    ),
                  ),
                  child: Icon(t.icon, size: 18, color: accentText),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: t.accent.withValues(alpha: isDark ? 0.10 : 0.08),
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        t.tag,
                        style: TextStyle(
                          color: accentText,
                          fontSize: AppTypography.micro,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              t.title,
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.slate900,
                fontSize: AppTypography.bodyLoose,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              t.description,
              style: TextStyle(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.72)
                    : AppColors.slate500,
                fontSize: AppTypography.captionSm,
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'INQUIRE TRACK',
                      style: TextStyle(
                        color: accentText,
                        fontSize: AppTypography.micro,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded,
                        size: 12, color: accentText),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
