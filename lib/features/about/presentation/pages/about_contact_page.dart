import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:profile/core/config/profile_links.dart';
import 'package:profile/core/services/analytics_service.dart';
import 'package:profile/core/services/cv_service.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/about/presentation/about_navigation.dart';
import 'package:profile/features/about/presentation/widgets/credential_sheet.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/utils/mailto.dart';
import 'package:profile/shared/widgets/app_toast.dart';
import 'package:profile/shared/widgets/page_activity.dart';
import 'package:profile/shared/widgets/screen_shell.dart';
import 'package:profile/shared/widgets/scrollable_screen_shell.dart';
import 'package:profile/shared/widgets/section_masthead.dart';
import 'package:url_launcher/url_launcher.dart';

/// About & contact: the reverse of the site's credential. One sheet with the
/// ways to reach the holder first, then who they are, then the card's
/// machine-readable zone.
class AboutContactPage extends StatefulWidget {
  final bool isContinuousMobile;
  final int? initialTab;

  const AboutContactPage({
    super.key,
    this.isContinuousMobile = false,
    this.initialTab,
  });

  @override
  State<AboutContactPage> createState() => _AboutContactPageState();
}

class _AboutContactPageState extends State<AboutContactPage>
    with AutomaticKeepAliveClientMixin, ActivePageFocusMixin {
  final FocusNode _focusNode = FocusNode(debugLabel: 'AboutContactFocus');

  @override
  FocusNode get pageFocusNode => _focusNode;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _open(String url) async {
    SoundService.instance.playClick();
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  Future<void> _openMail() async {
    SoundService.instance.playClick();
    Analytics.ctaEmail();
    final mailUri = mailtoUri(
      ProfileLinks.email,
      subject: '[Inquiry] Senior Mobile Engineering - Abdallah Alhyari',
    );
    await launchUrl(mailUri, mode: LaunchMode.externalApplication);
  }

  Future<void> _copyEmail(BuildContext context) async {
    const value = ProfileLinks.email;
    SoundService.instance.playClick();
    await Clipboard.setData(const ClipboardData(text: value));
    if (!context.mounted) return;

    final l10n = AppLocalizations.of(context);
    unawaited(
      SemanticsService.sendAnnouncement(
        View.of(context),
        l10n?.copiedToClipboard(value) ?? 'Copied $value to clipboard',
        Directionality.of(context),
      ),
    );
    AppToast.showGlass(
      context,
      message: l10n?.emailCopied(value) ?? 'Copied: $value',
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final isDesktop = AppBreakpoints.isDesktop(context);

    // The phone column lists About and Contact as separate sections, both
    // backed by this page; give each its half of the sheet instead of the
    // whole sheet twice. The desktop pager shows it once, in full.
    final part = !widget.isContinuousMobile
        ? CredentialSheetPart.full
        : switch (widget.initialTab) {
            AboutTabs.contact => CredentialSheetPart.reach,
            AboutTabs.profile => CredentialSheetPart.holder,
            _ => CredentialSheetPart.full,
          };

    return Focus(
      focusNode: _focusNode,
      child: ScrollableAppScreenShell(
        maxWidth: kSectionMaxWidth,
        isContinuousMobile: widget.isContinuousMobile,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // The reach half opens on its own question, under the
            // section divider that already names it.
            if (part != CredentialSheetPart.reach) ...[
              // Desktop shows both halves under the nav's own name; the
              // phone column's About section is the holder half alone.
              SectionMasthead(
                title: part == CredentialSheetPart.full
                    ? aboutAndContactLabel(l10n)
                    : l10n.aboutTitle,
                subtitle: l10n.aboutHeaderSubtitle,
                isDesktop: isDesktop,
              ),
              const SizedBox(height: AppSpacing.sectionContent),
            ],
            CredentialSheet(
              part: part,
              isDesktop: isDesktop,
              onSendEmail: () => unawaited(_openMail()),
              onCopyEmail: () => unawaited(_copyEmail(context)),
              onOpenUrl: (url) => unawaited(_open(url)),
              onOpenCv: () => unawaited(CvService.open(context)),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
