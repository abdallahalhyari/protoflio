import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/tokens.dart';
import '../../../service/sound_service.dart';

import '../widget/screen_shell.dart';

/// Executive-grade editorial contact dossier and consulting portal.
/// Commands trust with real-time timezone telemetry, consulting engagement matrix,
/// express one-tap email presets, direct verified communication channels,
/// and ATS-compliant CV download/preview actions.
class ContactPage extends StatefulWidget {
  final PageController controller;
  final int pageIndex;
  final bool isContinuousMobile;

  const ContactPage({
    super.key,
    required this.controller,
    required this.pageIndex,
    this.isContinuousMobile = false,
  });

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
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
        duration: const Duration(milliseconds: 2600),
        margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
        content: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
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
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
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
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= AppBreakpoints.tablet;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _issueStrip(isDark),
        const SizedBox(height: AppSpacing.md),
        _telemetryBar(isDark),
        const SizedBox(height: AppSpacing.lg),
        _headline(size, isDark),
        const SizedBox(height: AppSpacing.md),
        _lede(size, isDark),
        const SizedBox(height: AppSpacing.xl),
        _engagementMatrix(isDark, isDesktop),
        const SizedBox(height: AppSpacing.xl),
        _expressPresets(isDark),
        const SizedBox(height: AppSpacing.xl),
        _channelsDossier(context, isDesktop, isDark),
        const SizedBox(height: AppSpacing.xl),
        _cvCard(isDark),
        const SizedBox(height: AppSpacing.xl),
        _socialAndMastheadFooter(context, isDark),
      ],
    );

    return AppScreenShell(
      maxWidth: 1040,
      verticalPadding: widget.isContinuousMobile ? AppSpacing.md : AppSpacing.lg,
      reserveBottomNav: !widget.isContinuousMobile,
      reserveMobileTop: !widget.isContinuousMobile,
      child: widget.isContinuousMobile
          ? body
          : SingleChildScrollView(
              primary: false,
              physics: const ClampingScrollPhysics(),
              child: body,
            ),
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
                color: isDark ? _accentSoft : const Color(0xFF4F46E5),
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

  Widget _telemetryBar(bool isDark) {
    // Amman time (UTC+3). _now is refreshed via a 30s Timer so the pill
    // ticks live instead of freezing at first paint.
    final ammanTime = _now.toUtc().add(const Duration(hours: 3));
    final hour = ammanTime.hour;
    final minute = ammanTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final isOfficeHours = hour >= 9 && hour < 19;

    Widget pill({required Widget child, Color? border}) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color:
                  border ?? (isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
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
            border: _availabilityGreen.withValues(alpha: 0.45),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PulsingDot(color: _availabilityGreen),
                const SizedBox(width: 6),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      isOfficeHours
                          ? 'ACTIVE WORKING HOURS'
                          : 'STANDBY · ASYNC',
                      style: const TextStyle(
                        color: _availabilityGreen,
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
          pill(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 13,
                  color: isDark ? Colors.white70 : const Color(0xFF64748B),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'AMMAN $displayHour:$minute $period (UTC+3)',
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          pill(
            border: _accent.withValues(alpha: 0.4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.flight_takeoff_rounded,
                  size: 13,
                  color: isDark ? _accentSoft : const Color(0xFFD97706),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'RELOCATING BRNO 2027',
                      style: TextStyle(
                        color: isDark ? _accentSoft : const Color(0xFFD97706),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headline(Size size, bool isDark) {
    final fs = (size.width * 0.055).clamp(32.0, 68.0);
    return Text(
      "LET'S BUILD SOMETHING EXTRAORDINARY",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Tenada',
        fontSize: fs,
        fontWeight: FontWeight.w900,
        letterSpacing: 2.5,
        color: isDark ? Colors.white : const Color(0xFF0F172A),
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
                : const Color(0xFF475569),
            fontSize: (size.width * 0.014).clamp(13.5, 17.0),
            height: 1.6,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // SECTION 2: EXECUTIVE ENGAGEMENT SCOPES (BENTO MATRIX)
  // ===========================================================================

  Widget _engagementMatrix(bool isDark, bool isDesktop) {
    final tracks = [
      _ConsultingTrack(
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
      _ConsultingTrack(
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
      _ConsultingTrack(
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
                borderRadius: BorderRadius.circular(2),
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
                    color: isDark ? Colors.white70 : const Color(0xFF64748B),
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
                    child: _BentoTrackCard(track: track, isDark: isDark),
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
            : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : const Color(0xFFE2E8F0),
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
                InkWell(
                  onTap: () => _openMail(subject: p.$2, body: p.$3),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.16)
                            : const Color(0xFFCBD5E1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            p.$1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color:
                                  isDark ? Colors.white : const Color(0xFF0F172A),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 12,
                          color: isDark ? _accentSoft : const Color(0xFF6366F1),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION 4: DIRECT EXECUTIVE COMMUNICATION CHANNELS
  // ===========================================================================

  Widget _channelsDossier(
      BuildContext context, bool isDesktop, bool isDark) {
    final channels = [
      _ChannelData(
        badge: '⚡ FASTEST REPLY · WITHIN 24H',
        badgeColor: _availabilityGreen,
        label: 'DIRECT OFFICIAL EMAIL',
        value: _email,
        icon: Icons.alternate_email_rounded,
        primaryLabel: 'Send Email',
        primaryAction: () => _openMail(
          subject: '[Inquiry] Senior Mobile Engineering - Abdallah Alhyari',
        ),
        secondaryLabel: 'Copy Address',
        secondaryAction: () => _copy(context, _email, isDark: isDark),
        accent: _accent,
      ),
      _ChannelData(
        badge: '📱 DIRECT CELL & WHATSAPP',
        badgeColor: _sky,
        label: 'TELEPHONE & WHATSAPP LINE',
        value: _phone,
        icon: Icons.phone_iphone_rounded,
        primaryLabel: 'Direct Call',
        primaryAction: () => _open('tel:$_phoneRaw'),
        secondaryLabel: 'WhatsApp Chat',
        secondaryAction: () => _open(_whatsAppUrl),
        accent: _sky,
      ),
      _ChannelData(
        badge: '🌐 500+ VERIFIED NETWORK & RECS',
        badgeColor: _indigo,
        label: 'LINKEDIN EXECUTIVE PROFILE',
        value: 'in/$_linkedInHandle',
        icon: Icons.link_rounded,
        primaryLabel: 'Open Profile',
        primaryAction: () => _open(_linkedInUrl),
        secondaryLabel: 'Copy URL',
        secondaryAction: () => _copy(context, _linkedInUrl, isDark: isDark),
        accent: _indigo,
      ),
      _ChannelData(
        badge: '💻 REPOSITORIES & OSS ARCHITECTURE',
        badgeColor: _accent,
        label: 'GITHUB CODEBASE & ARTIFACTS',
        value: 'github.com/$_githubHandle',
        icon: Icons.code_rounded,
        primaryLabel: 'View GitHub',
        primaryAction: () => _open(_githubUrl),
        secondaryLabel: 'Copy URL',
        secondaryAction: () => _copy(context, _githubUrl, isDark: isDark),
        accent: _accent,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withValues(alpha: 0.55)
            : Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.14)
              : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 32,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var i = 0; i < channels.length; i++) ...[
            _ChannelCardTile(data: channels[i], isDark: isDark),
            if (i < channels.length - 1)
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : const Color(0xFFE2E8F0),
              ),
          ],
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
            ? const Color(0xFF0F172A).withValues(alpha: 0.7)
            : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isDark
              ? _accent.withValues(alpha: 0.4)
              : const Color(0xFFE2E8F0),
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
                      borderRadius: BorderRadius.circular(4),
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
                      color: isDark ? Colors.white60 : const Color(0xFF64748B),
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
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
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
                      : const Color(0xFF64748B),
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
                  SoundService.instance.playClick();
                  await launchUrl(Uri.parse('cv.pdf'),
                      mode: LaunchMode.externalApplication);
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
                  SoundService.instance.playClick();
                  await launchUrl(Uri.parse('cv.pdf'),
                      mode: LaunchMode.externalApplication);
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
                      isDark ? Colors.white : const Color(0xFF0F172A),
                  side: BorderSide(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.3)
                        : const Color(0xFFCBD5E1),
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
                : const Color(0xFFCBD5E1),
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
                    : const Color(0xFF64748B),
                fontSize: 9.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
          ],
        );

    final blocks = [
      block('PRIMARY LOCATION', 'AMMAN · RELOCATING BRNO 2027'),
      block('RESPONSE SLA', 'GUARANTEED WITHIN 24 HOURS'),
      block('ENGAGEMENT SCOPE', 'SENIOR ROLES · ADVISORY · CONTRACT'),
    ];

    return Column(
      children: [
        // Social quick-pills
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            _SocialChip(
              label: 'LINKEDIN · $_linkedInHandle',
              icon: Icons.link_rounded,
              onTap: () => _open(_linkedInUrl),
            ),
            _SocialChip(
              label: 'GITHUB · $_githubHandle',
              icon: Icons.code_rounded,
              onTap: () => _open(_githubUrl),
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
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : const Color(0xFFE2E8F0),
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
                    color: isDark ? Colors.white70 : const Color(0xFF475569),
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
                      color: isDark ? Colors.white.withValues(alpha: 0.60) : const Color(0xFF94A3B8),
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
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : const Color(0xFFE2E8F0),
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
                    : const Color(0xFFCBD5E1),
              ),
              blocks[1],
              Container(
                width: 1,
                height: 28,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.2)
                    : const Color(0xFFCBD5E1),
              ),
              blocks[2],
            ],
          ),
      ],
    );
  }
}

// =============================================================================
// SUB-WIDGETS & DATA MODELS
// =============================================================================

class _ConsultingTrack {
  final String tag;
  final String title;
  final String description;
  final IconData icon;
  final Color accent;
  final String inquirySubject;
  final ValueChanged<String> onInquire;

  const _ConsultingTrack({
    required this.tag,
    required this.title,
    required this.description,
    required this.icon,
    required this.accent,
    required this.inquirySubject,
    required this.onInquire,
  });
}

class _BentoTrackCard extends StatefulWidget {
  final _ConsultingTrack track;
  final bool isDark;

  const _BentoTrackCard({
    required this.track,
    required this.isDark,
  });

  @override
  State<_BentoTrackCard> createState() => _BentoTrackCardState();
}

class _BentoTrackCardState extends State<_BentoTrackCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.track;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: widget.isDark
              ? (_hover
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.white.withValues(alpha: 0.04))
              : (_hover ? Colors.white : const Color(0xFFF8FAFC)),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: _hover
                ? t.accent.withValues(alpha: 0.6)
                : (widget.isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : const Color(0xFFE2E8F0)),
            width: 1.2,
          ),
          boxShadow: [
            if (_hover)
              BoxShadow(
                color: t.accent.withValues(alpha: widget.isDark ? 0.15 : 0.08),
                blurRadius: 18,
                offset: const Offset(0, 6),
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
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: t.accent.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: t.accent.withValues(alpha: 0.35),
                      width: 1,
                    ),
                  ),
                  child: Icon(t.icon, size: 18, color: t.accent),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: t.accent.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        t.tag,
                        style: TextStyle(
                          color: t.accent,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              t.title,
              style: TextStyle(
                color: widget.isDark ? Colors.white : const Color(0xFF0F172A),
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              t.description,
              style: TextStyle(
                color: widget.isDark
                    ? Colors.white.withValues(alpha: 0.72)
                    : const Color(0xFF64748B),
                fontSize: 11.5,
                height: 1.45,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            InkWell(
              onTap: () => t.onInquire(t.inquirySubject),
              borderRadius: BorderRadius.circular(4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'INQUIRE TRACK',
                    style: TextStyle(
                      color: t.accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded,
                      size: 12, color: t.accent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChannelData {
  final String badge;
  final Color badgeColor;
  final String label;
  final String value;
  final IconData icon;
  final String primaryLabel;
  final VoidCallback primaryAction;
  final String secondaryLabel;
  final VoidCallback secondaryAction;
  final Color accent;

  const _ChannelData({
    required this.badge,
    required this.badgeColor,
    required this.label,
    required this.value,
    required this.icon,
    required this.primaryLabel,
    required this.primaryAction,
    required this.secondaryLabel,
    required this.secondaryAction,
    required this.accent,
  });
}

class _ChannelCardTile extends StatefulWidget {
  final _ChannelData data;
  final bool isDark;

  const _ChannelCardTile({
    required this.data,
    required this.isDark,
  });

  @override
  State<_ChannelCardTile> createState() => _ChannelCardTileState();
}

class _ChannelCardTileState extends State<_ChannelCardTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final width = MediaQuery.sizeOf(context).width;
    final narrow = width < 640;

    final icon = Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: d.accent.withValues(alpha: _hover ? 0.22 : 0.12),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: d.accent.withValues(alpha: 0.45),
          width: 1,
        ),
      ),
      child: Icon(d.icon, size: 20, color: d.accent),
    );

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 3,
          children: [
            Text(
              d.label,
              style: TextStyle(
                color: d.accent,
                fontSize: 9.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: d.badgeColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color: d.badgeColor.withValues(alpha: 0.35),
                  width: 0.8,
                ),
              ),
              child: Text(
                d.badge,
                style: TextStyle(
                  color: d.badgeColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          d.value,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            color: widget.isDark ? Colors.white : const Color(0xFF0F172A),
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );

    final primaryBtn = ElevatedButton(
      onPressed: d.primaryAction,
      style: ElevatedButton.styleFrom(
        backgroundColor: d.accent,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        elevation: 0,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          d.primaryLabel.toUpperCase(),
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );

    final secondaryBtn = OutlinedButton(
      onPressed: d.secondaryAction,
      style: OutlinedButton.styleFrom(
        foregroundColor: widget.isDark ? Colors.white : const Color(0xFF0F172A),
        side: BorderSide(
          color: widget.isDark
              ? Colors.white.withValues(alpha: 0.35)
              : const Color(0xFFCBD5E1),
          width: 1,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          d.secondaryLabel.toUpperCase(),
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: _hover ? AppSpacing.md : AppSpacing.smd,
          vertical: AppSpacing.md,
        ),
        color: _hover
            ? d.accent.withValues(alpha: 0.04)
            : Colors.transparent,
        child: narrow
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      icon,
                      const SizedBox(width: AppSpacing.md),
                      Expanded(child: details),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.smd),
                  Row(
                    children: [
                      Expanded(child: primaryBtn),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: secondaryBtn),
                    ],
                  ),
                ],
              )
            : Row(
                children: [
                  icon,
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: details),
                  const SizedBox(width: AppSpacing.md),
                  primaryBtn,
                  const SizedBox(width: AppSpacing.sm),
                  secondaryBtn,
                ],
              ),
      ),
    );
  }
}

class _SocialChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SocialChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 14),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.6,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.35)
              : const Color(0xFFCBD5E1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_c.isAnimating && !MediaQuery.of(context).disableAnimations) {
      _c.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final t = _c.value;
        return SizedBox(
          width: 14,
          height: 14,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 8 + 6 * t,
                height: 8 + 6 * t,
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.35 * (1 - t)),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
