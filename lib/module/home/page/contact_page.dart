import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/surface_tone.dart';
import '../../../theme/tokens.dart';

import '../../../service/analytics_service.dart';
import '../../../service/sound_service.dart';

import '../widget/contact/contact_channels_grid.dart';
import '../widget/contact/contact_header.dart';
import '../widget/contact/contact_masthead_footer.dart';
import '../widget/contact/cv_dossier_card.dart';
import '../widget/contact/engagement_matrix_section.dart';
import '../widget/contact/express_presets_bar.dart';
import '../widget/contact/hero_email_card.dart';
import '../widget/contact/inquiry_composer_dialog.dart';
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

  static const _availabilityGreen = AppColors.accentGreen;

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

  Future<void> _copy(BuildContext context, String value,
      {bool isDark = true}) async {
    SoundService.instance.playClick();
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;

    // Announce to screen readers for accessibility
    final announcement = AppLocalizations.of(context)?.copiedToClipboard(value) ??
        'Copied $value to clipboard';
    unawaited(
      SemanticsService.sendAnnouncement(
        View.of(context),
        announcement,
        Directionality.of(context),
      ),
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
                color: (isDark ? _availabilityGreen : AppColors.accentGreenDeep).withValues(alpha: 0.65),
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
                Icon(Icons.check_circle_rounded,
                    color: isDark ? _availabilityGreen : AppColors.accentGreenDeep, size: 18),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)?.emailCopied(value) ??
                        'Copied: $value',
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.slate900,
                      fontSize: AppTypography.overlineTight,
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
    final isDark = context.isDarkMode;

    // Redesigned flow — hero above the fold, recruiter-friendly path
    // (email + CV) prioritized, dense sections regrouped into a
    // scannable rhythm.
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const ContactHeader(),
        const SizedBox(height: AppSpacing.md),
        const TelemetryBar(),
        const SizedBox(height: AppSpacing.xl),
        // 1. Primary CTA — send email, right up front.
        HeroEmailCard(
          email: _email,
          isDesktop: isDesktop,
          onSendEmail: () => _openMail(
            subject: '[Inquiry] Senior Mobile Engineering - Abdallah Alhyari',
          ),
          onCopyEmail: () => _copy(context, _email, isDark: isDark),
          onComposeInquiry: () => unawaited(
            showInquiryComposerDialog(context, initialTrackIndex: 0),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // 2. Fast pre-filled subject lines beneath the primary CTA.
        ExpressPresetsBar(
          onSelectPreset: (subject, body) {
            final index = ExpressPresetsBar.presets
                .indexWhere((p) => p.$2 == subject);
            unawaited(
              showInquiryComposerDialog(
                context,
                initialTrackIndex: index >= 0 ? index : 0,
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.xl),
        // 3. Compact 2×2 channel grid (phone / whatsapp / linkedin / github).
        ContactChannelsGrid(
          phone: _phone,
          phoneRaw: _phoneRaw,
          whatsAppUrl: _whatsAppUrl,
          linkedInHandle: _linkedInHandle,
          linkedInUrl: _linkedInUrl,
          githubHandle: _githubHandle,
          githubUrl: _githubUrl,
          isDesktop: isDesktop,
          onOpenUrl: (url) => unawaited(_open(url)),
          onCopy: (value) => _copy(context, value, isDark: isDark),
        ),
        const SizedBox(height: AppSpacing.xl),
        // 4. Recruiter-priority CV download.
        const CvDossierCard(),
        const SizedBox(height: AppSpacing.xl),
        // 5. Deep dive — engagement scopes for hiring managers who want more.
        EngagementMatrixSection(
          isDesktop: isDesktop,
          onInquire: (subject, body) {
            int trackIndex = 1;
            if (subject.contains('Audit')) {
              trackIndex = 1;
            } else if (subject.contains('Production') ||
                subject.contains('Engineering')) {
              trackIndex = 2;
            } else if (subject.contains('Leadership') ||
                subject.contains('Advisory')) {
              trackIndex = 3;
            }
            unawaited(
              showInquiryComposerDialog(
                context,
                initialTrackIndex: trackIndex,
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.xl),
        ContactMastheadFooter(
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
}
