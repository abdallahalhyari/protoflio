import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/services/cv_service.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/services/url_sync_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/widgets/app_toast.dart';
import 'package:profile/shared/widgets/conditional_blur.dart';

import 'package:profile/features/shell/presentation/widgets/nav_sheet/nav_sheet_header.dart';
import 'package:profile/features/shell/presentation/widgets/nav_sheet/nav_sheet_section_row.dart';
import 'package:profile/features/shell/presentation/widgets/nav_sheet/nav_sheet_bottom_actions.dart';

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

  static List<NavSectionItem> getSections(BuildContext context) {
    final l = AppLocalizations.of(context);
    return [
      NavSectionItem(
        index: 0,
        number: '01',
        title: l?.navSectionCover ?? 'COVER & PROFILE',
        subtitle: l?.navSubCover ?? 'Senior Flutter & Android Engineer',
        icon: Icons.home_rounded,
        accentColor: AppColors.seed,
      ),
      NavSectionItem(
        index: 1,
        number: '02',
        title: l?.navSectionExperience ?? 'EXPERIENCE',
        subtitle:
            l?.navSubExperience ?? '5+ Years Enterprise Engineering & Impact',
        icon: Icons.timeline_rounded,
        accentColor: AppColors.teal,
      ),
      NavSectionItem(
        index: 2,
        number: '03',
        title: l?.navSectionWork ?? 'SELECTED WORK',
        subtitle: l?.navSubWork ?? 'Production Systems & Case Studies',
        icon: Icons.rocket_launch_rounded,
        accentColor: AppColors.teal,
      ),
      NavSectionItem(
        index: 3,
        number: '04',
        title: l?.navSectionStack ?? 'SKILLS & STACK',
        subtitle: l?.navSubStack ?? 'Technical Proficiency Matrix',
        icon: Icons.code_rounded,
        accentColor: AppColors.gold,
      ),
      NavSectionItem(
        index: 4,
        number: '05',
        title: l?.navSectionEngineering ?? 'ENGINEERING',
        subtitle:
            l?.navSubEngineering ?? 'Enterprise Blueprints & Offline-First',
        icon: Icons.hub_rounded,
        accentColor: AppColors.signal,
      ),
      NavSectionItem(
        index: 5,
        number: '06',
        title: l?.navSectionAbout ?? 'PERSPECTIVES',
        subtitle: l?.navSubAbout ?? 'Architectural Perspectives & Hats',
        icon: Icons.style_rounded,
        accentColor: AppColors.teal,
      ),
      NavSectionItem(
        index: 6,
        number: '07',
        title: l?.navSectionContact ?? 'CONTACT',
        subtitle: l?.navSubContact ?? 'Direct Channels & Availability',
        icon: Icons.mail_rounded,
        accentColor: AppColors.teal,
      ),
    ];
  }

  static const List<NavSectionItem> sections = [
    NavSectionItem(
      index: 0,
      number: '01',
      title: 'COVER & PROFILE',
      subtitle: 'Senior Flutter & Android Engineer',
      icon: Icons.home_rounded,
      accentColor: AppColors.seed,
    ),
    NavSectionItem(
      index: 1,
      number: '02',
      title: 'CAREER & EXPERIENCE',
      subtitle: '5+ Years Enterprise Engineering & Impact',
      icon: Icons.timeline_rounded,
      accentColor: AppColors.teal,
    ),
    NavSectionItem(
      index: 2,
      number: '03',
      title: 'FEATURED WORK',
      subtitle: 'Production Systems & Case Studies',
      icon: Icons.rocket_launch_rounded,
      accentColor: AppColors.teal,
    ),
    NavSectionItem(
      index: 3,
      number: '04',
      title: 'SKILLS & STACK',
      subtitle: 'Technical Proficiency Matrix',
      icon: Icons.code_rounded,
      accentColor: AppColors.gold,
    ),
    NavSectionItem(
      index: 4,
      number: '05',
      title: 'SYSTEM ARCHITECTURES',
      subtitle: 'Enterprise Blueprints & Offline-First',
      icon: Icons.hub_rounded,
      accentColor: AppColors.signal,
    ),
    NavSectionItem(
      index: 5,
      number: '06',
      title: 'LEADERSHIP PERSPECTIVES',
      subtitle: 'Architectural Perspectives & Hats',
      icon: Icons.style_rounded,
      accentColor: AppColors.teal,
    ),
    NavSectionItem(
      index: 6,
      number: '07',
      title: 'CONTACT & INQUIRIES',
      subtitle: 'Direct Channels & Availability',
      icon: Icons.mail_rounded,
      accentColor: AppColors.teal,
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
      sheetAnimationStyle: const AnimationStyle(
        duration: AppMotion.md,
        reverseDuration: AppMotion.sm,
      ),
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
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.ink900.withValues(alpha: 0.95)
              : Colors.white.withValues(alpha: 0.96),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.6)
                  : Colors.black.withValues(alpha: AppAlpha.hover),
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
                SheetHeader(isDark: isDark),
                const SizedBox(height: 14),
                Container(height: 1, color: context.divider),
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
                      return NavSectionRow(
                        item: item,
                        isActive: activeIndex == item.index,
                        isDark: isDark,
                        onSelect: () {
                          HapticFeedback.selectionClick();
                          SoundService.instance.playClick();
                          Navigator.of(context).pop();
                          onSelectSection(item.index);
                        },
                      );
                    },
                  ),
                ),
                Container(height: 1, color: context.divider),
                const SizedBox(height: 12),
                BottomActions(onDownloadResume: onDownloadResume),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> copySectionLink(
    BuildContext context,
    NavSectionItem item, {
    required bool isDark,
  }) async {
    SoundService.instance.playClick();
    final hash = UrlSyncService.instance.indexToHash(item.index);
    final link = '${CvService.siteRoot}/#$hash';
    await Clipboard.setData(ClipboardData(text: link));
    if (!context.mounted) return;
    AppToast.showGlass(
      context,
      message: 'Link copied · $link',
    );
  }
}
