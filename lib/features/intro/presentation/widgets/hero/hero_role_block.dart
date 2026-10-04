import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/intro/presentation/widgets/hero_motion.dart';
import 'package:profile/shared/utils/bidi.dart';

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
    final loc = AppLocalizations.of(context)!;

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
                loc.introRoleHeading,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isCompactH
                      ? (size.width * 0.016).clamp(15.0, 19.0)
                      : (size.width * 0.018).clamp(16.0, 22.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: latinTracking(context, 3),
                  color: context.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                loc.introValueProposition,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isCompactH
                      ? (size.width * 0.0105).clamp(12.0, 15.0)
                      : (size.width * 0.0115).clamp(12.5, 18.0),
                  fontWeight: FontWeight.w800,
                  letterSpacing: latinTracking(context, 1.2),
                  color: isDark ? AppColors.accentIndigoSoft : accent,
                  height: 1.45,
                ),
              ),
              SizedBox(height: isCompactH ? 6.0 : AppSpacing.sm),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  _MiniPill('Flutter'),
                  _MiniPill('Android'),
                  _MiniPill(loc.introSkillArchitecture),
                  _MiniPill(loc.introSkillProductDelivery),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  final String label;

  const _MiniPill(this.label);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color:
            isDark ? Colors.white.withValues(alpha: 0.05) : AppColors.slate100,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : AppColors.slate200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            fontFamily: AppTypography.monoFont,
            color: context.onSurface,
            fontSize: AppTypography.micro,
            fontWeight: FontWeight.w800,
            letterSpacing: latinTracking(context, 1.1),
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
