import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/features/experience/domain/repositories/experience_repository.dart';
import 'package:profile/shared/utils/bidi.dart';

/// Education and certifications beside the career timeline: one card,
/// two plain subheads. A certification's provider sits on its own muted
/// line under the course name.
class CredentialsBentoCard extends StatelessWidget {
  final bool isVisible;
  final bool isDesktop;

  const CredentialsBentoCard({
    super.key,
    required this.isVisible,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;

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
          child: RepaintBoundary(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final repo = context.read<ExperienceRepository>();
                final muted = TextStyle(
                  color: context.mutedText,
                  fontSize: AppTypography.label + 1,
                  height: 1.45,
                );

                Widget subhead(String text) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Semantics(
                        header: true,
                        child: Text(
                          text,
                          style: TextStyle(
                            color: context.onSurface,
                            fontSize: AppTypography.lead,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );

                Widget entry(String title, List<String> lines) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: context.onSurface,
                              fontSize: AppTypography.body,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                          for (final line in lines)
                            Text(ltrContent(context, line), style: muted),
                        ],
                      ),
                    );

                final content = Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: context.cardGlass,
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    border: Border.all(
                      color:
                          isDark ? context.glassBorderStrong : AppColors.ink200,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      subhead(l10n.sectionEducation),
                      for (final edu in repo.getEducation())
                        entry(edu.degree, [
                          '${edu.institution}, ${edu.period}',
                          if (edu.note != null) edu.note!,
                        ]),
                      const SizedBox(height: AppSpacing.sm),
                      subhead(l10n.sectionCertifications),
                      for (final cert in repo.getCertifications())
                        _certEntry(cert, entry),
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
    );
  }

  Widget _certEntry(
    String cert,
    Widget Function(String, List<String>) entry,
  ) {
    final i = cert.lastIndexOf(' — ');
    if (i < 0) return entry(cert, const []);
    return entry(cert.substring(0, i), [cert.substring(i + 3)]);
  }
}
