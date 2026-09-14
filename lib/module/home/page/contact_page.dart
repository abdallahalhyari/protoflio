import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/tokens.dart';
import 'package:profile/l10n/app_localizations.dart';

import '../../../service/analytics_service.dart';
import '../../../service/cv_service.dart';
import '../../../service/sound_service.dart';

import '../widget/contact/channel_tile.dart';
import '../widget/contact/consulting_track.dart';
import '../widget/contact/social_chip.dart';
import '../widget/editorial_chip.dart';
import '../widget/pulsing_dot.dart';
import '../widget/scrollable_screen_shell.dart';

/// Executive-grade editorial contact dossier and consulting portal.
/// Commands trust with real-time timezone telemetry, consulting engagement matrix,
/// express one-tap email presets, direct verified communication channels,
/// and ATS-compliant CV download/preview actions.
class ContactPage extends StatefulWidget {
  final bool isContinuousMobile;

  const ContactPage({
    super.key,
    this.isContinuousMobile = false,
  });

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  static const _email = 'alhyariabdallh@gmail.com';
  static const _phone = '+962-787032264';
  static const _phoneRaw = '+962787032264';
  static const _whatsAppUrl = 'https://wa.me/962787032264';
  static const _linkedInUrl =
      'https://www.linkedin.com/in/abdallah-alhyari-0294791a0/';
  static const _linkedInHandle = 'abdallah-alhyari';
  static const _githubUrl = 'https://github.com/abdallahalhyari';
  static const _githubHandle = 'abdallahalhyari';

  // Backed by the shared AppColors palette so future rebrands propagate.
  static const _accent = AppColors.accentAmber; // amber / gold
  static const _accentSoft = AppColors.accentAmberSoft;
  static const _availabilityGreen = AppColors.accentGreen; // emerald
  static const _sky = AppColors.accentSky; // cyan / sky
  static const _indigo = AppColors.accentIndigo; // soft indigo

  Future<void> _open(String url) async {
    SoundService.instance.playClick();
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openMail({required String subject, String? body}) async {
    SoundService.instance.playClick();
    Analytics.ctaEmail();
    final Uri mailUri = Uri(
      scheme: 'mailto',
      path: _email,
      queryParameters: {
        'subject': subject,
        if (body != null && body.isNotEmpty) 'body': body,
      },
    );
    await launchUrl(mailUri, mode: LaunchMode.externalApplication);
  }

  Future<void> _copy(BuildContext context, String value, {bool isDark = true}) async {
    SoundService.instance.playClick();
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;

    // Announce to screen readers for accessibility
    // ignore: deprecated_member_use
    SemanticsService.announce(
      'Copied $value to clipboard',
      Directionality.of(context),
    );

    // Elevated floating glass toast
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: AppMotion.toast,
        margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
        content: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.slate900 : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(
                color: _availabilityGreen.withValues(alpha: 0.65),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_rounded,
                    color: _availabilityGreen, size: 18),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    'Copied: $value',
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.slate900,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin requirement
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= AppBreakpoints.tablet;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Redesigned flow — hero above the fold, recruiter-friendly path
    // (email + CV) prioritized, dense sections regrouped into a
    // scannable rhythm.
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _issueStrip(isDark),
        const SizedBox(height: AppSpacing.md),
        _TelemetryBar(isDark: isDark),
        const SizedBox(height: AppSpacing.xl),
        _headline(size, isDark),
        const SizedBox(height: AppSpacing.md),
        _lede(size, isDark),
        const SizedBox(height: AppSpacing.xl),
        // 1. Primary CTA — send email, right up front.
        _heroEmailCard(context, isDark, isDesktop),
        const SizedBox(height: AppSpacing.lg),
        // 2. Fast pre-filled subject lines beneath the primary CTA.
        _expressPresets(isDark),
        const SizedBox(height: AppSpacing.xl),
        // 3. Compact 2×2 channel grid (phone / whatsapp / linkedin / github).
        _channelsGrid(context, isDesktop, isDark),
        const SizedBox(height: AppSpacing.xl),
        // 4. Recruiter-priority CV download.
        _cvCard(isDark),
        const SizedBox(height: AppSpacing.xl),
        // 5. Deep dive — engagement scopes for hiring managers who want more.
        _engagementMatrix(isDark, isDesktop),
        const SizedBox(height: AppSpacing.xl),
        _socialAndMastheadFooter(context, isDark),
      ],
    );

    return ScrollableAppScreenShell(
      maxWidth: 1040,
      isContinuousMobile: widget.isContinuousMobile,
      child: body,
    );
  }

  // ===========================================================================
  // SECTION 1: HEADER & LIVE TELEMETRY
  // ===========================================================================

  Widget _issueStrip(bool isDark) {
    Widget rule() => Container(
          width: 36,
          height: 1.5,
          color: _accent.withValues(alpha: 0.75),
        );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        rule(),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'FEATURE 07 · DIRECT LINE & REACH OUT',
              style: TextStyle(
                color: isDark ? _accentSoft : AppColors.accentIndigo600,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        rule(),
      ],
    );
  }


  Widget _headline(Size size, bool isDark) {
    final fs = (size.width * 0.055).clamp(32.0, 68.0);
    return Text(
      "LET'S BUILD SOMETHING EXTRAORDINARY",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: AppTypography.displayFont,
        fontSize: fs,
        fontWeight: FontWeight.w900,
        letterSpacing: 2.5,
        color: isDark ? Colors.white : AppColors.slate900,
        height: 1.05,
        shadows: isDark
            ? const [Shadow(color: Colors.black, blurRadius: 20)]
            : const [Shadow(color: Colors.black12, blurRadius: 6)],
      ),
    );
  }

  Widget _lede(Size size, bool isDark) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Text(
          'Principal & Senior Mobile Software Architect with 6+ years delivering resilient '
          'production Flutter engines, offline-first sync protocols, and native iOS/Android bridges. '
          'Available for senior full-time leadership, architectural audits, and technical partnerships.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark
                ? Colors.white.withValues(alpha: 0.88)
                : AppColors.slate600,
            fontSize: (size.width * 0.014).clamp(13.5, 17.0),
            height: 1.6,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // HERO EMAIL CARD — primary CTA sitting right under the lede.
  // ===========================================================================

  Widget _heroEmailCard(BuildContext context, bool isDark, bool isDesktop) {
    final l10n = AppLocalizations.of(context)!;
    final ctaSend = FilledButton.icon(
      onPressed: () => _openMail(
        subject: '[Inquiry] Senior Mobile Engineering - Abdallah Alhyari',
      ),
      icon: const Icon(Icons.send_rounded, size: 16),
      label: Text(l10n.contactSendEmailBtn),
      style: FilledButton.styleFrom(
        backgroundColor: _accent,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        textStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),
    );

    final ctaCopy = OutlinedButton.icon(
      onPressed: () => _copy(context, _email, isDark: isDark),
      icon: const Icon(Icons.content_copy_rounded, size: 14),
      label: Text(l10n.contactCopyAddressBtn),
      style: OutlinedButton.styleFrom(
        foregroundColor: isDark ? Colors.white : AppColors.slate900,
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.35)
              : AppColors.slate300,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        textStyle: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),
    );

    final actionRow = Wrap(spacing: 10, runSpacing: 8, children: [ctaSend, ctaCopy]);

    final emailBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.contactHeroEyebrow,
          style: TextStyle(
            color: isDark ? _accentSoft : AppColors.accentIndigo600,
            fontSize: AppTypography.editorial,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: SelectableText(
            _email,
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.slate900,
              fontSize: isDesktop ? 22 : 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded,
                color: _availabilityGreen, size: 14),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                l10n.contactReplyWindow,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.7)
                      : AppColors.slate500,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );

    final card = Container(
      padding: EdgeInsets.all(isDesktop ? AppSpacing.lg : AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withValues(alpha: 0.5)
            : Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: _accent.withValues(alpha: isDark ? 0.45 : 0.35),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: _accent.withValues(alpha: isDark ? 0.10 : 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: emailBlock),
                const SizedBox(width: AppSpacing.lg),
                actionRow,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                emailBlock,
                const SizedBox(height: AppSpacing.md),
                actionRow,
              ],
            ),
    );

    return card;
  }

  // ===========================================================================
  // COMPACT CHANNEL GRID — phone / whatsapp / linkedin / github as 2x2 tiles.
  // ===========================================================================

  Widget _channelsGrid(BuildContext context, bool isDesktop, bool isDark) {
    final channels = [
      ChannelData(
        badge: '📱 DIRECT LINE',
        badgeColor: _sky,
        label: 'PHONE',
        value: _phone,
        icon: Icons.phone_iphone_rounded,
        primaryLabel: 'Call',
        primaryAction: () {
          Analytics.ctaPhoneCall();
          unawaited(_open('tel:$_phoneRaw'));
        },
        secondaryLabel: 'WhatsApp',
        secondaryAction: () {
          Analytics.ctaWhatsapp();
          unawaited(_open(_whatsAppUrl));
        },
        accent: _sky,
      ),
      ChannelData(
        badge: '💬 QUICK CHAT',
        badgeColor: _availabilityGreen,
        label: 'WHATSAPP',
        value: 'wa.me/962787032264',
        icon: Icons.chat_bubble_rounded,
        primaryLabel: 'Open',
        primaryAction: () {
          Analytics.ctaWhatsapp();
          unawaited(_open(_whatsAppUrl));
        },
        secondaryLabel: 'Copy',
        secondaryAction: () => _copy(context, _whatsAppUrl, isDark: isDark),
        accent: _availabilityGreen,
      ),
      ChannelData(
        badge: '🌐 500+ NETWORK',
        badgeColor: _indigo,
        label: 'LINKEDIN',
        value: 'in/$_linkedInHandle',
        icon: Icons.link_rounded,
        primaryLabel: 'Profile',
        primaryAction: () {
          Analytics.ctaLinkedIn();
          unawaited(_open(_linkedInUrl));
        },
        secondaryLabel: 'Copy',
        secondaryAction: () => _copy(context, _linkedInUrl, isDark: isDark),
        accent: _indigo,
      ),
      ChannelData(
        badge: '💻 REPOSITORIES',
        badgeColor: _accent,
        label: 'GITHUB',
        value: '@$_githubHandle',
        icon: Icons.code_rounded,
        primaryLabel: 'Visit',
        primaryAction: () {
          Analytics.ctaGithub();
          unawaited(_open(_githubUrl));
        },
        secondaryLabel: 'Copy',
        secondaryAction: () => _copy(context, _githubUrl, isDark: isDark),
        accent: _accent,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: _sky,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  '// DIRECT COMMUNICATION CHANNELS',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : AppColors.slate500,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.2,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        LayoutBuilder(
          builder: (context, constraints) {
            final tileW = isDesktop
                ? (constraints.maxWidth - AppSpacing.md) / 2
                : constraints.maxWidth;
            return Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                for (final c in channels)
                  SizedBox(
                    width: tileW,
                    child: ChannelTile(data: c, isDark: isDark),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  // ===========================================================================
  // SECTION 2: EXECUTIVE ENGAGEMENT SCOPES (BENTO MATRIX)
  // ===========================================================================

  Widget _engagementMatrix(bool isDark, bool isDesktop) {
    final tracks = [
      ConsultingTrack(
        tag: 'SYSTEM AUDIT',
        title: 'Architecture & Resilience Audit',
        description:
            'Clean Architecture restructuring, state-machine resilience, concurrency bottleneck triage, and multi-package decoupling.',
        icon: Icons.account_tree_outlined,
        accent: _sky,
        inquirySubject:
            '[Architecture Audit Inquiry] Mobile System Audit - Abdallah Alhyari',
        onInquire: (subject) => _openMail(
          subject: subject,
          body:
              'Hi Abdallah,\n\nI would like to discuss an architectural audit for our mobile codebase...',
        ),
      ),
      ConsultingTrack(
        tag: 'PRODUCTION APPS',
        title: 'Full-Lifecycle App Engineering',
        description:
            'Zero-to-one cross-platform app delivery, native iOS Swift & Android Kotlin platform channels, 120 FPS buttery rendering.',
        icon: Icons.devices_rounded,
        accent: _accent,
        inquirySubject:
            '[Engineering Inquiry] Production Mobile App - Abdallah Alhyari',
        onInquire: (subject) => _openMail(
          subject: subject,
          body:
              'Hi Abdallah,\n\nWe have an upcoming mobile application project and would love to collaborate...',
        ),
      ),
      ConsultingTrack(
        tag: 'TECH LEADERSHIP',
        title: 'Fractional Lead & Mentorship',
        description:
            'Code review governance, automated UI & integration test harnesses, mobile CI/CD pipelines, and upskilling engineering squads.',
        icon: Icons.military_tech_outlined,
        accent: _availabilityGreen,
        inquirySubject:
            '[Advisory Inquiry] Mobile Leadership & Mentorship - Abdallah Alhyari',
        onInquire: (subject) => _openMail(
          subject: subject,
          body:
              'Hi Abdallah,\n\nWe are looking for senior mobile leadership / fractional guidance for our engineering team...',
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: _accent,
                borderRadius: BorderRadius.circular(AppRadius.xxs),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  '// ENGAGEMENT SCOPES & COLLABORATION MODES',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : AppColors.slate500,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.2,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = isDesktop
                ? (constraints.maxWidth - 2 * AppSpacing.md) / 3
                : constraints.maxWidth;

            return Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                for (final track in tracks)
                  SizedBox(
                    width: cardWidth,
                    child: BentoTrackCard(track: track, isDark: isDark),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  // ===========================================================================
  // SECTION 3: FAST INQUIRY EXPRESS PRESETS
  // ===========================================================================

  Widget _expressPresets(bool isDark) {
    final presets = [
      (
        '💼 Senior Role',
        '[Role Opportunity] Senior Mobile Architect - Abdallah Alhyari',
        'Hi Abdallah,\n\nI reviewed your portfolio and would like to discuss a Senior Mobile Architect / Engineering role at our company...',
      ),
      (
        '📐 Architecture Audit',
        '[Architecture Review] Mobile Codebase Audit - Abdallah Alhyari',
        'Hi Abdallah,\n\nWe are looking for a deep architectural review of our existing mobile application...',
      ),
      (
        '⚡ Production App',
        '[App Project Inquiry] Enterprise Mobile App - Abdallah Alhyari',
        'Hi Abdallah,\n\nWe are planning to build a high-performance cross-platform application and want your expertise...',
      ),
      (
        '☕ Advisory & Chat',
        '[Connect] Tech Advisory & Coffee - Abdallah Alhyari',
        'Hi Abdallah,\n\nI’d love to connect for a 20-minute chat regarding mobile engineering and technology...',
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : AppColors.slate100,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : AppColors.slate200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bolt_rounded,
                size: 16,
                color: isDark ? _accentSoft : const Color(0xFFD97706),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ONE-TAP EXPRESS REACH-OUT PRESETS',
                    style: TextStyle(
                      color: isDark ? _accentSoft : const Color(0xFFD97706),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.8,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final p in presets)
                EditorialChip(
                  label: p.$1,
                  variant: ChipVariant.glass,
                  tone: ChipTone.primary,
                  trailing: Icon(
                    Icons.arrow_forward_rounded,
                    size: 12,
                    color: isDark ? _accentSoft : AppColors.accentIndigoDeep,
                  ),
                  onTap: () => _openMail(subject: p.$2, body: p.$3),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION 5: EXECUTIVE CV & CREDENTIALS
  // ===========================================================================

  Widget _cvCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.slate900.withValues(alpha: 0.7)
            : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isDark
              ? _accent.withValues(alpha: 0.4)
              : AppColors.slate200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _accent.withValues(alpha: isDark ? 0.06 : 0.03),
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
                      color: _accent.withValues(alpha: isDark ? 0.18 : 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                      border: Border.all(
                        color: _accent.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'ATS-VERIFIED · 2026 EDITION',
                      style: TextStyle(
                        color: isDark ? _accentSoft : const Color(0xFFD97706),
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                  Text(
                    'PDF · 240 KB',
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
                'Executive Curriculum Vitae & Portfolio Dossier',
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.slate900,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Complete chronological track record, enterprise architecture case studies, and engineering competencies.',
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
                label: const Text(
                  'DOWNLOAD CV · PDF',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.4,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
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
                label: const Text(
                  'PREVIEW',
                  style: TextStyle(
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
    );
  }

  // ===========================================================================
  // SECTION 6: SOCIAL MASTHEAD & COLOPHON
  // ===========================================================================

  Widget _socialAndMastheadFooter(BuildContext context, bool isDark) {
    final isMobile = MediaQuery.sizeOf(context).width < 640;
    Widget rule() => Expanded(
          child: Container(
            height: 1,
            color: isDark
                ? Colors.white.withValues(alpha: 0.15)
                : AppColors.slate300,
          ),
        );

    Widget block(String label, String value) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.72)
                    : AppColors.slate500,
                fontSize: 9.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.slate900,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
          ],
        );

    final blocks = [
      block('PRIMARY LOCATION', 'AMMAN · RELOCATING BRNO 2027'),
      block('EU WORK STATUS', 'ELIGIBLE / NO PERMIT REQ.'),
      block('RESPONSE SLA', 'GUARANTEED WITHIN 24 HOURS'),
      block('ENGAGEMENT SCOPE', 'SENIOR ROLES · ADVISORY'),
    ];

    return Column(
      children: [
        // Social quick-pills
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            SocialChip(
              label: 'LINKEDIN · $_linkedInHandle',
              icon: Icons.link_rounded,
              onTap: () => unawaited(_open(_linkedInUrl)),
            ),
            SocialChip(
              label: 'GITHUB · $_githubHandle',
              icon: Icons.code_rounded,
              onTap: () => unawaited(_open(_githubUrl)),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        // Trust and identity badge
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : AppColors.slate100,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : AppColors.slate200,
                width: 1,
              ),
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              spacing: 6,
              runSpacing: 4,
              children: [
                const Icon(Icons.shield_outlined,
                    size: 13, color: _availabilityGreen),
                Text(
                  'VERIFIED SENIOR MOBILE ARCHITECT · DIRECT COMMUNICATION',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : AppColors.slate600,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Masthead Colophon Rule
        Row(
          children: [
            rule(),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '// COLOPHON & DISPATCH',
                    style: TextStyle(
                      color: isDark ? Colors.white.withValues(alpha: 0.60) : AppColors.slate400,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
            rule(),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (isMobile)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 8,
            children: [
              for (final b in blocks)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.04)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : AppColors.slate200,
                    ),
                  ),
                  child: b,
                ),
            ],
          )
        else
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.sm,
            children: [
              blocks[0],
              Container(
                width: 1,
                height: 28,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.2)
                    : AppColors.slate300,
              ),
              blocks[1],
              Container(
                width: 1,
                height: 28,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.2)
                    : AppColors.slate300,
              ),
              blocks[2],
              Container(
                width: 1,
                height: 28,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.2)
                    : AppColors.slate300,
              ),
              blocks[3],
            ],
          ),
      ],
    );
  }
}

class _TelemetryBar extends StatefulWidget {
  final bool isDark;
  const _TelemetryBar({required this.isDark});

  @override
  State<_TelemetryBar> createState() => _TelemetryBarState();
}

class _TelemetryBarState extends State<_TelemetryBar> {
  Timer? _clockTimer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Amman time (UTC+3). _now is refreshed via a 30s Timer so the pill
    // ticks live instead of freezing at first paint, without rebuilding ContactPage.
    final ammanTime = _now.toUtc().add(const Duration(hours: 3));
    final hour = ammanTime.hour;
    final minute = ammanTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final isOfficeHours = hour >= 9 && hour < 19;
    final isDark = widget.isDark;

    Widget pill({required Widget child, Color? border}) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color:
                  border ?? (isDark ? Colors.white12 : AppColors.slate200),
              width: 1,
            ),
          ),
          child: child,
        );

    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: [
          pill(
            border: AppColors.accentGreen.withValues(alpha: 0.45),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const PulsingDot(color: AppColors.accentGreen),
                const SizedBox(width: 6),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      isOfficeHours
                          ? 'ACTIVE WORKING HOURS'
                          : 'STANDBY · ASYNC',
                      style: const TextStyle(
                        color: AppColors.accentGreen,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          EditorialChip(
            label: 'AMMAN $displayHour:$minute $period (UTC+3)',
            icon: Icons.access_time_rounded,
            variant: ChipVariant.glass,
          ),
          const EditorialChip(
            label: 'RELOCATING BRNO 2027',
            icon: Icons.flight_takeoff_rounded,
            variant: ChipVariant.filled,
            tone: ChipTone.amber,
          ),
        ],
      ),
    );
  }
}
