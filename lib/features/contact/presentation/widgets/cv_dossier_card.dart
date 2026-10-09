import 'dart:async';
import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/core/services/analytics_service.dart';
import 'package:profile/core/services/cv_service.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/contact/presentation/widgets/vcard_qr_dialog.dart';
import 'package:profile/shared/widgets/magnetic_pull.dart';

class CvDossierCard extends StatefulWidget {
  const CvDossierCard({super.key});

  @override
  State<CvDossierCard> createState() => _CvDossierCardState();
}

class _CvDossierCardState extends State<CvDossierCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;
    final isDark = context.isDarkMode;
    final l10n = AppLocalizations.of(context)!;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: AppMotion.cardHover,
        curve: AppMotion.emphasized,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.container),
          border: Border.all(
            color: _hover
                ? accent.withValues(alpha: isDark ? 0.7 : 0.5)
                : (isDark ? accent.withValues(alpha: 0.35) : AppColors.ink200),
            width: _hover ? 1.5 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(
                  alpha:
                      _hover ? (isDark ? 0.20 : 0.09) : (isDark ? 0.08 : 0.04)),
              blurRadius: _hover ? 32 : 20,
              offset: const Offset(0, 8),
              spreadRadius: _hover ? 2 : 0,
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 680;

            final metaBlock = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: isDark ? 0.18 : 0.12),
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                        border: Border.all(
                          color: accent.withValues(alpha: 0.4),
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              size: 11,
                              color: context.amberText,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l10n.contactAtsVerified,
                              style: TextStyle(
                                fontFamily: AppTypography.monoFont,
                                color: context.amberText,
                                fontSize: AppTypography.label,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      l10n.contactPdfSize,
                      style: TextStyle(
                        fontFamily: AppTypography.monoFont,
                        color: isDark ? Colors.white60 : AppColors.ink500,
                        fontSize: AppTypography.label,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.contactCvDossierTitle,
                  style: TextStyle(
                    fontFamily: AppTypography.displayFont,
                    color: context.onSurface,
                    fontSize: AppTypography.lead,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.contactCvDossierDesc,
                  style: TextStyle(
                    color: context.mutedText,
                    fontSize: AppTypography.label,
                    height: 1.45,
                  ),
                ),
              ],
            );

            final actionButtons = Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                MagneticPull(
                  maxPull: 6.0,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      SoundService.instance.playClick();
                      Analytics.ctaCvDownload();
                      await CvService.open(context);
                    },
                    icon: const Icon(Icons.download_rounded, size: 16),
                    label: Text(
                      l10n.contactDownloadCvPdf,
                      style: const TextStyle(
                        fontSize: AppTypography.label,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: scheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      elevation: _hover ? 3 : 1,
                    ),
                  ),
                ),
                MagneticPull(
                  maxPull: 6.0,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      SoundService.instance.playClick();
                      Analytics.ctaCvDownload();
                      await CvService.open(context);
                    },
                    icon: const Icon(Icons.open_in_new_rounded, size: 14),
                    label: Text(
                      l10n.contactPreview,
                      style: const TextStyle(
                        fontSize: AppTypography.label,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.onSurface,
                      side: BorderSide(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.3)
                            : AppColors.ink300,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                    ),
                  ),
                ),
                MagneticPull(
                  maxPull: 6.0,
                  child: FilledButton.tonalIcon(
                    onPressed: () {
                      SoundService.instance.playClick();
                      unawaited(VCardQrDialog.show(context));
                    },
                    icon: const Icon(Icons.qr_code_2_rounded, size: 16),
                    label: const Text(
                      'vCard QR',
                      style: TextStyle(
                        fontSize: AppTypography.label,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                    ),
                  ),
                ),
              ],
            );

            if (isNarrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  metaBlock,
                  const SizedBox(height: AppSpacing.md),
                  actionButtons,
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: metaBlock),
                const SizedBox(width: AppSpacing.lg),
                Flexible(child: actionButtons),
              ],
            );
          },
        ),
      ),
    );
  }
}

