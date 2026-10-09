import 'package:flutter/material.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/about/presentation/about_navigation.dart';
import 'package:profile/features/about/presentation/widgets/about_card.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/utils/bidi.dart';
import 'package:profile/shared/utils/career_facts.dart';
import 'package:profile/shared/widgets/editorial_chip.dart';
import 'package:profile/shared/widgets/pulsing_dot.dart';
import 'package:profile/shared/widgets/retrying_asset_image.dart';

/// Executive engineering profile: identity hero, impact metrics,
/// technical ethos, credential spec sheet, and under-the-hood capabilities bento grid.
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key, required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final sections = <Widget>[
      _ExecutiveIdentityHero(isDesktop: isDesktop),
      _StoryAndDossierSection(isDesktop: isDesktop),
      _UnderTheHoodSection(isDesktop: isDesktop),
      _TechArsenalSection(isDesktop: isDesktop),
      _PlaygroundCalloutBanner(isDesktop: isDesktop),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < sections.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.xxl),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 400 + (i * 120).clamp(0, 500)),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 24 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: sections[i],
          ),
        ],
      ],
    );
  }
}

/// 1. Executive Identity Hero & Core Impact Metrics
class _ExecutiveIdentityHero extends StatelessWidget {
  const _ExecutiveIdentityHero({required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;

    final avatar = Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: isDesktop ? 98 : 82,
          height: isDesktop ? 98 : 82,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                accent,
                isDark ? AppColors.tealLight : AppColors.tealDeep,
                AppColors.gold,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: isDark ? 0.38 : 0.22),
                blurRadius: 24,
                offset: const Offset(0, 6),
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.all(3.0),
          child: ClipOval(
            child: ColoredBox(
              color: isDark ? AppColors.darkCard : Colors.white,
              child: const RetryingAssetImage(
                'assets/my_image.webp',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? AppColors.tealLight : AppColors.tealDeep,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.verified_rounded,
              size: 16,
              color: isDark ? AppColors.tealLight : AppColors.tealDeep,
            ),
          ),
        ),
      ],
    );

    final titleBlock = Column(
      crossAxisAlignment:
          isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width - 48,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: isDesktop
                ? AlignmentDirectional.centerStart
                : AlignmentDirectional.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Abdallah Alhyari',
                  style: TextStyle(
                    fontFamily: AppTypography.displayFont,
                    fontSize: isDesktop
                        ? AppTypography.heading - 2
                        : AppTypography.title + 2,
                    fontWeight: FontWeight.w900,
                    color: context.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: isDark ? 0.18 : 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                    border: Border.all(
                      color: accent.withValues(alpha: isDark ? 0.45 : 0.35),
                    ),
                  ),
                  child: Text(
                    'STAFF / LEAD',
                    style: TextStyle(
                      fontFamily: AppTypography.monoFont,
                      fontSize: AppTypography.label,
                      fontWeight: FontWeight.w800,
                      color: context.adaptiveAccentText(accent),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Senior Mobile Systems Engineer · Mobile Solutions Architect',
            textAlign: isDesktop ? TextAlign.start : TextAlign.center,
            style: TextStyle(
              fontSize: isDesktop
                  ? AppTypography.lead - 1
                  : AppTypography.cardBody,
              fontWeight: FontWeight.w700,
              color: context.adaptiveAccentText(accent),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 6,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: AppColors.tealLight.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PulsingDot(color: AppColors.tealLight),
                    const SizedBox(width: 6),
                    Text(
                      'Available for Senior Roles',
                      style: TextStyle(
                        fontFamily: AppTypography.monoFont,
                        color: context.greenText,
                        fontSize: AppTypography.label,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: EditorialChip(
                label: 'Amman, JO / Brno, CZ',
                icon: Icons.flight_takeoff_rounded,
                variant: ChipVariant.glass,
              ),
            ),
          ],
        ),
      ],
    );

    final stats = [
      (
        '${CareerFacts.yearsOfExperience()}+',
        'Years Experience',
        'Enterprise mobile systems',
        Icons.history_rounded,
      ),
      (
        '10+',
        'Production Apps',
        'Healthcare, ERP & FinTech',
        Icons.rocket_launch_rounded,
      ),
      (
        '100k+',
        'Active Users',
        'Reliable daily workflows',
        Icons.groups_rounded,
      ),
      (
        '99.9%',
        'Offline SLA',
        'Zero-data-loss architecture',
        Icons.offline_pin_rounded,
      ),
    ];

    final metricsRow = LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth > 700 ? 4 : 2;
        final itemWidth =
            (constraints.maxWidth - ((cols - 1) * AppSpacing.md)) / cols;

        return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            for (final s in stats)
              SizedBox(
                width: itemWidth,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.03)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : AppColors.ink200,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: isDark ? 0.12 : 0.08),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border: Border.all(
                            color: accent.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Icon(s.$4,
                            size: 18,
                            color: context.adaptiveAccentText(accent)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                s.$1,
                                style: TextStyle(
                                  fontFamily: AppTypography.displayFont,
                                  fontSize: AppTypography.heading,
                                  fontWeight: FontWeight.w900,
                                  color: context.onSurface,
                                  height: 1.1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              s.$2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: AppTypography.label,
                                fontWeight: FontWeight.w800,
                                color: context.mutedText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );

    return Container(
      padding: EdgeInsets.all(isDesktop ? AppSpacing.xl : AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.cardGlass,
        borderRadius: BorderRadius.circular(AppRadius.container),
        gradient: isDark
            ? RadialGradient(
                center: Alignment.topLeft,
                radius: 2.0,
                colors: [
                  accent.withValues(alpha: 0.12),
                  context.cardGlass,
                ],
              )
            : null,
        border: Border.all(
          color: isDark
              ? accent.withValues(alpha: 0.3)
              : context.glassBorderStrong,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black38 : AppColors.shadowSoft,
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isDesktop)
            Row(
              children: [
                avatar,
                const SizedBox(width: AppSpacing.lg),
                Expanded(child: titleBlock),
              ],
            )
          else
            Column(
              children: [
                avatar,
                const SizedBox(height: AppSpacing.md),
                titleBlock,
              ],
            ),
          const SizedBox(height: AppSpacing.xl),
          metricsRow,
        ],
      ),
    );
  }
}



/// 2. Engineering Narrative & Technical Factsheet Dossier
class _StoryAndDossierSection extends StatelessWidget {
  const _StoryAndDossierSection({required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = context.isDarkMode;
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;
    final rule = context.glassBorderStrong;

    Widget row(String label, Widget value, {bool first = false}) {
      return DecoratedBox(
        decoration: BoxDecoration(
          border: first ? null : Border(top: BorderSide(color: rule)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 108,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: AppTypography.body,
                    height: 1.4,
                    color: context.mutedText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(child: value),
            ],
          ),
        ),
      );
    }

    Widget factText(String value) => Text(
          value,
          style: TextStyle(
            fontSize: AppTypography.body,
            height: 1.45,
            fontWeight: FontWeight.w600,
            color: context.onSurface,
          ),
        );

    final dossierCard = AboutCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Icon(Icons.badge_rounded,
                  size: 16, color: context.adaptiveAccentText(accent)),
              Text(
                'EXECUTIVE CREDENTIAL DOSSIER',
                style: TextStyle(
                  fontFamily: AppTypography.monoFont,
                  fontSize: AppTypography.label,
                  fontWeight: FontWeight.w900,
                  color: context.adaptiveAccentText(accent),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          row(l10n.aboutEngineerLabel, factText(l10n.aboutEngineerValue),
              first: true),
          row(
            l10n.aboutExperienceLabel,
            factText(
                l10n.aboutExperienceValue(CareerFacts.yearsOfExperience())),
          ),
          row(l10n.aboutFocusLabel, factText(l10n.aboutFocusValue)),
          row(l10n.heroFactLanguagesLabel,
              factText(l10n.heroFactLanguagesValue)),
          row(l10n.heroFactStudyLabel, factText(l10n.heroFactStudyValue)),
        ],
      ),
    );

    final pillars = [
      (
        Icons.layers_rounded,
        'UI to Silicon',
        'From high-performance Flutter declarative UI down to platform channels, C++, JNI, and native Kotlin/Swift.'
      ),
      (
        Icons.security_rounded,
        'Hardware-Bound Security',
        'ISO-7816 APDU transceiving, AES-256 GCM encryption, biometric hardware keys, and Keystore derivation.'
      ),
      (
        Icons.cloud_sync_rounded,
        'Resilient Offline Pipelines',
        'Zero-network tolerance with SQLite/Isar local transactional queues, WorkManager sync, and conflict resolution.'
      ),
      (
        Icons.architecture_rounded,
        'Clean Modular Architecture',
        'Decoupling monolithic codebases into modular, testable feature packages with deterministic state machines.'
      ),
    ];

    final narrativeCard = Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.cardGlass,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: context.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Icon(Icons.format_quote_rounded,
                  size: 20, color: context.adaptiveAccentText(accent)),
              Text(
                'ENGINEERING PHILOSOPHY & ETHOS',
                style: TextStyle(
                  fontFamily: AppTypography.monoFont,
                  fontSize: AppTypography.label,
                  fontWeight: FontWeight.w900,
                  color: context.adaptiveAccentText(accent),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            ltrContent(context, l10n.aboutStoryShort),
            style: TextStyle(
              fontSize: AppTypography.lead,
              height: 1.65,
              fontWeight: FontWeight.w500,
              color: context.onSurface.withValues(alpha: 0.95),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            height: 1,
            color: context.divider,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'CORE VALUE PILLARS',
            style: TextStyle(
              fontFamily: AppTypography.monoFont,
              fontSize: AppTypography.label,
              fontWeight: FontWeight.w800,
              color: context.mutedText,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final p in pillars) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: isDark ? 0.15 : 0.08),
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                    ),
                    child: Icon(p.$1,
                        size: 14, color: context.adaptiveAccentText(accent)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${p.$2} — ',
                            style: TextStyle(
                              fontSize: AppTypography.label,
                              fontWeight: FontWeight.w800,
                              color: context.onSurface,
                            ),
                          ),
                          TextSpan(
                            text: p.$3,
                            style: TextStyle(
                              fontSize: AppTypography.label,
                              height: 1.45,
                              color: context.mutedText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );

    if (!isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          narrativeCard,
          const SizedBox(height: AppSpacing.lg),
          dossierCard,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 6, child: narrativeCard),
        const SizedBox(width: AppSpacing.xl),
        Expanded(flex: 5, child: dossierCard),
      ],
    );
  }
}

/// 3. Under-The-Hood Interactive Capabilities Bento Grid
class _UnderTheHoodSection extends StatelessWidget {
  const _UnderTheHoodSection({required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;

    final capabilities = [
      (
        icon: Icons.contactless_rounded,
        title: l10n.hoodNfcTitle,
        tag: l10n.hoodNfcTag,
        detail: l10n.hoodNfcDetail,
        where: l10n.hoodNfcWhere,
        accent: AppColors.teal,
        hasDemo: true,
      ),
      (
        icon: Icons.security_rounded,
        title: l10n.hoodCryptoTitle,
        tag: l10n.hoodCryptoTag,
        detail: l10n.hoodCryptoDetail,
        where: l10n.hoodCryptoWhere,
        accent: AppColors.gold,
        hasDemo: true,
      ),
      (
        icon: Icons.cloud_sync_rounded,
        title: l10n.hoodOfflineTitle,
        tag: l10n.hoodOfflineTag,
        detail: l10n.hoodOfflineDetail,
        where: l10n.hoodOfflineWhere,
        accent: AppColors.tealLight,
        hasDemo: true,
      ),
      (
        icon: Icons.integration_instructions_rounded,
        title: l10n.hoodNativeTitle,
        tag: l10n.hoodNativeTag,
        detail: l10n.hoodNativeDetail,
        where: l10n.hoodNativeWhere,
        accent: AppColors.teal,
        hasDemo: true,
      ),
      (
        icon: Icons.bolt_rounded,
        title: l10n.hoodBackgroundTitle,
        tag: l10n.hoodBackgroundTag,
        detail: l10n.hoodBackgroundDetail,
        where: l10n.hoodBackgroundWhere,
        accent: AppColors.goldSoft,
        hasDemo: false,
      ),
      (
        icon: Icons.hub_rounded,
        title: l10n.hoodEnterpriseTitle,
        tag: l10n.hoodEnterpriseTag,
        detail: l10n.hoodEnterpriseDetail,
        where: l10n.hoodEnterpriseWhere,
        accent: AppColors.tealDeep,
        hasDemo: false,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(AppRadius.xxs),
              ),
            ),
            Text(
              'UNDER THE HOOD CAPABILITIES',
              style: TextStyle(
                fontFamily: AppTypography.monoFont,
                fontSize: AppTypography.label,
                fontWeight: FontWeight.w900,
                color: context.adaptiveAccentText(accent),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          l10n.aboutHoodHint,
          style: TextStyle(
            fontSize: AppTypography.label,
            color: context.mutedText,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            final cols = constraints.maxWidth > 850 ? 2 : 1;
            final itemWidth =
                (constraints.maxWidth - ((cols - 1) * AppSpacing.md)) / cols;

            return Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                for (final c in capabilities)
                  SizedBox(
                    width: itemWidth,
                    child: _CapabilityCard(
                      icon: c.icon,
                      title: c.title,
                      tag: c.tag,
                      detail: c.detail,
                      where: c.where,
                      accent: c.accent,
                      hasDemo: c.hasDemo,
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _CapabilityCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String tag;
  final String detail;
  final String where;
  final Color accent;
  final bool hasDemo;

  const _CapabilityCard({
    required this.icon,
    required this.title,
    required this.tag,
    required this.detail,
    required this.where,
    required this.accent,
    required this.hasDemo,
  });

  @override
  State<_CapabilityCard> createState() => _CapabilityCardState();
}

class _CapabilityCardState extends State<_CapabilityCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final accentText = context.adaptiveAccentText(widget.accent);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover ? 1.015 : 1.0,
        duration: AppMotion.cardHover,
        curve: AppMotion.emphasized,
        child: AnimatedContainer(
          duration: AppMotion.cardHover,
          curve: AppMotion.emphasized,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark
                ? (_hover
                    ? Colors.white.withValues(alpha: 0.07)
                    : Colors.white.withValues(alpha: 0.03))
                : (_hover ? Colors.white : AppColors.ink50),
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: _hover
                  ? widget.accent.withValues(alpha: isDark ? 0.75 : 0.6)
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : AppColors.ink200),
              width: _hover ? 1.4 : 1.0,
            ),
            boxShadow: [
              if (_hover)
                BoxShadow(
                  color: widget.accent.withValues(alpha: isDark ? 0.22 : 0.10),
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                  spreadRadius: 1,
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          widget.accent.withValues(alpha: isDark ? 0.16 : 0.10),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(
                        color: widget.accent.withValues(alpha: isDark ? 0.45 : 0.35),
                      ),
                    ),
                    child: Icon(widget.icon, size: 20, color: accentText),
                  ),
                  Flexible(
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : AppColors.ink100,
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : AppColors.ink200,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.business_rounded,
                              size: 11, color: context.mutedText),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              widget.where,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: AppTypography.monoFont,
                                fontSize: AppTypography.label,
                                fontWeight: FontWeight.w700,
                                color: context.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                widget.title,
                style: TextStyle(
                  fontFamily: AppTypography.displayFont,
                  fontSize: AppTypography.lead,
                  fontWeight: FontWeight.w900,
                  color: context.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.tag,
                style: TextStyle(
                  fontFamily: AppTypography.monoFont,
                  fontSize: AppTypography.label,
                  fontWeight: FontWeight.w800,
                  color: accentText,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.detail,
                style: TextStyle(
                  fontSize: AppTypography.label,
                  height: 1.5,
                  color: context.mutedText,
                ),
              ),
              if (widget.hasDemo) ...[
                const SizedBox(height: AppSpacing.md),
                InkWell(
                  onTap: () {
                    SoundService.instance.playClick();
                    aboutTabRequest.value = AboutTabs.playground;
                  },
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Test in Playground',
                            style: TextStyle(
                              fontFamily: AppTypography.monoFont,
                              fontSize: AppTypography.label,
                              fontWeight: FontWeight.w900,
                              color: accentText,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(width: 6),
                          AnimatedPadding(
                            duration: AppMotion.cardHover,
                            curve: AppMotion.emphasized,
                            padding: EdgeInsets.only(left: _hover ? 6.0 : 0.0),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 13,
                              color: accentText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}


/// 4. Technical Arsenal & Skills Domain Matrix
class _TechArsenalSection extends StatelessWidget {
  const _TechArsenalSection({required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;
    final isDark = context.isDarkMode;

    final categories = [
      (
        'MOBILE & PLATFORMS',
        [
          'Flutter',
          'Dart',
          'Android SDK (Kotlin/Java)',
          'iOS UIKit (Swift)',
          'Platform Channels',
          'C++ / JNI'
        ],
        Icons.smartphone_rounded,
      ),
      (
        'ARCHITECTURE & STATE',
        [
          'Clean Architecture',
          'BLoC / Cubit',
          'Riverpod',
          'Domain-Driven Design',
          'Event Streams',
          'TDD'
        ],
        Icons.account_tree_rounded,
      ),
      (
        'HARDWARE & SECURITY',
        [
          'ISO-7816 APDU',
          'AES-256 GCM',
          'PBKDF2',
          'Android KeyStore',
          'iOS Keychain',
          'Biometrics',
          'JWT'
        ],
        Icons.lock_rounded,
      ),
      (
        'DATA & INFRASTRUCTURE',
        [
          'SQLite / Drift',
          'Isar Local DB',
          'WorkManager Sync',
          'RabbitMQ Messaging',
          'gRPC / REST',
          'GitHub CI/CD'
        ],
        Icons.storage_rounded,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(AppRadius.xxs),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                'TECHNICAL ARSENAL & TOOLCHAIN MATRIX',
                style: TextStyle(
                  fontFamily: AppTypography.monoFont,
                  fontSize: AppTypography.label,
                  fontWeight: FontWeight.w900,
                  color: context.adaptiveAccentText(accent),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Technologies and engineering paradigms proven in production enterprise systems.',
          style: TextStyle(
            fontSize: AppTypography.label,
            color: context.mutedText,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            final cols = constraints.maxWidth > 850 ? 2 : 1;
            final itemWidth =
                (constraints.maxWidth - ((cols - 1) * AppSpacing.md)) / cols;

            return Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                for (final cat in categories)
                  SizedBox(
                    width: itemWidth,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.025)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.07)
                              : AppColors.ink200,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Icon(cat.$3,
                                  size: 16,
                                  color: context.adaptiveAccentText(accent)),
                              Text(
                                cat.$1,
                                style: TextStyle(
                                  fontFamily: AppTypography.monoFont,
                                  fontSize: AppTypography.label,
                                  fontWeight: FontWeight.w900,
                                  color: context.onSurface,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              for (final skill in cat.$2)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 9, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.04)
                                        : AppColors.ink100,
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.chip),
                                    border: Border.all(
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.08)
                                          : AppColors.ink200,
                                    ),
                                  ),
                                  child: Text(
                                    skill,
                                    style: TextStyle(
                                      fontSize: AppTypography.label,
                                      fontWeight: FontWeight.w700,
                                      color: context.onSurface,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// 5. Direct Interactive Playground Invitation Callout Banner
class _PlaygroundCalloutBanner extends StatelessWidget {
  const _PlaygroundCalloutBanner({required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.all(isDesktop ? AppSpacing.xl : AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.ink50,
        borderRadius: BorderRadius.circular(AppRadius.container),
        gradient: LinearGradient(
          colors: [
            accent.withValues(alpha: isDark ? 0.18 : 0.08),
            isDark ? AppColors.darkCard : Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: accent.withValues(alpha: isDark ? 0.45 : 0.3),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: isDark ? 0.12 : 0.05),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: 1,
          ),
        ],
      ),
      child: isDesktop
          ? Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: accent
                                    .withValues(alpha: isDark ? 0.16 : 0.10),
                                borderRadius:
                                    BorderRadius.circular(AppRadius.xs),
                                border: Border.all(
                                  color: accent
                                      .withValues(alpha: isDark ? 0.4 : 0.25),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.terminal_rounded,
                                      size: 14,
                                      color: context.adaptiveAccentText(accent)),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      'LIVE ENGINEERING PLAYGROUND',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: AppTypography.monoFont,
                                        fontSize: AppTypography.label,
                                        fontWeight: FontWeight.w900,
                                        color: context.adaptiveAccentText(accent),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Run cryptography and smart-card simulations directly in your browser.',
                        style: TextStyle(
                          fontFamily: AppTypography.displayFont,
                          fontSize: AppTypography.lead,
                          fontWeight: FontWeight.w900,
                          color: context.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Test PBKDF2 key derivation, AES-GCM encryption/decryption, ISO-7816 APDU transceiving, and offline sync pipelines.',
                        style: TextStyle(
                          fontSize: AppTypography.label,
                          color: context.mutedText,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xl),
                FilledButton.icon(
                  onPressed: () {
                    SoundService.instance.playClick();
                    aboutTabRequest.value = AboutTabs.playground;
                  },
                  icon: const Icon(Icons.play_arrow_rounded, size: 18),
                  label: const Text('Open Playground'),
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: scheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    textStyle: const TextStyle(
                      fontSize: AppTypography.label,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color:
                              accent.withValues(alpha: isDark ? 0.16 : 0.10),
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                          border: Border.all(
                            color:
                                accent.withValues(alpha: isDark ? 0.4 : 0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.terminal_rounded,
                                size: 14,
                                color: context.adaptiveAccentText(accent)),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'LIVE ENGINEERING PLAYGROUND',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: AppTypography.monoFont,
                                  fontSize: AppTypography.label,
                                  fontWeight: FontWeight.w900,
                                  color: context.adaptiveAccentText(accent),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Run cryptography and smart-card simulations directly in your browser.',
                  style: TextStyle(
                    fontFamily: AppTypography.displayFont,
                    fontSize: AppTypography.body,
                    fontWeight: FontWeight.w900,
                    color: context.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Test PBKDF2, AES-GCM encryption, ISO-7816 APDUs, and offline sync live.',
                  style: TextStyle(
                    fontSize: AppTypography.label,
                    color: context.mutedText,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton.icon(
                  onPressed: () {
                    SoundService.instance.playClick();
                    aboutTabRequest.value = AboutTabs.playground;
                  },
                  icon: const Icon(Icons.play_arrow_rounded, size: 16),
                  label: const Text('Open Playground'),
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: scheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    textStyle: const TextStyle(
                      fontSize: AppTypography.label,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

