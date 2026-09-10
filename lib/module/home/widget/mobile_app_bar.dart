import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:profile/locale_controller.dart';
import '../../../service/sound_service.dart';
import '../../../theme/tokens.dart';
import '../../../theme_controller.dart';

class MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;
  final VoidCallback? onLogoPressed;

  const MobileAppBar({
    super.key,
    required this.onMenuPressed,
    this.onLogoPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tight = MediaQuery.sizeOf(context).width < 400;

    return RepaintBoundary(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 60 + MediaQuery.paddingOf(context).top,
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top,
              left: AppSpacing.md,
              right: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.75)
                  : Colors.white.withValues(alpha: 0.85),
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : Colors.black.withValues(alpha: 0.08),
                  width: 1.0,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.35)
                      : Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Brand signature
                InkWell(
                  onTap: () {
                    SoundService.instance.playClick();
                    onLogoPressed?.call();
                  },
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Monogram badge
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF818CF8), Color(0xFFFBBF24)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF818CF8).withValues(alpha: 0.3),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'A',
                              style: TextStyle(
                                fontFamily: 'Tenada',
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ABDALLAH',
                              style: TextStyle(
                                fontFamily: 'Tenada',
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.4,
                                height: 1.1,
                              ),
                            ),
                            if (!tight)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF10B981),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'AVAILABLE',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.7)
                                          : const Color(0xFF475569),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Quick Controls
                // Language (hidden under 400px — reachable via slide-out menu)
                if (!tight) ...[
                  ValueListenableBuilder<Locale>(
                    valueListenable: LocaleController.locale,
                    builder: (_, loc, __) {
                      final code = loc.languageCode.toUpperCase();
                      return InkWell(
                        borderRadius: BorderRadius.circular(6),
                        onTap: () {
                          SoundService.instance.playClick();
                          LocaleController.nextLocale();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Text(
                            code,
                            style: TextStyle(
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 6),
                ],

                // Theme
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: ThemeController.mode,
                  builder: (_, mode, __) {
                    final dark = mode == ThemeMode.dark;
                    return IconButton(
                      iconSize: 18,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      icon: Icon(
                        dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                        color: isDark ? Colors.white70 : const Color(0xFF475569),
                      ),
                      onPressed: () {
                        SoundService.instance.playClick();
                        ThemeController.toggle();
                      },
                    );
                  },
                ),

                const SizedBox(width: 6),

                // Audio
                ValueListenableBuilder<bool>(
                  valueListenable: SoundService.instance.isEnabled,
                  builder: (_, enabled, __) {
                    return IconButton(
                      iconSize: 18,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      icon: Icon(
                        enabled ? Icons.volume_up_outlined : Icons.volume_off_outlined,
                        color: enabled
                            ? const Color(0xFFFBBF24)
                            : (isDark ? Colors.white38 : const Color(0xFF94A3B8)),
                      ),
                      onPressed: () {
                        SoundService.instance.toggle();
                      },
                    );
                  },
                ),

                const SizedBox(width: 6),

                // Menu Pill
                InkWell(
                  onTap: () {
                    SoundService.instance.playClick();
                    onMenuPressed();
                  },
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF818CF8).withValues(alpha: isDark ? 0.22 : 0.15),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(
                        color: const Color(0xFF818CF8).withValues(alpha: 0.6),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF818CF8).withValues(alpha: 0.2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.menu_rounded, size: 14, color: Color(0xFF818CF8)),
                        const SizedBox(width: 4),
                        Text(
                          'MENU',
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF4F46E5),
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
