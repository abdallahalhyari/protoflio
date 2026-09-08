import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../data/experience_data.dart';
import '../widget/experience_tile.dart';

class ExperiencePage extends StatelessWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final headingSize =
        (size.width * 0.055).clamp(AppTypography.heading, AppTypography.displayLg);
    final isWide = size.width >= 900;
    final loc = AppLocalizations.of(context)!;

    final expList = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < kExperience.length; i++)
          ExperienceTile(
            exp: kExperience[i],
            isFirst: i == 0,
            isLast: i == kExperience.length - 1,
            index: i,
          ),
      ],
    );

    final eduSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.sectionEducation,
          style: TextStyle(
            color: scheme.onSurface,
            fontSize: AppTypography.title,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.smd),
        ...kEducation.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md - 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.degree,
                  style: TextStyle(
                    fontSize: AppTypography.bodyMd,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                Text(
                  '${e.institution} · ${e.period}',
                  style: TextStyle(
                    fontSize: AppTypography.small,
                    color: scheme.primary,
                  ),
                ),
                if (e.note != null)
                  Text(
                    e.note!,
                    style: TextStyle(
                      fontSize: AppTypography.caption,
                      color: scheme.onSurface.withValues(alpha: 0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg - 4),
        Text(
          loc.sectionCertifications,
          style: TextStyle(
            color: scheme.onSurface,
            fontSize: AppTypography.title,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.sm + 2),
        ...kCertifications.map(
          (c) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm - 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm - 2),
                  child: Icon(Icons.verified,
                      size: 14, color: scheme.primary),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    c,
                    style: TextStyle(
                      fontSize: AppTypography.small,
                      color: scheme.onSurface.withValues(alpha: 0.85),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg + 4, AppSpacing.lg, AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                loc.navExperience.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: headingSize,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: AppSpacing.lg - 4),
              Expanded(
                child: SingleChildScrollView(
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: expList),
                            const SizedBox(width: AppSpacing.xl + 8),
                            Expanded(flex: 2, child: eduSection),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            expList,
                            const SizedBox(height: AppSpacing.lg - 4),
                            eduSection,
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

