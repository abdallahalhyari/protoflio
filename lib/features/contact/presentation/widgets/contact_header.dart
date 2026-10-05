import 'package:flutter/material.dart';

import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/utils/bidi.dart';

/// Top header banner, display headline, and lede paragraph for the Contact & Reach Out section.
class ContactHeader extends StatelessWidget {
  const ContactHeader({super.key});

  static const _accent = AppColors.accentViolet;
  static const _accentSoft = AppColors.accentVioletLight;

  Widget _issueStrip(BuildContext context, bool isDark, AppLocalizations loc) {
    Widget rule() => Container(
          width: 36,
          height: 1.5,
          color: _accent.withValues(alpha: 0.75),
        );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        rule(),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              loc.contactHeaderKicker,
              style: TextStyle(
                color: isDark ? _accentSoft : AppColors.accentVioletDeep,
                fontSize: AppTypography.caption,
                fontWeight: FontWeight.w900,
                letterSpacing: latinTracking(context, 4),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        rule(),
      ],
    );
  }

  Widget _headline(Size size, BuildContext context, AppLocalizations loc) {
    final isDark = context.isDarkMode;
    final fs = (size.width * 0.055).clamp(32.0, 68.0);
    return Semantics(
      header: true,
      child: Text(
        loc.contactHeaderTitle,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: AppTypography.displayFont,
          fontSize: fs,
          fontWeight: FontWeight.w900,
          letterSpacing: latinTracking(context, 2.5),
          color: context.onSurface,
          height: 1.05,
          shadows: isDark
              ? const [Shadow(blurRadius: 20)]
              : const [Shadow(color: Colors.black12, blurRadius: 6)],
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
            letterSpacing: latinTracking(context, 0.3),
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
        const SizedBox(height: AppSpacing.xl),
        _headline(size, context, loc),
        const SizedBox(height: AppSpacing.md),
        _lede(size, context, loc),
      ],
    );
  }
}
