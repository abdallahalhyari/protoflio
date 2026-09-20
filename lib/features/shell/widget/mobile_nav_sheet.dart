import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/service/cv_service.dart';
import 'package:profile/service/sound_service.dart';
import 'package:profile/service/url_sync_service.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/shared/widget/conditional_blur.dart';
import 'package:profile/shared/widget/directional_icon.dart';

class NavSectionItem {
  final int index;
  final String number;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;

  const NavSectionItem({
    required this.index,
    required this.number,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
  });
}

class MobileNavSheet extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onSelectSection;
  final VoidCallback onDownloadResume;

  const MobileNavSheet({
    super.key,
    required this.activeIndex,
    required this.onSelectSection,
    required this.onDownloadResume,
  });

  /// Resolves localized section titles and subtitles based on the current [BuildContext].
  static List<NavSectionItem> getSections(BuildContext context) {
    final l = AppLocalizations.of(context);
    return [
      NavSectionItem(
        index: 0,
        number: '01',
        title: l?.navSectionCover ?? 'COVER & PROFILE',
        subtitle: l?.navSubCover ?? 'Senior Flutter & Android Architect',
        icon: Icons.home_rounded,
        accentColor: AppColors.seed,
      ),
      NavSectionItem(
        index: 1,
        number: '02',
        title: l?.navSectionExperience ?? 'CAREER & EXPERIENCE',
        subtitle:
            l?.navSubExperience ?? '4+ Years Enterprise Engineering & Impact',
        icon: Icons.timeline_rounded,
        accentColor: AppColors.accentGreen,
      ),
      NavSectionItem(
        index: 2,
        number: '03',
        title: l?.navSectionWork ?? 'FEATURED WORK',
        subtitle: l?.navSubWork ?? 'Production Systems & Case Studies',
        icon: Icons.rocket_launch_rounded,
        accentColor: AppColors.accentViolet,
      ),
      NavSectionItem(
        index: 3,
        number: '04',
        title: l?.navSectionStack ?? 'SKILLS & STACK',
        subtitle: l?.navSubStack ?? 'Technical Proficiency Matrix',
        icon: Icons.code_rounded,
        accentColor: AppColors.accentAmber,
      ),
      NavSectionItem(
        index: 4,
        number: '05',
        title: l?.navSectionEngineering ?? 'SYSTEM ARCHITECTURES',
        subtitle:
            l?.navSubEngineering ?? 'Enterprise Blueprints & Offline-First',
        icon: Icons.hub_rounded,
        accentColor: AppColors.accentRose,
      ),
      NavSectionItem(
        index: 5,
        number: '06',
        title: l?.navSectionAbout ?? 'LEADERSHIP PERSPECTIVES',
        subtitle: l?.navSubAbout ?? 'Architectural Perspectives & Hats',
        icon: Icons.style_rounded,
        accentColor: AppColors.accentCyan,
      ),
      NavSectionItem(
        index: 6,
        number: '07',
        title: l?.navSectionContact ?? 'CONTACT & INQUIRIES',
        subtitle: l?.navSubContact ?? 'Direct Channels & Availability',
        icon: Icons.mail_rounded,
        accentColor: AppColors.accentIndigoDeep,
      ),
    ];
  }

  static const List<NavSectionItem> sections = [
    NavSectionItem(
      index: 0,
      number: '01',
      title: 'COVER & PROFILE',
      subtitle: 'Senior Flutter & Android Architect',
      icon: Icons.home_rounded,
      accentColor: AppColors.seed,
    ),
    NavSectionItem(
      index: 1,
      number: '02',
      title: 'CAREER & EXPERIENCE',
      subtitle: '4+ Years Enterprise Engineering & Impact',
      icon: Icons.timeline_rounded,
      accentColor: AppColors.accentGreen,
    ),
    NavSectionItem(
      index: 2,
      number: '03',
      title: 'FEATURED WORK',
      subtitle: 'Production Systems & Case Studies',
      icon: Icons.rocket_launch_rounded,
      accentColor: AppColors.accentViolet,
    ),
    NavSectionItem(
      index: 3,
      number: '04',
      title: 'SKILLS & STACK',
      subtitle: 'Technical Proficiency Matrix',
      icon: Icons.code_rounded,
      accentColor: AppColors.accentAmber,
    ),
    NavSectionItem(
      index: 4,
      number: '05',
      title: 'SYSTEM ARCHITECTURES',
      subtitle: 'Enterprise Blueprints & Offline-First',
      icon: Icons.hub_rounded,
      accentColor: AppColors.accentRose,
    ),
    NavSectionItem(
      index: 5,
      number: '06',
      title: 'LEADERSHIP PERSPECTIVES',
      subtitle: 'Architectural Perspectives & Hats',
      icon: Icons.style_rounded,
      accentColor: AppColors.accentCyan,
    ),
    NavSectionItem(
      index: 6,
      number: '07',
      title: 'CONTACT & INQUIRIES',
      subtitle: 'Direct Channels & Availability',
      icon: Icons.mail_rounded,
      accentColor: AppColors.accentIndigoDeep,
    ),
  ];

  static void show(
    BuildContext context, {
    required int activeIndex,
    required ValueChanged<int> onSelectSection,
    required VoidCallback onDownloadResume,
  }) {
    SoundService.instance.playClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (_) => MobileNavSheet(
        activeIndex: activeIndex,
        onSelectSection: onSelectSection,
        onDownloadResume: onDownloadResume,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final navItems = getSections(context);

    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.slate900.withValues(alpha: 0.95)
              : Colors.white.withValues(alpha: 0.96),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.08),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.6)
                  : Colors.black.withValues(alpha: 0.12),
              blurRadius: 30,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: ConditionalBlur(
          sigma: 20,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Handle
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black26,
                      borderRadius: BorderRadius.circular(AppRadius.xxs),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '// DIRECTORY',
                            style: TextStyle(
                              color: AppColors.accentIndigo,
                              fontSize: AppTypography.caption,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'PORTFOLIO SECTIONS',
                            style: TextStyle(
                              fontFamily: AppTypography.displayFont,
                              color: isDark ? Colors.white : AppColors.slate900,
                              fontSize: AppTypography.subtitle,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          SoundService.instance.playClick();
                          Navigator.of(context).pop();
                        },
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : AppColors.slate100,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: isDark ? Colors.white70 : AppColors.slate900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),
                Container(
                  height: 1,
                  color: isDark ? Colors.white12 : AppColors.slate200,
                ),

                // Section items
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * 0.52,
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                    shrinkWrap: true,
                    itemCount: navItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = navItems[index];
                      final isActive = activeIndex == item.index;
                      final activeColor = isDark
                          ? item.accentColor
                          : switch (item.accentColor.toARGB32()) {
                              0xFF06B6D4 => AppColors.accentSkyDeep,
                              0xFF10B981 => AppColors.accentGreenDeep,
                              0xFF8B5CF6 => AppColors.accentVioletDeep,
                              0xFFFBBF24 => AppColors.accentAmberDeep,
                              0xFFF43F5E => AppColors.accentRoseDeep,
                              _ => item.accentColor,
                            };

                      return InkWell(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          SoundService.instance.playClick();
                          Navigator.of(context).pop();
                          onSelectSection(item.index);
                        },
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: AnimatedContainer(
                          duration: AppMotion.chipHover,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? item.accentColor
                                    .withValues(alpha: isDark ? 0.18 : 0.12)
                                : (isDark
                                    ? Colors.white.withValues(alpha: 0.04)
                                    : AppColors.slate50),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(
                              color: isActive
                                  ? activeColor.withValues(
                                      alpha: isDark ? 0.6 : 0.55)
                                  : (isDark
                                      ? Colors.white.withValues(alpha: 0.07)
                                      : AppColors.slate200),
                              width: isActive ? 1.5 : 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Number badge
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? item.accentColor
                                      : (isDark
                                          ? Colors.white.withValues(alpha: 0.08)
                                          : AppColors.slate200),
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.chip),
                                ),
                                child: Center(
                                  child: Text(
                                    item.number,
                                    style: TextStyle(
                                      color: isActive
                                          ? Colors.black
                                          : (isDark
                                              ? Colors.white70
                                              : AppColors.slate600),
                                      fontSize: AppTypography.caption,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: AppTypography.monoFont,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                item.icon,
                                size: 18,
                                color: isActive
                                    ? activeColor
                                    : (isDark
                                        ? Colors.white60
                                        : AppColors.slate500),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      item.title,
                                      style: TextStyle(
                                        color: isActive
                                            ? (isDark
                                                ? Colors.white
                                                : AppColors.slate900)
                                            : (isDark
                                                ? Colors.white
                                                    .withValues(alpha: 0.85)
                                                : AppColors.slate800),
                                        fontSize: AppTypography.small,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      item.subtitle,
                                      style: TextStyle(
                                        color: isActive
                                            ? item.accentColor
                                                .withValues(alpha: 0.9)
                                            : (isDark
                                                ? Colors.white38
                                                : AppColors.slate500),
                                        fontSize: AppTypography.editorial,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Copy deep-link button. Doesn't dismiss the
                              // sheet so users can grab the URL and keep
                              // browsing.
                              Semantics(
                                button: true,
                                label: 'Copy link to ${item.title}',
                                child: Tooltip(
                                  message: 'Copy link',
                                  child: InkResponse(
                                    radius: 18,
                                    onTap: () => _copySectionLink(
                                      context,
                                      item,
                                      isDark: isDark,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Icon(
                                        Icons.link_rounded,
                                        size: 16,
                                        color: isDark
                                            ? Colors.white38
                                            : AppColors.slate400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              if (isActive)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: item.accentColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: item.accentColor
                                            .withValues(alpha: 0.6),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                )
                              else
                                DirIcon(
                                  Icons.chevron_right,
                                  size: 16,
                                  color: isDark
                                      ? Colors.white24
                                      : AppColors.slate400,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  height: 1,
                  color: isDark ? Colors.white12 : AppColors.slate200,
                ),
                const SizedBox(height: 12),

                // Bottom Action: Download CV & Socials
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            SoundService.instance.playClick();
                            Navigator.of(context).pop();
                            onDownloadResume();
                          },
                          icon: const Icon(Icons.download_rounded, size: 18),
                          label: const Text(
                            'DOWNLOAD RESUME · PDF',
                            style: TextStyle(
                              fontSize: AppTypography.overlineTight,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.4,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentAmber,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.pill),
                            ),
                            elevation: 4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SocialButton(
                            label: 'LinkedIn',
                            icon: Icons.link_rounded,
                            url: 'https://linkedin.com/in/abdallah-alhyari',
                          ),
                          const SizedBox(width: 12),
                          _SocialButton(
                            label: 'GitHub',
                            icon: Icons.code_rounded,
                            url: 'https://github.com/abdallah-alhyari',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Copies a shareable absolute URL for a section (e.g.
  /// `https://alhyari.web.app/#contact`) to the clipboard so mobile users
  /// can hand off deep links without leaving the nav sheet.
  Future<void> _copySectionLink(
    BuildContext context,
    NavSectionItem item, {
    required bool isDark,
  }) async {
    SoundService.instance.playClick();
    final hash = UrlSyncService.instance.indexToHash(item.index);
    final link = '${CvService.siteRoot}/#$hash';
    await Clipboard.setData(ClipboardData(text: link));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: AppMotion.toast,
        margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded,
                color: AppColors.accentGreen, size: 16),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Link copied · $link',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final String url;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return InkWell(
      onTap: () async {
        SoundService.instance.playClick();
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      borderRadius: BorderRadius.circular(AppRadius.chip),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isDark ? Colors.white60 : AppColors.slate500,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white70 : AppColors.slate600,
                fontSize: AppTypography.caption,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
