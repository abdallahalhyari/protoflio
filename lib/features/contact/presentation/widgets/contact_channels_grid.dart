import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/shared/utils/grid_math.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/core/services/analytics_service.dart';
import 'package:profile/features/contact/presentation/widgets/channel_tile.dart';

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

  static const _indicatorColor = AppColors.teal;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = context.isDarkMode;

    final channels = [
      ChannelData(
        label: l10n.contactPhone,
        value: phone,
        icon: Icons.phone_iphone_rounded,
        primaryLabel: l10n.contactCall,
        primaryAction: () {
          Analytics.ctaPhoneCall();
          onOpenUrl('tel:$phoneRaw');
        },
        // Copy, like every other card: a WhatsApp button here duplicated
        // the WhatsApp card beside it.
        secondaryLabel: l10n.contactCopy,
        secondaryAction: () => onCopy(phoneRaw),
        accent: AppColors.gold,
      ),
      ChannelData(
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
        accent: AppColors.tealLight,
      ),
      ChannelData(
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
        accent: AppColors.linkedIn,
      ),
      ChannelData(
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
        accent: isDark ? AppColors.ink300 : AppColors.ink800,
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
                color: _indicatorColor,
                borderRadius: BorderRadius.circular(AppRadius.xxs),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Direct communication channels',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : AppColors.ink500,
                    fontSize: AppTypography.label,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        LayoutBuilder(
          builder: (context, constraints) {
            final tileW = columnWidth(
                constraints.maxWidth, isDesktop ? 2 : 1, AppSpacing.md);
            if (tileW <= 0) return const SizedBox.shrink();
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
