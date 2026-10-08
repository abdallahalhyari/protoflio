import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/core/services/analytics_service.dart';
import 'package:profile/core/services/cv_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

class CvDossierCard extends StatelessWidget {
  const CvDossierCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;
    final isDark = context.isDarkMode;
    final l10n = AppLocalizations.of(context)!;

    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color:
              isDark ? AppColors.ink900.withValues(alpha: 0.7) : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isDark ? accent.withValues(alpha: 0.4) : AppColors.ink200,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: isDark ? 0.06 : 0.03),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 750;

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
                      child: Text(
                        l10n.contactAtsVerified,
                        style: TextStyle(
                          color: context.amberText,
                          fontSize: AppTypography.label,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Text(
                      l10n.contactPdfSize,
                      style: TextStyle(
                        color: isDark ? Colors.white60 : AppColors.ink500,
                        fontSize: AppTypography.label,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.contactCvDossierTitle,
                  style: TextStyle(
                    color: context.onSurface,
                    fontSize: AppTypography.lead,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.contactCvDossierDesc,
                  style: TextStyle(
                    color: context.mutedText,
                    fontSize: AppTypography.label,
                    height: 1.4,
                  ),
                ),
              ],
            );

            final actionButtons = Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
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
                        horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    elevation: 2,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () async {
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
                actionButtons,
              ],
            );
          },
        ),
      ),
    );
  }
}
