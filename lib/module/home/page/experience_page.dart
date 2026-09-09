import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../data/experience_data.dart';
import '../model/experience.dart';

class ExperiencePage extends StatefulWidget {
  final PageController? controller;
  final int? pageIndex;

  const ExperiencePage({super.key, this.controller, this.pageIndex});

  @override
  State<ExperiencePage> createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= 960;
    final loc = AppLocalizations.of(context)!;
    final isLight = theme.brightness == Brightness.light;
    final paperColor = isLight ? const Color(0xFFF7F5EE) : theme.scaffoldBackgroundColor;

    return Container(
      color: paperColor,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? AppSpacing.xxl : AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // BROADSHEET MASTHEAD & DATELINE
              _buildBroadsheetHeader(scheme, size),

              const SizedBox(height: AppSpacing.sm),

              // MULTI-COLUMN BROADSHEET CONTENT (Fits viewport — no nested scroll!)
              if (isDesktop)
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Column 1: Lead Stories (NatHealth & Eskadenia)
                      Expanded(
                        flex: 5,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          physics: const ClampingScrollPhysics(),
                          children: [
                            _buildCompanyArticle(kExperience[0], isLead: true, scheme: scheme),
                            const SizedBox(height: AppSpacing.md),
                            _buildPullQuote(
                              '"Engineered token-lifecycle security frameworks and an offline-first WorkManager pipeline for mission-critical operations without connectivity."',
                              scheme,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _buildCompanyArticle(kExperience[1], isLead: false, scheme: scheme),
                          ],
                        ),
                      ),

                      // Column Rule (Vertical Separator)
                      _buildColumnRule(scheme),

                      // Column 2: Secondary Stories (Solutions Now & Future Advanced)
                      Expanded(
                        flex: 4,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          physics: const ClampingScrollPhysics(),
                          children: [
                            _buildCompanyArticle(kExperience[2], isLead: false, scheme: scheme),
                            const SizedBox(height: AppSpacing.md),
                            _buildPullQuote(
                              '"Established reusable Flutter design patterns and architecture libraries deployed across consumer products."',
                              scheme,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _buildCompanyArticle(kExperience[3], isLead: false, scheme: scheme),
                          ],
                        ),
                      ),

                      // Column Rule (Vertical Separator)
                      _buildColumnRule(scheme),

                      // Column 3: The Academic Gazette & Credentials
                      Expanded(
                        flex: 3,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          physics: const ClampingScrollPhysics(),
                          children: [
                            _buildGazetteColumn(scheme, loc),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              else
                // Mobile: Scrollable column within Expanded to prevent double-scroll
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      for (int i = 0; i < kExperience.length; i++) ...[
                        _buildCompanyArticle(kExperience[i], isLead: i == 0, scheme: scheme),
                        if (i == 0) ...[
                          const SizedBox(height: AppSpacing.md),
                          _buildPullQuote(
                            '"Engineered token-lifecycle security frameworks and an offline-first WorkManager pipeline for mission-critical operations."',
                            scheme,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        Container(height: 1, color: scheme.onSurface.withValues(alpha: 0.1)),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      _buildGazetteColumn(scheme, loc),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBroadsheetHeader(ColorScheme scheme, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top Double Rule
        Container(height: 2, color: scheme.onSurface.withValues(alpha: 0.8)),
        const SizedBox(height: 3),
        Container(height: 0.75, color: scheme.onSurface.withValues(alpha: 0.4)),
        const SizedBox(height: 8),

        // Running Dateline
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'THE ENGINEERING CHRONICLE',
              style: TextStyle(
                color: scheme.onSurface.withValues(alpha: 0.7),
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
            Text(
              'CAREER DISPATCH // VOL. 24',
              style: TextStyle(
                color: scheme.primary,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 100),
              child: Text(
                'BROADSHEET ED.',
                style: TextStyle(
                  color: scheme.onSurface.withValues(alpha: 0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),
        Container(height: 0.75, color: scheme.onSurface.withValues(alpha: 0.4)),
        const SizedBox(height: 12),

        // Main Headline
        Text(
          'THE ARCHITECTURAL RECORD',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Tenada',
            color: scheme.onSurface,
            fontSize: (size.width * 0.05).clamp(28.0, 56.0),
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'A Definitive Survey of Enterprise Mobile Systems, Offline Sync, and Software Leadership',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: scheme.onSurface.withValues(alpha: 0.8),
            fontSize: (size.width * 0.014).clamp(12.0, 15.0),
            fontStyle: FontStyle.italic,
            letterSpacing: 0.5,
          ),
        ),

        const SizedBox(height: 12),
        Container(height: 1.5, color: scheme.onSurface.withValues(alpha: 0.6)),
      ],
    );
  }

  Widget _buildCompanyArticle(Experience exp, {required bool isLead, required ColorScheme scheme}) {
    final String firstLetter = exp.company.isNotEmpty ? exp.company[0] : '';
    final String remainingCompany = exp.company.length > 1 ? exp.company.substring(1) : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Epoch Dateline & Role
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.15),
                border: Border.all(color: scheme.primary.withValues(alpha: 0.4)),
              ),
              child: Text(
                exp.period.toUpperCase(),
                style: TextStyle(
                  color: scheme.primary,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                exp.role.toUpperCase(),
                style: TextStyle(
                  color: scheme.onSurface.withValues(alpha: 0.85),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Company Headline with giant drop cap
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DROP CAP
            Container(
              margin: const EdgeInsets.only(right: 8, top: 2),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: scheme.onSurface,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                firstLetter,
                style: TextStyle(
                  fontFamily: 'Tenada',
                  color: scheme.surface,
                  fontSize: isLead ? 36 : 28,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                ),
              ),
            ),
            Expanded(
              child: Text(
                '$remainingCompany — Operations & Execution',
                style: TextStyle(
                  fontFamily: 'Tenada',
                  color: scheme.onSurface,
                  fontSize: isLead ? 22 : 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  height: 1.15,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Highlights in broadsheet editorial paragraphs with high contrast and bold lead-ins
        ...exp.highlights.map((h) => _buildHighlightItem(h, scheme)),
      ],
    );
  }

  Widget _buildHighlightItem(String highlight, ColorScheme scheme) {
    final int colonIndex = highlight.indexOf(':');
    final bool hasColon = colonIndex != -1;

    final String prefix = hasColon ? highlight.substring(0, colonIndex + 1) : '';
    final String rest = hasColon ? highlight.substring(colonIndex + 1) : highlight;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              '§ ',
              style: TextStyle(
                color: scheme.primary,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: hasColon
                ? Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: prefix,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: scheme.onSurface,
                            fontSize: 14.5,
                            height: 1.6,
                          ),
                        ),
                        TextSpan(
                          text: rest,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: scheme.onSurface.withValues(alpha: 0.95),
                            fontSize: 14.0,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    highlight,
                    style: TextStyle(
                      color: scheme.onSurface.withValues(alpha: 0.95),
                      fontSize: 14.0,
                      height: 1.6,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPullQuote(String quote, ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: scheme.primary, width: 3.5),
          right: BorderSide(color: scheme.primary.withValues(alpha: 0.3), width: 1),
        ),
        color: scheme.primary.withValues(alpha: 0.08),
      ),
      child: Text(
        quote,
        style: TextStyle(
          color: scheme.onSurface,
          fontSize: 15.5,
          fontStyle: FontStyle.italic,
          height: 1.65,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildColumnRule(ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Container(
        width: 1,
        color: scheme.onSurface.withValues(alpha: 0.15),
      ),
    );
  }

  Widget _buildGazetteColumn(ColorScheme scheme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Education Header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: scheme.onSurface, width: 1.5)),
          ),
          child: Row(
            children: [
              Text(
                'ACADEMIA & RESEARCH',
                style: TextStyle(
                  fontFamily: 'Tenada',
                  color: scheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        ...kEducation.map(
          (edu) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
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
                const SizedBox(height: 3),
                Text(
                  '${edu.institution} · ${edu.period}',
                  style: TextStyle(
                    color: scheme.primary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (edu.note != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    edu.note!,
                    style: TextStyle(
                      color: scheme.onSurface.withValues(alpha: 0.8),
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(height: 18),

        // Certifications Header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: scheme.onSurface, width: 1.5)),
          ),
          child: Row(
            children: [
              Text(
                'OFFICIAL REGISTRY',
                style: TextStyle(
                  fontFamily: 'Tenada',
                  color: scheme.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        ...kCertifications.map(
          (cert) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('❖ ', style: TextStyle(fontSize: 11, color: Color(0xFFFBBF24))),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    cert,
                    style: TextStyle(
                      color: scheme.onSurface.withValues(alpha: 0.95),
                      fontSize: 12.5,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
