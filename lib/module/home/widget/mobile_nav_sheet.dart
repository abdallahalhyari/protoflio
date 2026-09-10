import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../service/sound_service.dart';
import '../../../theme/tokens.dart';

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

  static const List<NavSectionItem> sections = [
    NavSectionItem(
      index: 0,
      number: '01',
      title: 'COVER & PROFILE',
      subtitle: 'Senior Flutter & Android Architect',
      icon: Icons.home_rounded,
      accentColor: Color(0xFF818CF8),
    ),
    NavSectionItem(
      index: 1,
      number: '02',
      title: 'FEATURED WORK',
      subtitle: 'Production Systems & Case Studies',
      icon: Icons.rocket_launch_rounded,
      accentColor: Color(0xFFFBBF24),
    ),
    NavSectionItem(
      index: 2,
      number: '03',
      title: 'SYSTEM ARCHITECTURES',
      subtitle: 'Enterprise Blueprints & Offline-First',
      icon: Icons.hub_rounded,
      accentColor: Color(0xFF38BDF8),
    ),
    NavSectionItem(
      index: 3,
      number: '04',
      title: 'CAREER TRAJECTORY',
      subtitle: '4+ Years Enterprise Engineering & Milestones',
      icon: Icons.timeline_rounded,
      accentColor: Color(0xFFA78BFA),
    ),
    NavSectionItem(
      index: 4,
      number: '05',
      title: 'SKILLS & STACK',
      subtitle: 'Technical Proficiency Matrix',
      icon: Icons.code_rounded,
      accentColor: Color(0xFF34D399),
    ),
    NavSectionItem(
      index: 5,
      number: '06',
      title: 'LEADERSHIP ROLES',
      subtitle: 'Architectural Perspectives & Hats',
      icon: Icons.style_rounded,
      accentColor: Color(0xFFF59E0B),
    ),
    NavSectionItem(
      index: 6,
      number: '07',
      title: 'CONTACT & COLOPHON',
      subtitle: 'Direct Channels & Availability',
      icon: Icons.mail_rounded,
      accentColor: Color(0xFF38BDF8),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF0F172A).withValues(alpha: 0.95)
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
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
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
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '// DIRECTORY',
                              style: TextStyle(
                                color: const Color(0xFF818CF8),
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.0,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'PORTFOLIO SECTIONS',
                              style: TextStyle(
                                fontFamily: 'Tenada',
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                                fontSize: 16,
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
                                  : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: isDark ? Colors.white70 : const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),
                  Container(
                    height: 1,
                    color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
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
                      itemCount: sections.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = sections[index];
                        final isActive = activeIndex == item.index;

                        return InkWell(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            SoundService.instance.playClick();
                            Navigator.of(context).pop();
                            onSelectSection(item.index);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? item.accentColor.withValues(alpha: isDark ? 0.18 : 0.12)
                                  : (isDark
                                      ? Colors.white.withValues(alpha: 0.04)
                                      : const Color(0xFFF8FAFC)),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isActive
                                    ? item.accentColor.withValues(alpha: isDark ? 0.6 : 0.45)
                                    : (isDark
                                        ? Colors.white.withValues(alpha: 0.07)
                                        : const Color(0xFFE2E8F0)),
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
                                            : const Color(0xFFE2E8F0)),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Center(
                                    child: Text(
                                      item.number,
                                      style: TextStyle(
                                        color: isActive
                                            ? Colors.black
                                            : (isDark ? Colors.white70 : const Color(0xFF475569)),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Courier',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  item.icon,
                                  size: 18,
                                  color: isActive
                                      ? item.accentColor
                                      : (isDark ? Colors.white60 : const Color(0xFF64748B)),
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
                                              ? (isDark ? Colors.white : const Color(0xFF0F172A))
                                              : (isDark
                                                  ? Colors.white.withValues(alpha: 0.85)
                                                  : const Color(0xFF1E293B)),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        item.subtitle,
                                        style: TextStyle(
                                          color: isActive
                                              ? item.accentColor.withValues(alpha: 0.9)
                                              : (isDark ? Colors.white38 : const Color(0xFF64748B)),
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isActive)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: item.accentColor,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: item.accentColor.withValues(alpha: 0.6),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  Icon(
                                    Icons.chevron_right,
                                    size: 16,
                                    color: isDark ? Colors.white24 : const Color(0xFF94A3B8),
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
                    color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                  ),
                  const SizedBox(height: 12),

                  // Bottom Action: Download CV & Socials
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
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
                                fontSize: 12.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.4,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFBBF24),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppRadius.pill),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () async {
        SoundService.instance.playClick();
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isDark ? Colors.white60 : const Color(0xFF64748B),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white70 : const Color(0xFF475569),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
