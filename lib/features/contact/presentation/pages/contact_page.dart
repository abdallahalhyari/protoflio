import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:profile/core/services/analytics_service.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/about/presentation/about_navigation.dart';
import 'package:profile/features/about/presentation/widgets/aes_demo.dart';
import 'package:profile/features/about/presentation/widgets/apdu_demo.dart';
import 'package:profile/features/about/presentation/widgets/channel_demo.dart';
import 'package:profile/features/about/presentation/widgets/key_derivation_demo.dart';
import 'package:profile/features/about/presentation/widgets/offline_sync_demo.dart';
import 'package:profile/features/about/presentation/widgets/profile_tab.dart';
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
import 'package:profile/shared/widgets/page_activity.dart';
import 'package:profile/shared/widgets/screen_shell.dart';
import 'package:profile/shared/widgets/scrollable_screen_shell.dart';
import 'package:profile/shared/widgets/section_masthead.dart';
import 'package:profile/shared/widgets/text_tabs.dart';
import 'package:url_launcher/url_launcher.dart';

/// Unified Executive About & Direct Reach Out Dossier.
/// Merges Executive Profile & Credentials, Live Interactive Playground Demos,
/// and direct consulting engagement options into an integrated 3-tab experience.
class ContactPage extends StatefulWidget {
  final bool isContinuousMobile;
  final int? initialTab;

  const ContactPage({
    super.key,
    this.isContinuousMobile = false,
    this.initialTab,
  });

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage>
    with AutomaticKeepAliveClientMixin, ActivePageFocusMixin {
  final FocusNode _focusNode = FocusNode(debugLabel: 'ContactFocus');

  late int _tab;

  @override
  FocusNode get pageFocusNode => _focusNode;

  @override
  void initState() {
    super.initState();
    _tab = widget.initialTab ?? AboutTabs.contact;
    aboutTabRequest.addListener(_consumeRequest);
    WidgetsBinding.instance.addPostFrameCallback((_) => _consumeRequest());
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final k = event.logicalKey;
    if (k == LogicalKeyboardKey.arrowRight) {
      setState(() => _tab = (_tab + 1) % 3);
      return KeyEventResult.handled;
    } else if (k == LogicalKeyboardKey.arrowLeft) {
      setState(() => _tab = (_tab - 1 + 3) % 3);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

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

  @override
  void dispose() {
    aboutTabRequest.removeListener(_consumeRequest);
    _focusNode.dispose();
    super.dispose();
  }

  void _consumeRequest() {
    final requested = aboutTabRequest.value;
    if (requested == null || !mounted) return;
    aboutTabRequest.value = null;
    setState(() => _tab = requested.clamp(0, 2));
  }

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

  Widget _buildContactPortal(bool isDesktop) {
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
                  animate(cvDossier, 2),
                  const SizedBox(height: AppSpacing.xl),
                  animate(engagementMatrix, 3),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        animate(footer, 5),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final isDesktop = AppBreakpoints.isDesktop(context);
    final gold = context.isDarkMode ? AppColors.goldSoft : AppColors.goldDeep;

    if (widget.isContinuousMobile) {
      return Focus(
        focusNode: _focusNode,
        child: ScrollableAppScreenShell(
          isContinuousMobile: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildContactPortal(false),
              const SizedBox(height: AppSpacing.xxl),
              ProfileTab(isDesktop: false),
              const SizedBox(height: AppSpacing.xxl),
              const _PlaygroundGrid(),
            ],
          ),
        ),
      );
    }

    final tabs = <String>[
      l10n.aboutTabProfile,
      l10n.aboutTabPlayground,
      'Get In Touch',
    ];

    final Widget body = switch (_tab) {
      AboutTabs.profile => ProfileTab(isDesktop: isDesktop),
      AboutTabs.playground => const _PlaygroundGrid(),
      _ => _buildContactPortal(isDesktop),
    };

    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _onKey,
      child: ScrollableAppScreenShell(
        maxWidth: kSectionMaxWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionMasthead(
              title: l10n.aboutTitle,
              subtitle: _tab == AboutTabs.contact
                  ? l10n.contactHeaderSubtitle
                  : l10n.aboutSubtitle,
              isDesktop: isDesktop,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextTabs(
              labels: tabs,
              selected: _tab,
              accent: gold,
              onSelect: (i) => setState(() => _tab = i),
            ),
            const SizedBox(height: AppSpacing.md),
            AnimatedSwitcher(
              duration: AppMotion.switcher,
              child: ConstrainedBox(
                key: ValueKey(_tab),
                constraints: const BoxConstraints(minHeight: 460),
                child: body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The five interactive demos: two columns on wide screens, one column otherwise.
class _PlaygroundGrid extends StatelessWidget {
  const _PlaygroundGrid();

  @override
  Widget build(BuildContext context) {
    const gap = AppSpacing.lg;
    final demos = <Widget>[
      const ChannelDemo(),
      const ApduDemo(),
      const KeyDerivationDemo(),
      const AesDemo(),
      const OfflineSyncDemo(),
    ];
    return LayoutBuilder(builder: (context, c) {
      final cols = c.maxWidth >= 900 ? 2 : 1;
      final columns = [
        for (var i = 0; i < cols; i++)
          [for (var j = i; j < demos.length; j += cols) (j, demos[j])],
      ];
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < columns.length; i++) ...[
            if (i > 0) const SizedBox(width: gap),
            Expanded(
              child: Column(
                children: [
                  for (var j = 0; j < columns[i].length; j++) ...[
                    if (j > 0) const SizedBox(height: gap),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: Duration(
                          milliseconds:
                              500 + (columns[i][j].$1 * 100).clamp(0, 500)),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: columns[i][j].$2,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      );
    });
  }
}
