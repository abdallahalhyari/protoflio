import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:profile/core/services/analytics_service.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/contact/presentation/widgets/contact_channels_grid.dart';
import 'package:profile/features/contact/presentation/widgets/contact_header.dart';
import 'package:profile/features/contact/presentation/widgets/contact_masthead_footer.dart';
import 'package:profile/features/contact/presentation/widgets/cv_dossier_card.dart';
import 'package:profile/features/contact/presentation/widgets/engagement_matrix_section.dart';
import 'package:profile/features/contact/presentation/widgets/express_presets_bar.dart';
import 'package:profile/features/contact/presentation/widgets/hero_email_card.dart';
import 'package:profile/features/contact/presentation/widgets/inquiry_composer_dialog.dart';
import 'package:profile/features/contact/presentation/widgets/telemetry_bar.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/utils/mailto.dart';
import 'package:profile/shared/widgets/app_toast.dart';
import 'package:url_launcher/url_launcher.dart';

/// Cybernetic Executive Outreach & Direct Dispatch Portal.
/// Renders direct communication lines, timezone telemetry, direct email hero card,
/// express presets, consulting engagement matrix, and ATS CV dossier card.
class ContactPortal extends StatelessWidget {
  const ContactPortal({super.key, required this.isDesktop});

  final bool isDesktop;

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
    final mailUri = mailtoUri(_email, subject: subject, body: body);
    await launchUrl(mailUri, mode: LaunchMode.externalApplication);
  }

  Future<void> _copy(BuildContext context, String value) async {
    SoundService.instance.playClick();
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;

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
      message:
          AppLocalizations.of(context)?.emailCopied(value) ?? 'Copied: $value',
    );
  }

  @override
  Widget build(BuildContext context) {
    final header = const ContactHeader();
    final telemetry = const TelemetryBar();

    final heroEmail = HeroEmailCard(
      email: _email,
      isDesktop: isDesktop,
      onSendEmail: () => _openMail(
        subject: '[Inquiry] Senior Mobile Engineering - Abdallah Alhyari',
      ),
      onCopyEmail: () => _copy(context, _email),
      onComposeInquiry: () {
        SoundService.instance.playClick();
        unawaited(showInquiryComposerDialog(context));
      },
    );

    final presets = ExpressPresetsBar(
      onSelectPreset: (subject, body) {
        SoundService.instance.playClick();
        final index =
            ExpressPresetsBar.presets.indexWhere((p) => p.$2 == subject);
        unawaited(
          showInquiryComposerDialog(
            context,
            initialTrackIndex: index >= 0 ? index : 0,
          ),
        );
      },
    );

    final channels = ContactChannelsGrid(
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
    );

    final cvDossier = const CvDossierCard();

    final engagementMatrix = EngagementMatrixSection(
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
    );

    final footer = const ContactMastheadFooter();

    Widget animate(Widget child, int delayIndex) {
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: AppMotion.pageTurn,
        curve: Curves.easeOutCubic,
        builder: (context, value, animChild) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: animChild,
            ),
          );
        },
        child: child,
      );
    }

    if (!isDesktop) {
      final mobileItems = [
        header,
        telemetry,
        heroEmail,
        presets,
        channels,
        cvDossier,
        engagementMatrix,
        footer,
      ];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < mobileItems.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.lg),
            animate(mobileItems[i], i),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        animate(header, 0),
        const SizedBox(height: AppSpacing.md),
        animate(telemetry, 1),
        const SizedBox(height: AppSpacing.xl),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  animate(heroEmail, 2),
                  const SizedBox(height: AppSpacing.md),
                  animate(presets, 3),
                  const SizedBox(height: AppSpacing.xl),
                  animate(channels, 4),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xl),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  animate(cvDossier, 3),
                  const SizedBox(height: AppSpacing.xl),
                  animate(engagementMatrix, 4),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        animate(footer, 6),
      ],
    );
  }
}
