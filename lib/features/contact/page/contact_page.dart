import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:profile/theme/tokens.dart';

import 'package:profile/service/analytics_service.dart';
import 'package:profile/service/sound_service.dart';

import 'package:profile/features/contact/widget/contact_channels_grid.dart';
import 'package:profile/features/contact/widget/contact_header.dart';
import 'package:profile/features/contact/widget/contact_masthead_footer.dart';
import 'package:profile/features/contact/widget/cv_dossier_card.dart';
import 'package:profile/features/contact/widget/engagement_matrix_section.dart';
import 'package:profile/features/contact/widget/express_presets_bar.dart';
import 'package:profile/features/contact/widget/hero_email_card.dart';
import 'package:profile/features/contact/widget/inquiry_composer_dialog.dart';
import 'package:profile/features/contact/widget/telemetry_bar.dart';
import 'package:profile/shared/widget/app_toast.dart';
import 'package:profile/shared/widget/scrollable_screen_shell.dart';

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

  Future<void> _copy(BuildContext context, String value) async {
    SoundService.instance.playClick();
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;

    // Announce to screen readers for accessibility
    final announcement =
        AppLocalizations.of(context)?.copiedToClipboard(value) ??
            'Copied $value to clipboard';
    unawaited(
      SemanticsService.sendAnnouncement(
        View.of(context),
        announcement,
        Directionality.of(context),
      ),
    );

    AppToast.showGlass(
      context,
      message: AppLocalizations.of(context)?.emailCopied(value) ??
          'Copied: $value',
      status: ToastStatus.ok,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin requirement
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= AppBreakpoints.tablet;

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
          onCopyEmail: () => _copy(context, _email),
          onComposeInquiry: () => unawaited(
            showInquiryComposerDialog(context, initialTrackIndex: 0),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // 2. Fast pre-filled subject lines beneath the primary CTA.
        ExpressPresetsBar(
          onSelectPreset: (subject, body) {
            final index =
                ExpressPresetsBar.presets.indexWhere((p) => p.$2 == subject);
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
          onCopy: (value) => _copy(context, value),
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
