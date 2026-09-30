import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/features/intro/widget/hero_motion.dart';

class HeroRoleBlock extends StatelessWidget {
  final Size size;
  final bool isDark;
  final bool isCompactH;

  const HeroRoleBlock({
    super.key,
    required this.size,
    required this.isDark,
    required this.isCompactH,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return SnappyEntrance(
      delayMs: 60,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: (size.width * 0.78).clamp(320.0, 700.0),
          ),
          child: Column(
            children: [
              _HairlineRow(
                isDark: isDark,
                child: Icon(Icons.diamond_rounded,
                    size: AppTypography.small, color: accent),
              ),
              SizedBox(height: isCompactH ? 6.0 : AppSpacing.sm),
              Text(
                AppLocalizations.of(context)!.introSeniorEngineer.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isCompactH
                      ? (size.width * 0.016).clamp(15.0, 19.0)
                      : (size.width * 0.018).clamp(16.0, 22.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  color: context.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppLocalizations.of(context)!.introBuildsComplex,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isCompactH
                      ? (size.width * 0.0105).clamp(12.0, 15.0)
                      : (size.width * 0.0115).clamp(12.5, 18.0),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: isDark ? AppColors.accentIndigoSoft : accent,
                ),
              ),
              SizedBox(height: isCompactH ? 6.0 : AppSpacing.sm),
              Text(
                AppLocalizations.of(context)!.introTechStack,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isCompactH
                      ? (size.width * 0.01).clamp(11.0, 12.5)
                      : (size.width * 0.011).clamp(11.5, 13.5),
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.82)
                      : AppColors.slate600,
                  height: 1.45,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HairlineRow extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const _HairlineRow({required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final ruleColor = context.glassBorderStrong;
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: ruleColor)),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12), child: child),
        Expanded(child: Container(height: 1, color: ruleColor)),
      ],
    );
  }
}
