import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/intro/presentation/widgets/hero_motion.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/widgets/pulsing_dot.dart';
import 'package:profile/shared/widgets/typewriter_text.dart';

/// Left column of the cover: availability, the name, the role and one
/// plain sentence about the work. Everything a recruiter screens for sits
/// above the buttons. Plays its slice of the cover's entrance via [reveal].
class HeroStatement extends StatelessWidget {
  final Size size;
  final bool isDark;
  final bool isWide;
  final Animation<double> reveal;

  const HeroStatement({
    super.key,
    required this.size,
    required this.isDark,
    required this.isWide,
    required this.reveal,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final compactHeight = isWide && size.height < 940;
    final nameSize = isWide
        ? (size.width * 0.075).clamp(64.0, compactHeight ? 76.0 : 96.0)
        : (size.width * 0.17).clamp(52.0, 84.0);

    final nameStyle = TextStyle(
      fontFamily: AppTypography.wordmarkFont,
      fontSize: nameSize,
      fontWeight: FontWeight.w900,
      height: 0.98,
      color: context.onSurface,
    );

    Widget nameLine(String text, Color? color) => FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Text(text, style: nameStyle.copyWith(color: color)),
        );

    final gap = compactHeight
        ? AppSpacing.xs
        : (isWide ? AppSpacing.md : AppSpacing.sm);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        HeroStep(
          animation: reveal,
          begin: 0.02,
          end: 0.38,
          child: Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(
                color: scheme.primary.withValues(alpha: isDark ? 0.4 : 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PulsingDot(color: AppColors.tealLight),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    l10n.introRoleLine,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppTypography.monoFont,
                      fontSize: AppTypography.label,
                      fontWeight: FontWeight.w900,
                      color: context.adaptiveAccentText(scheme.primary),
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Semantics(
          header: true,
          headingLevel: 1,
          label: l10n.semanticTitle,
          excludeSemantics: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeroStep(
                animation: reveal,
                begin: 0.08,
                end: 0.5,
                mask: true,
                child: nameLine('ABDALLAH', null),
              ),
              HeroStep(
                animation: reveal,
                begin: 0.2,
                end: 0.62,
                mask: true,
                child: nameLine('ALHYARI', scheme.primary),
              ),
            ],
          ),
        ),
        SizedBox(height: gap),
        HeroStep(
          animation: reveal,
          begin: 0.42,
          end: 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TypewriterText(
                text: l10n.introTagline,
                trigger: reveal,
                triggerAt: 0.65,
                cursorColor: scheme.primary,
                style: TextStyle(
                  fontSize: isWide
                      ? (compactHeight
                          ? AppTypography.title
                          : AppTypography.heading)
                      : AppTypography.title,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                  color: context.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Text(
                  l10n.introValueProposition,
                  style: TextStyle(
                    fontSize:
                        compactHeight ? AppTypography.body : AppTypography.lead,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                    color: context.onSurface
                        .withValues(alpha: isDark ? 0.95 : 0.90),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: _buildTechPills(context, scheme, isDark),
              ),
              if (!isWide) ...[
                const SizedBox(height: AppSpacing.smd),
                _MobileAvailabilityCue(scheme: scheme, isDark: isDark),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTechPills(
      BuildContext context, ColorScheme scheme, bool isDark) {
    const pills = [
      ('Flutter & Dart', Icons.flutter_dash_rounded),
      ('Android · Kotlin', Icons.android_rounded),
      ('ISO-7816 NFC', Icons.nfc_rounded),
      ('Offline-First Sync', Icons.sync_rounded),
      ('Clean Architecture', Icons.architecture_rounded),
    ];

    final screenWidth = MediaQuery.sizeOf(context).width;

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final item in pills)
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: (screenWidth - 48).clamp(100.0, 280.0)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
              decoration: BoxDecoration(
                color: isDark
                    ? scheme.primary.withValues(alpha: 0.10)
                    : AppColors.ink100,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(
                  color: scheme.primary.withValues(alpha: isDark ? 0.35 : 0.25),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.$2,
                      size: 12,
                      color: context.adaptiveAccentText(scheme.primary),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.$1,
                      style: TextStyle(
                        fontFamily: AppTypography.monoFont,
                        fontSize: AppTypography.label,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                        color: isDark ? Colors.white : AppColors.ink900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Brings the most important hiring fact into the mobile hero without
/// duplicating the full interactive trace card that follows it.
class _MobileAvailabilityCue extends StatelessWidget {
  const _MobileAvailabilityCue({required this.scheme, required this.isDark});

  final ColorScheme scheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final availableColor = isDark ? AppColors.tealLight : AppColors.tealDeep;

    return Semantics(
      label: '${l10n.heroFactAvailableLabel}: ${l10n.heroFactAvailableValue}. '
          '${l10n.heroFactBasedLabel}: ${l10n.heroFactBasedValue}.',
      child: ExcludeSemantics(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.smd,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? scheme.primary.withValues(alpha: 0.08)
                : AppColors.ink100.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color: availableColor.withValues(alpha: isDark ? 0.45 : 0.32),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: PulsingDot(color: availableColor),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.heroFactAvailableLabel.toUpperCase(),
                      style: TextStyle(
                        color: context.onSurface.withValues(alpha: 0.82),
                        fontFamily: AppTypography.monoFont,
                        fontSize: AppTypography.label,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.heroFactAvailableValue,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: availableColor,
                        fontSize: AppTypography.label + 1,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.heroFactBasedValue,
                      style: TextStyle(
                        color: context.mutedText,
                        fontSize: AppTypography.label,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
