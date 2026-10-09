import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/features/experience/domain/repositories/experience_repository.dart';

/// Bento card housing academic credentials (degrees, institutions)
/// and certification stamps.
class CredentialsBentoCard extends StatelessWidget {
  final bool isVisible;
  final bool isDesktop;

  const CredentialsBentoCard({
    super.key,
    required this.isVisible,
    required this.isDesktop,
  });

  Widget _buildSectionHeader(
      String title, ColorScheme scheme, Color accentColor) {
    return Container(
      padding: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: accentColor.withValues(alpha: 0.6),
            width: 1.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.workspace_premium_rounded, size: 16, color: accentColor),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppTypography.displayFont,
                color: scheme.onSurface,
                fontSize: AppTypography.lead,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;
    final accentText = context.adaptiveAccentText(scheme.primary);

    return AnimatedOpacity(
      duration: AppMotion.entry,
      curve: AppMotion.emphasized,
      opacity: isVisible ? 1.0 : 0.0,
      child: AnimatedSlide(
        duration: AppMotion.entry,
        curve: AppMotion.emphasized,
        offset: isVisible || AppMedia.reduceMotion(context)
            ? Offset.zero
            : (isDesktop ? const Offset(0.2, 0) : const Offset(0, 0.2)),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: isDesktop ? 0 : AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.container),
            border: Border.all(
              color: isDark
                  ? scheme.primary.withValues(alpha: AppAlpha.border)
                  : AppColors.ink300,
              width: isDark ? 1.5 : 1.0,
            ),
            color: context.cardGlass,
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: AppColors.ink900.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: RepaintBoundary(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.container),
              child: Builder(
                builder: (context) {
                  final lang =
                      Localizations.maybeLocaleOf(context)?.languageCode;
                  final l10n = AppLocalizations.of(context);
                  final eduTitle = lang == 'ar'
                      ? (l10n?.sectionEducation ?? 'التعليم')
                      : (lang == 'cs'
                          ? (l10n?.sectionEducation ?? 'Vzdělání')
                          : 'Academic annex');
                  final certTitle = lang == 'ar'
                      ? (l10n?.sectionCertifications ?? 'الشهادات')
                      : (lang == 'cs'
                          ? (l10n?.sectionCertifications ?? 'Certifikace')
                          : 'Certification stamps');

                  final content = Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(
                          eduTitle,
                          scheme,
                          accentText,
                        ),
                        const SizedBox(height: 12),
                        ...context
                            .read<ExperienceRepository>()
                            .getEducation()
                            .map((edu) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        edu.degree,
                                        style: TextStyle(
                                          color: scheme.onSurface,
                                          fontSize: AppTypography.body,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Text(
                                        '${edu.institution} · ${edu.period}',
                                        style: TextStyle(
                                          color: accentText,
                                          fontSize: AppTypography.label,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      if (edu.note != null)
                                        Text(
                                          edu.note!,
                                          style: TextStyle(
                                            color: scheme.onSurface
                                                .withValues(alpha: 0.7),
                                            fontSize: AppTypography.label,
                                          ),
                                        ),
                                    ],
                                  ),
                                )),
                        const SizedBox(height: AppSpacing.md),
                        _buildSectionHeader(
                          certTitle,
                          scheme,
                          accentText,
                        ),
                        const SizedBox(height: 12),
                        ...context
                            .read<ExperienceRepository>()
                            .getCertifications()
                            .map((cert) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Icon(
                                          Icons.diamond_rounded,
                                          size: AppTypography.label,
                                          color: context.amberText,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          cert,
                                          style: TextStyle(
                                            color: scheme.onSurface
                                                .withValues(alpha: 0.9),
                                            fontSize: AppTypography.body,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                      ],
                    ),
                  );

                  return isDesktop
                      ? SingleChildScrollView(primary: false, child: content)
                      : content;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
