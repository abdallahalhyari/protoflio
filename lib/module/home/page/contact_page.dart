import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/tokens.dart';
import 'package:profile/l10n/app_localizations.dart';

import '../../../service/analytics_service.dart';
import '../../../service/sound_service.dart';

import '../widget/contact/channel_tile.dart';
import '../widget/contact/consulting_track.dart';
import '../widget/contact/contact_masthead_footer.dart';
import '../widget/contact/cv_dossier_card.dart';
import '../widget/contact/express_presets_bar.dart';
import '../widget/contact/hero_email_card.dart';
import '../widget/contact/telemetry_bar.dart';
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

  Color get _accent => Theme.of(context).colorScheme.primary;
  Color get _accentSoft => Theme.of(context).colorScheme.primary.withValues(alpha: 0.35);
  static const _availabilityGreen = AppColors.accentGreen; // emerald
  Color get _sky => _accent; // dynamically follow theme
  Color get _indigo => _accent; // dynamically follow theme

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
    final l10n = AppLocalizations.of(context)!;
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
        TelemetryBar(isDark: isDark),
        const SizedBox(height: AppSpacing.xl),
        _headline(size, isDark),
        const SizedBox(height: AppSpacing.md),
        _lede(size, isDark),
        const SizedBox(height: AppSpacing.xl),
        // 1. Primary CTA — send email, right up front.
        HeroEmailCard(
          email: _email,
          isDark: isDark,
          isDesktop: isDesktop,
          onSendEmail: () => _openMail(
            subject: '[Inquiry] Senior Mobile Engineering - Abdallah Alhyari',
          ),
          onCopyEmail: () => _copy(context, _email, isDark: isDark),
        ),
        const SizedBox(height: AppSpacing.lg),
        // 2. Fast pre-filled subject lines beneath the primary CTA.
        ExpressPresetsBar(
          isDark: isDark,
          onSelectPreset: (subject, body) => _openMail(subject: subject, body: body),
        ),
        const SizedBox(height: AppSpacing.xl),
        // 3. Compact 2×2 channel grid (phone / whatsapp / linkedin / github).
        _channelsGrid(context, l10n, isDesktop, isDark),
        const SizedBox(height: AppSpacing.xl),
        // 4. Recruiter-priority CV download.
        CvDossierCard(isDark: isDark),
        const SizedBox(height: AppSpacing.xl),
        // 5. Deep dive — engagement scopes for hiring managers who want more.
        _engagementMatrix(l10n, isDark, isDesktop),
        const SizedBox(height: AppSpacing.xl),
        ContactMastheadFooter(
          isDark: isDark,
          linkedInHandle: _linkedInHandle,
          githubHandle: _githubHandle,
          onOpenLinkedIn: () => unawaited(_open(_linkedInUrl)),
          onOpenGithub: () => unawaited(_open(_githubUrl)),
        ),
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
                color: isDark ? _accentSoft : _accent,
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
  // COMPACT CHANNEL GRID — phone / whatsapp / linkedin / github as 2x2 tiles.
  // ===========================================================================

  Widget _channelsGrid(BuildContext context, AppLocalizations l10n, bool isDesktop, bool isDark) {
    final channels = [
      ChannelData(
        badge: '📱 DIRECT LINE',
        badgeColor: _sky,
        label: AppLocalizations.of(context)!.contactPhone,
        value: _phone,
        icon: Icons.phone_iphone_rounded,
        primaryLabel: AppLocalizations.of(context)!.contactCall,
        primaryAction: () {
          Analytics.ctaPhoneCall();
          unawaited(_open('tel:$_phoneRaw'));
        },
        secondaryLabel: AppLocalizations.of(context)!.contactWhatsapp,
        secondaryAction: () {
          Analytics.ctaWhatsapp();
          unawaited(_open(_whatsAppUrl));
        },
        accent: _sky,
      ),
      ChannelData(
        badge: '💬 QUICK CHAT',
        badgeColor: _availabilityGreen,
        label: AppLocalizations.of(context)!.contactWhatsapp,
        value: 'wa.me/962787032264',
        icon: Icons.chat_bubble_rounded,
        primaryLabel: AppLocalizations.of(context)!.contactOpen,
        primaryAction: () {
          Analytics.ctaWhatsapp();
          unawaited(_open(_whatsAppUrl));
        },
        secondaryLabel: AppLocalizations.of(context)!.contactCopy,
        secondaryAction: () => _copy(context, _whatsAppUrl, isDark: isDark),
        accent: _availabilityGreen,
      ),
      ChannelData(
        badge: '🌐 500+ NETWORK',
        badgeColor: _indigo,
        label: AppLocalizations.of(context)!.contactLinkedin,
        value: 'in/$_linkedInHandle',
        icon: Icons.link_rounded,
        primaryLabel: AppLocalizations.of(context)!.contactProfile,
        primaryAction: () {
          Analytics.ctaLinkedIn();
          unawaited(_open(_linkedInUrl));
        },
        secondaryLabel: AppLocalizations.of(context)!.contactCopy,
        secondaryAction: () => _copy(context, _linkedInUrl, isDark: isDark),
        accent: _indigo,
      ),
      ChannelData(
        badge: '💻 REPOSITORIES',
        badgeColor: _accent,
        label: AppLocalizations.of(context)!.contactGithub,
        value: '@$_githubHandle',
        icon: Icons.code_rounded,
        primaryLabel: AppLocalizations.of(context)!.contactVisit,
        primaryAction: () {
          Analytics.ctaGithub();
          unawaited(_open(_githubUrl));
        },
        secondaryLabel: AppLocalizations.of(context)!.contactCopy,
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

  Widget _engagementMatrix(AppLocalizations l10n, bool isDark, bool isDesktop) {
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

    return RepaintBoundary(
      child: Column(
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
                    AppLocalizations.of(context)!.contactEngagementScopes,
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
      ),
    );
  }



}
