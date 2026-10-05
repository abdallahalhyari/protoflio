import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/theme/tokens.dart';

class HeroIssueStrip extends StatelessWidget {
  final Size size;
  final bool isDark;

  const HeroIssueStrip({super.key, required this.size, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final fs = (size.width * 0.011).clamp(10.0, 13.0);
    Widget rule() =>
        Container(width: 32, height: 1, color: accent.withValues(alpha: 0.7));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CornerMark(accent: accent),
        const Spacer(),
        rule(),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          flex: 8,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              AppLocalizations.of(context)!.introIssueStrip,
              style: TextStyle(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.85)
                    : AppColors.ink600,
                fontSize: fs,
                fontWeight: FontWeight.w800,
                letterSpacing: size.width < AppBreakpoints.tablet ? 1.5 : 2.0,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        rule(),
        const Spacer(),
        _CornerMark(accent: accent),
      ],
    );
  }
}

class _CornerMark extends StatelessWidget {
  final Color accent;

  const _CornerMark({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: accent.withValues(alpha: 0.7)),
      ),
      child: Center(
        child: Container(
          width: 3,
          height: 3,
          decoration: BoxDecoration(
            color: accent,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
