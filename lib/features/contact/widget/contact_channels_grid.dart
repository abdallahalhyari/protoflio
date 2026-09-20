import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/service/analytics_service.dart';
import 'channel_tile.dart';

/// 2x2 responsive communication channel tiles (Phone, WhatsApp, LinkedIn, GitHub).
class ContactChannelsGrid extends StatelessWidget {
  final String phone;
  final String phoneRaw;
  final String whatsAppUrl;
  final String linkedInHandle;
  final String linkedInUrl;
  final String githubHandle;
  final String githubUrl;
  final bool isDesktop;
  final void Function(String url) onOpenUrl;
  final void Function(String value) onCopy;

  const ContactChannelsGrid({
    super.key,
    required this.phone,
    required this.phoneRaw,
    required this.whatsAppUrl,
    required this.linkedInHandle,
    required this.linkedInUrl,
    required this.githubHandle,
    required this.githubUrl,
    required this.isDesktop,
    required this.onOpenUrl,
    required this.onCopy,
  });

  static const _sky = AppColors.accentSky;
  static const _availabilityGreen = AppColors.accentGreenLight;
  static const _indigo = AppColors.accentIndigo;
  static const _accent = AppColors.accentViolet;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = context.isDarkMode;

    final channels = [
      ChannelData(
        badge: '📱 DIRECT LINE',
        badgeColor: _sky,
        label: l10n.contactPhone,
        value: phone,
        icon: Icons.phone_iphone_rounded,
        primaryLabel: l10n.contactCall,
        primaryAction: () {
          Analytics.ctaPhoneCall();
          onOpenUrl('tel:$phoneRaw');
        },
        secondaryLabel: l10n.contactWhatsapp,
        secondaryAction: () {
          Analytics.ctaWhatsapp();
          onOpenUrl(whatsAppUrl);
        },
        accent: _sky,
      ),
      ChannelData(
        badge: '💬 QUICK CHAT',
        badgeColor: _availabilityGreen,
        label: l10n.contactWhatsapp,
        value: 'wa.me/962787032264',
        icon: Icons.chat_bubble_rounded,
        primaryLabel: l10n.contactOpen,
        primaryAction: () {
          Analytics.ctaWhatsapp();
          onOpenUrl(whatsAppUrl);
        },
        secondaryLabel: l10n.contactCopy,
        secondaryAction: () => onCopy(whatsAppUrl),
        accent: _availabilityGreen,
      ),
      ChannelData(
        badge: '🌐 500+ NETWORK',
        badgeColor: _indigo,
        label: l10n.contactLinkedin,
        value: 'in/$linkedInHandle',
        icon: Icons.link_rounded,
        primaryLabel: l10n.contactProfile,
        primaryAction: () {
          Analytics.ctaLinkedIn();
          onOpenUrl(linkedInUrl);
        },
        secondaryLabel: l10n.contactCopy,
        secondaryAction: () => onCopy(linkedInUrl),
        accent: _indigo,
      ),
      ChannelData(
        badge: '💻 REPOSITORIES',
        badgeColor: _accent,
        label: l10n.contactGithub,
        value: '@$githubHandle',
        icon: Icons.code_rounded,
        primaryLabel: l10n.contactVisit,
        primaryAction: () {
          Analytics.ctaGithub();
          onOpenUrl(githubUrl);
        },
        secondaryLabel: l10n.contactCopy,
        secondaryAction: () => onCopy(githubUrl),
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
                borderRadius: BorderRadius.circular(AppRadius.xxs),
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
                    fontSize: AppTypography.caption,
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
                    child: ChannelTile(data: c),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
