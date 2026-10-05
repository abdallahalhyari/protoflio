import 'package:flutter/material.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/intro/presentation/widgets/credential/credential_painters.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/widgets/retrying_asset_image.dart';

/// Design size of a card face. ISO/IEC 7810 ID-1 is 85.60 × 53.98 mm;
/// faces are laid out at this size and scaled as one object, like a real
/// card, so nothing reflows between phone and desktop.
const Size kCredentialDesignSize = Size(360, 227);

/// Corner radius of an ID-1 card (3.18 mm) at the design size.
const double kCredentialRadius = 13;

/// Machine-readable zone, TD1-style: fixed 30-character lines padded with
/// filler chevrons.
String _mrz(String s) => s.padRight(30, '<').substring(0, 30);
final List<String> kCredentialMrz = [
  _mrz('I<JOR<AMMAN<<BRNO<2027'),
  _mrz('ALHYARI<<ABDALLAH'),
];

class _FacePalette {
  _FacePalette(BuildContext context)
      : isDark = context.isDarkMode,
        ink = context.isDarkMode ? Colors.white : AppColors.ink900,
        label = context.isDarkMode
            ? Colors.white.withValues(alpha: 0.66)
            : AppColors.ink500,
        line = context.isDarkMode
            ? AppColors.tealLight.withValues(alpha: 0.16)
            : AppColors.teal.withValues(alpha: 0.16);

  final bool isDark;
  final Color ink;
  final Color label;
  final Color line;

  Gradient get stock => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? const [AppColors.darkSurfaceElevated, AppColors.darkCard]
            : const [Colors.white, AppColors.ink50],
      );
}

/// Shared card body: laminated stock, rounded ID-1 corners, hairline edge.
class _CardStock extends StatelessWidget {
  const _CardStock({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = _FacePalette(context);
    return SizedBox.fromSize(
      size: kCredentialDesignSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: p.stock,
          borderRadius: BorderRadius.circular(kCredentialRadius),
          border: Border.all(color: context.glassBorder),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(kCredentialRadius),
          child: child,
        ),
      ),
    );
  }
}

class CredentialFront extends StatelessWidget {
  const CredentialFront({super.key, required this.pulse});

  /// Drives the contactless arcs while the chip is read.
  final Animation<double> pulse;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final p = _FacePalette(context);

    Widget field(String label, String value, double size, FontWeight weight) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: p.label,
                fontSize: AppTypography.label,
                height: 1.15,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: p.ink,
                fontSize: size,
                fontWeight: weight,
                height: 1.2,
              ),
            ),
          ],
        ),
      );
    }

    return _CardStock(
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: GuillochePainter(color: p.line)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 40,
                      height: 31,
                      child: CustomPaint(painter: ChipPainter()),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 22,
                      height: 26,
                      child: CustomPaint(
                        painter: ContactlessPainter(
                          color: p.ink,
                          pulse: pulse,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: SizedBox(
                          width: 64,
                          height: 80,
                          child: ColoredBox(
                            color: p.label.withValues(alpha: 0.15),
                            child: const RetryingAssetImage(
                              'assets/my_image.webp',
                              fit: BoxFit.cover,
                              cacheWidth: 192,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        // Long translations shrink rather than overflow
                        // the fixed card.
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.topStart,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              field(
                                loc.cardFieldSurname,
                                loc.cardSurname,
                                AppTypography.title,
                                FontWeight.w600,
                              ),
                              field(
                                loc.cardFieldGiven,
                                loc.cardGivenName,
                                AppTypography.lead,
                                FontWeight.w500,
                              ),
                              field(
                                loc.cardFieldRole,
                                loc.cardRole,
                                AppTypography.body,
                                FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // The MRZ is read left to right in every locale.
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final line in kCredentialMrz)
                        Text(
                          line,
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                            fontFamily: AppTypography.monoFont,
                            color: p.ink.withValues(alpha: 0.82),
                            fontSize: AppTypography.cardMrz,
                            letterSpacing: 2.4,
                            height: 1.15,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CredentialBack extends StatelessWidget {
  const CredentialBack({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final p = _FacePalette(context);
    final outcomes = [loc.cardOutcome1, loc.cardOutcome2, loc.cardOutcome3];

    return _CardStock(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          // Magnetic stripe.
          Container(
            height: 32,
            color: p.isDark ? AppColors.ink950 : AppColors.ink900,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.topStart,
                child: SizedBox(
                  width: kCredentialDesignSize.width - 32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.cardBackTitle,
                        style: TextStyle(
                          color: p.label,
                          fontSize: AppTypography.label,
                        ),
                      ),
                      for (final o in outcomes)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: p.label.withValues(alpha: 0.25),
                                width: 0.6,
                              ),
                            ),
                          ),
                          child: Text(
                            o,
                            style: TextStyle(
                              color: p.ink,
                              fontSize: AppTypography.cardBody,
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
