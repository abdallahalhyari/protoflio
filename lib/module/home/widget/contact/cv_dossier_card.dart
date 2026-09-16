import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import '../../../../service/analytics_service.dart';
import '../../../../service/cv_service.dart';
import '../../../../theme/surface_tone.dart';
import '../../../../theme/tokens.dart';

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
          color: isDark
              ? AppColors.slate900.withValues(alpha: 0.7)
              : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isDark
                ? accent.withValues(alpha: 0.4)
                : AppColors.slate200,
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
                          width: 1,
                        ),
                      ),
                      child: Text(
                        l10n.contactAtsVerified,
                        style: TextStyle(
                          color: context.amberText,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ),
                    Text(
                      l10n.contactPdfSize,
                      style: TextStyle(
                        color: isDark ? Colors.white60 : AppColors.slate500,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.contactCvDossierTitle,
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.slate900,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.contactCvDossierDesc,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.7)
                        : AppColors.slate500,
                    fontSize: 12.5,
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
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.4,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.black,
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
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        isDark ? Colors.white : AppColors.slate900,
                    side: BorderSide(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.3)
                          : AppColors.slate300,
                      width: 1,
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
