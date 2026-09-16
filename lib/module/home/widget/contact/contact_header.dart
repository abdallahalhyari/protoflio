import 'package:flutter/material.dart';

import '../../../../theme/surface_tone.dart';
import '../../../../theme/tokens.dart';

/// Top header banner, display headline, and lede paragraph for the Contact & Reach Out section.
class ContactHeader extends StatelessWidget {
  const ContactHeader({super.key});

  static const _accent = Color(0xFF8B5CF6);
  static const _accentSoft = Color(0xFFA78BFA);

  Widget _issueStrip(bool isDark) {
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
              'FEATURE 07 · DIRECT LINE & REACH OUT',
              style: TextStyle(
                color: isDark ? _accentSoft : _accent,
                fontSize: AppTypography.caption,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        rule(),
      ],
    );
  }

  Widget _headline(Size size, BuildContext context) {
    final isDark = context.isDarkMode;
    final fs = (size.width * 0.055).clamp(32.0, 68.0);
    return Text(
      "LET'S BUILD SOMETHING EXTRAORDINARY",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: AppTypography.displayFont,
        fontSize: fs,
        fontWeight: FontWeight.w900,
        letterSpacing: 2.5,
        color: context.onSurface,
        height: 1.05,
        shadows: isDark
            ? const [Shadow(color: Colors.black, blurRadius: 20)]
            : const [Shadow(color: Colors.black12, blurRadius: 6)],
      ),
    );
  }

  Widget _lede(Size size, BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Text(
          'Principal & Senior Mobile Software Architect with 6+ years delivering resilient '
          'production Flutter engines, offline-first sync protocols, and native iOS/Android bridges. '
          'Available for senior full-time leadership, architectural audits, and technical partnerships.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: context.mutedText,
            fontSize: (size.width * 0.014).clamp(13.5, 17.0),
            height: 1.6,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isDark = context.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _issueStrip(isDark),
        const SizedBox(height: AppSpacing.xl),
        _headline(size, context),
        const SizedBox(height: AppSpacing.md),
        _lede(size, context),
      ],
    );
  }
}
