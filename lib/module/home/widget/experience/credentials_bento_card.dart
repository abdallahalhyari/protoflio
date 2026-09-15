import 'package:flutter/material.dart';

import '../../../../theme/tokens.dart';
import '../../data/experience_data.dart';

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

  Widget _buildSectionHeader(String title, ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: scheme.primary, width: 2)),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: AppTypography.displayFont,
          color: scheme.onSurface,
          fontSize: 16,
          letterSpacing: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;

    return AnimatedOpacity(
      duration: AppMotion.entry,
      curve: Curves.easeOutCubic,
      opacity: isVisible ? 1.0 : 0.0,
      child: AnimatedSlide(
        duration: AppMotion.entry,
        curve: Curves.easeOutCubic,
        offset: isVisible
            ? Offset.zero
            : (isDesktop ? const Offset(0.2, 0) : const Offset(0, 0.2)),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: isDesktop ? 0 : AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: isDark
                  ? scheme.primary.withValues(alpha: 0.3)
                  : AppColors.slate300,
              width: isDark ? 1.5 : 1.0,
            ),
            color: isDark
                ? scheme.surface.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.90),
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: AppColors.slate900.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: RepaintBoundary(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Builder(
                builder: (context) {
                  final content = Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('ACADEMIC ANNEX', scheme),
                        const SizedBox(height: 12),
                        ...kEducation.map((edu) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    edu.degree,
                                    style: TextStyle(
                                      color: scheme.onSurface,
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    '${edu.institution} · ${edu.period}',
                                    style: TextStyle(
                                      color: scheme.primary,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  if (edu.note != null)
                                    Text(
                                      edu.note!,
                                      style: TextStyle(
                                        color: scheme.onSurface
                                            .withValues(alpha: 0.7),
                                        fontSize: 12.0,
                                      ),
                                    ),
                                ],
                              ),
                            )),
                        const SizedBox(height: AppSpacing.md),
                        _buildSectionHeader('CERTIFICATION STAMPS', scheme),
                        const SizedBox(height: 12),
                        ...kCertifications.map((cert) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '❖ ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark
                                          ? const Color(0xFFFBBF24)
                                          : const Color(0xFFD97706),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      cert,
                                      style: TextStyle(
                                        color: scheme.onSurface
                                            .withValues(alpha: 0.9),
                                        fontSize: 13,
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
