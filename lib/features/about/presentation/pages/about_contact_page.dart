import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:profile/core/services/analytics_service.dart';
import 'package:profile/core/services/cv_service.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/contact/presentation/widgets/contact_header.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/utils/career_facts.dart';
import 'package:profile/shared/utils/mailto.dart';
import 'package:profile/shared/widgets/app_toast.dart';
import 'package:profile/shared/widgets/editorial_chip.dart';
import 'package:profile/shared/widgets/page_activity.dart';
import 'package:profile/shared/widgets/pulsing_dot.dart';
import 'package:profile/shared/widgets/retrying_asset_image.dart';
import 'package:profile/shared/widgets/screen_shell.dart';
import 'package:profile/shared/widgets/scrollable_screen_shell.dart';
import 'package:profile/shared/widgets/section_masthead.dart';
import 'package:url_launcher/url_launcher.dart';

/// Minimalist, high-impact Executive About & Direct Contact Page.
/// Rebuilt to provide maximum clarity and scannability: direct contact,
/// executive bio, core impact metrics, and resume download in one clean view.
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
    _focusNode.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final isDesktop = AppBreakpoints.isDesktop(context);
    final isDark = context.isDarkMode;
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;

    return Focus(
      focusNode: _focusNode,
      child: ScrollableAppScreenShell(
        maxWidth: kSectionMaxWidth,
        isContinuousMobile: widget.isContinuousMobile,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section Masthead
            SectionMasthead(
              kicker: '06 · EXECUTIVE ABOUT & DIRECT OUTREACH',
              title: l10n.aboutTitle,
              subtitle:
                  'Senior Mobile Systems Engineer & Mobile Solutions Architect.',
              isDesktop: isDesktop,
            ),
            const SizedBox(height: AppSpacing.md),

            // Contact Headline Header
            const ContactHeader(),
            const SizedBox(height: AppSpacing.lg),

            // Direct Email & Action Hero Card
            _buildEmailHeroCard(context, isDesktop, isDark, accent, l10n),
            const SizedBox(height: AppSpacing.xl),

            // Executive Bio Card
            _buildExecutiveBioCard(context, isDesktop, isDark, accent, l10n),
            const SizedBox(height: AppSpacing.xl),

            // Direct Channels Grid (Phone, WhatsApp, LinkedIn, GitHub)
            _buildChannelsGrid(context, isDesktop, isDark, accent, l10n),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildExecutiveBioCard(
    BuildContext context,
    bool isDesktop,
    bool isDark,
    Color accent,
    AppLocalizations l10n,
  ) {
    final avatar = Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: isDesktop ? 96 : 80,
          height: isDesktop ? 96 : 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                accent,
                isDark ? AppColors.tealLight : AppColors.tealDeep,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: isDark ? 0.35 : 0.2),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(2.5),
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
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? AppColors.tealLight : AppColors.tealDeep,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.verified_rounded,
              size: 14,
              color: isDark ? AppColors.tealLight : AppColors.tealDeep,
            ),
          ),
        ),
      ],
    );

    final details = Column(
      crossAxisAlignment:
          isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: (MediaQuery.sizeOf(context).width - 48)
                .clamp(0.0, double.infinity),
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
                    fontSize: isDesktop ? 26 : 22,
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
                      color: accent.withValues(alpha: isDark ? 0.4 : 0.3),
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
        Text(
          'Senior Mobile Systems Engineer · Mobile Solutions Architect',
          textAlign: isDesktop ? TextAlign.start : TextAlign.center,
          style: TextStyle(
            fontSize: isDesktop ? AppTypography.body : AppTypography.label,
            fontWeight: FontWeight.w700,
            color: context.adaptiveAccentText(accent),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '11+ years architecting production Flutter & native Android systems across healthcare, HIS/LMS, and telematics. Specializing in NFC smart-card APDU protocols, zero-loss offline sync, and zero-trust JWT security.',
          textAlign: isDesktop ? TextAlign.start : TextAlign.center,
          style: TextStyle(
            fontSize: AppTypography.body,
            height: 1.5,
            color: context.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
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
                label: 'Amman, JO ➔ Brno, CZ',
                icon: Icons.flight_takeoff_rounded,
                variant: ChipVariant.glass,
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: EditorialChip(
                label: 'Work Permit Exempt in CZ',
                icon: Icons.verified_user_rounded,
                variant: ChipVariant.glass,
              ),
            ),
          ],
        ),
      ],
    );

    final stats = [
      ('${CareerFacts.yearsOfExperience()}+', 'Years Experience'),
      ('10+', 'Production Apps'),
      ('100k+', 'Active Users'),
      ('99.9%', 'Offline SLA'),
    ];

    return Container(
      padding: EdgeInsets.all(isDesktop ? AppSpacing.xl : AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.cardGlass,
        borderRadius: BorderRadius.circular(AppRadius.container),
        border: Border.all(color: context.glassBorderStrong),
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
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    avatar,
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(child: details),
                  ],
                )
              : Column(
                  children: [
                    avatar,
                    const SizedBox(height: AppSpacing.md),
                    details,
                  ],
                ),
          const SizedBox(height: AppSpacing.lg),
          Container(height: 1, color: context.divider),
          const SizedBox(height: AppSpacing.md),

          // Stat Pills
          Wrap(
            alignment: WrapAlignment.spaceAround,
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              for (final s in stats)
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.03)
                          : AppColors.ink100,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : AppColors.ink200,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          s.$1,
                          style: TextStyle(
                            fontFamily: AppTypography.displayFont,
                            fontSize: AppTypography.body,
                            fontWeight: FontWeight.w900,
                            color: context.adaptiveAccentText(accent),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          s.$2,
                          style: TextStyle(
                            fontSize: AppTypography.label,
                            fontWeight: FontWeight.w700,
                            color: context.mutedText,
                          ),
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

  Widget _buildEmailHeroCard(
    BuildContext context,
    bool isDesktop,
    bool isDark,
    Color accent,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? AppSpacing.xl : AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.cardGlass,
        borderRadius: BorderRadius.circular(AppRadius.container),
        gradient: LinearGradient(
          colors: [
            accent.withValues(alpha: isDark ? 0.16 : 0.08),
            isDark ? AppColors.darkCard : Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: accent.withValues(alpha: isDark ? 0.5 : 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: isDark ? 0.15 : 0.08),
            blurRadius: 32,
            offset: const Offset(0, 12),
            spreadRadius: 2,
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = isDesktop && constraints.maxWidth > 650;
          if (isWide) {
            return Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: accent,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'DIRECT EXECUTIVE EMAIL',
                            style: TextStyle(
                              fontFamily: AppTypography.monoFont,
                              fontSize: AppTypography.label,
                              fontWeight: FontWeight.w900,
                              color: context.adaptiveAccentText(accent),
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerStart,
                        child: SelectableText(
                          _email,
                          style: TextStyle(
                            fontSize: AppTypography.heading,
                            fontWeight: FontWeight.w900,
                            color: context.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Direct response within 24 hours.',
                        style: TextStyle(
                          fontSize: AppTypography.label,
                          color: context.mutedText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xl),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      onPressed: () => _openMail(
                        subject:
                            '[Inquiry] Senior Mobile Engineering - Abdallah Alhyari',
                      ),
                      icon: const Icon(Icons.send_rounded, size: 16),
                      label: Text(l10n.contactSendEmailBtn),
                      style: FilledButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        textStyle: const TextStyle(
                          fontSize: AppTypography.label,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _copy(context, _email),
                      icon: const Icon(Icons.content_copy_rounded, size: 14),
                      label: Text(l10n.contactCopyAddressBtn),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.onSurface,
                        side: BorderSide(
                          color: isDark
                              ? Colors.white.withValues(alpha: AppAlpha.border)
                              : AppColors.ink300,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        textStyle: const TextStyle(
                          fontSize: AppTypography.label,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => CvService.open(context),
                      icon: const Icon(Icons.download_rounded, size: 16),
                      label: const Text('Resume (PDF)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isDark ? AppColors.darkSurface : AppColors.ink100,
                        foregroundColor: context.onSurface,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
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
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'DIRECT EXECUTIVE EMAIL',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppTypography.monoFont,
                        fontSize: AppTypography.label,
                        fontWeight: FontWeight.w900,
                        color: context.adaptiveAccentText(accent),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: SelectableText(
                  _email,
                  style: TextStyle(
                    fontSize: AppTypography.title,
                    fontWeight: FontWeight.w900,
                    color: context.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: () => _openMail(
                      subject:
                          '[Inquiry] Senior Mobile Engineering - Abdallah Alhyari',
                    ),
                    icon: const Icon(Icons.send_rounded, size: 16),
                    label: Text(l10n.contactSendEmailBtn),
                    style: FilledButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      textStyle: const TextStyle(
                        fontSize: AppTypography.label,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _copy(context, _email),
                    icon: const Icon(Icons.content_copy_rounded, size: 14),
                    label: Text(l10n.contactCopyAddressBtn),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.onSurface,
                      side: BorderSide(
                        color: isDark
                            ? Colors.white.withValues(alpha: AppAlpha.border)
                            : AppColors.ink300,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      textStyle: const TextStyle(
                        fontSize: AppTypography.label,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => CvService.open(context),
                    icon: const Icon(Icons.download_rounded, size: 16),
                    label: const Text('Resume (PDF)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDark ? AppColors.darkSurface : AppColors.ink100,
                      foregroundColor: context.onSurface,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
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
            ],
          );
        },
      ),
    );
  }

  Widget _buildChannelsGrid(
    BuildContext context,
    bool isDesktop,
    bool isDark,
    Color accent,
    AppLocalizations l10n,
  ) {
    final channels = [
      (
        title: 'LinkedIn',
        handle: _linkedInHandle,
        icon: Icons.business_rounded,
        url: _linkedInUrl,
        isExternal: true,
      ),
      (
        title: 'GitHub',
        handle: _githubHandle,
        icon: Icons.code_rounded,
        url: _githubUrl,
        isExternal: true,
      ),
      (
        title: 'WhatsApp',
        handle: _phone,
        icon: Icons.chat_rounded,
        url: _whatsAppUrl,
        isExternal: true,
      ),
      (
        title: 'Direct Call',
        handle: _phone,
        icon: Icons.phone_rounded,
        url: 'tel:$_phoneRaw',
        isExternal: false,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = isDesktop ? 4 : (constraints.maxWidth > 550 ? 2 : 1);
        final itemWidth =
            ((constraints.maxWidth - ((cols - 1) * AppSpacing.md)) / cols)
                .clamp(0.0, double.infinity);

        return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            for (final ch in channels)
              SizedBox(
                width: itemWidth,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: context.cardGlass,
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    border: Border.all(color: context.glassBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: isDark ? 0.15 : 0.08),
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                        ),
                        child: Icon(ch.icon,
                            size: 18,
                            color: context.adaptiveAccentText(accent)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                ch.title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: AppTypography.label,
                                  fontWeight: FontWeight.w800,
                                  color: context.mutedText,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                ch.handle,
                                style: TextStyle(
                                  fontSize: AppTypography.label,
                                  fontWeight: FontWeight.w900,
                                  color: context.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_outward_rounded, size: 16),
                        color: context.adaptiveAccentText(accent),
                        onPressed: () => unawaited(_open(ch.url)),
                        tooltip: 'Open ${ch.title}',
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
