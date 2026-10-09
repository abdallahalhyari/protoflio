import 'package:flutter/material.dart';

import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/utils/bidi.dart';
import 'package:profile/shared/widgets/pulsing_dot.dart';

/// Top header banner, display headline, and lede paragraph for the Contact & Reach Out section.
class ContactHeader extends StatelessWidget {
  const ContactHeader({super.key});

  static const _accent = AppColors.teal;
  static const _accentSoft = AppColors.tealLight;

  Widget _issueStrip(BuildContext context, bool isDark, AppLocalizations loc) {
    Widget rule() => Container(
          width: 32,
          height: 1.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            gradient: LinearGradient(
              colors: [
                _accent.withValues(alpha: 0.1),
                _accent.withValues(alpha: 0.8),
              ],
            ),
          ),
        );

    Widget ruleRev() => Container(
          width: 32,
          height: 1.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            gradient: LinearGradient(
              colors: [
                _accent.withValues(alpha: 0.8),
                _accent.withValues(alpha: 0.1),
              ],
            ),
          ),
        );

    final kickerColor = isDark ? _accentSoft : AppColors.tealDeep;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        rule(),
        const SizedBox(width: AppSpacing.sm),
        PulsingDot(color: kickerColor),
        const SizedBox(width: 6),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              loc.contactHeaderKicker,
              style: TextStyle(
                fontFamily: AppTypography.monoFont,
                color: kickerColor,
                fontSize: AppTypography.label,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        ruleRev(),
      ],
    );
  }

  Widget _headline(Size size, BuildContext context, AppLocalizations loc) {
    final isDark = context.isDarkMode;
    final fs = (size.width * 0.055).clamp(32.0, 68.0);

    return Semantics(
      header: true,
      child: ShaderMask(
        shaderCallback: (bounds) {
          return LinearGradient(
            colors: [
              context.onSurface,
              isDark ? Colors.white : AppColors.ink800,
              _accent,
              context.onSurface,
            ],
            stops: const [0.0, 0.35, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        child: Text(
          loc.contactHeaderTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppTypography.displayFont,
            fontSize: fs,
            fontWeight: FontWeight.w900,
            color: context.onSurface, // High contrast fallback
            height: 1.05,
            shadows: isDark
                ? const [Shadow(blurRadius: 30, color: Colors.black54)]
                : const [Shadow(color: Colors.black12, blurRadius: 10)],
          ),
        ),
      ),
    );
  }

  Widget _lede(Size size, BuildContext context, AppLocalizations loc) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Text(
          ltrContent(
            context,
            loc.contactHeaderSubtitle,
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: context.mutedText,
            fontSize: (size.width * 0.014).clamp(13.5, 17.0),
            height: 1.6,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isDark = context.isDarkMode;
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _issueStrip(context, isDark, loc),
        const SizedBox(height: AppSpacing.md),
        _headline(size, context, loc),
        const SizedBox(height: AppSpacing.sm),
        _lede(size, context, loc),
      ],
    );
  }
}
