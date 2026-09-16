import 'package:flutter/material.dart';
import 'package:profile/locale_controller.dart';
import '../../../service/sound_service.dart';
import '../../../theme/surface_tone.dart';
import '../../../theme/tokens.dart';
import '../../../theme_controller.dart';
import '../home_controller.dart';
import 'conditional_blur.dart';
import 'portfolio_nav.dart';

class MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Public constant so callers (mobile scroll snap, section anchors)
  /// can offset by the app bar's fixed height without magic numbers.
  static const double kBarHeight = 60;

  final VoidCallback onMenuPressed;
  final VoidCallback? onLogoPressed;

  const MobileAppBar({
    super.key,
    required this.onMenuPressed,
    this.onLogoPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kBarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final tight = MediaQuery.sizeOf(context).width < 460;

    return RepaintBoundary(
      child: ConditionalBlur(
        sigma: 18,
        child: Container(
            height: 60 + MediaQuery.paddingOf(context).top,
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top,
              left: AppSpacing.md,
              right: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: context.glassSurface,
              border: Border(
                bottom: BorderSide(color: context.divider, width: 1.0),
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      isDark ? AppColors.shadowMedium : AppColors.shadowSoft,
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Brand signature
                Semantics(
                  button: true,
                  label: 'Abdallah Alhyari — return to top',
                  child: InkWell(
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
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            gradient: const LinearGradient(
                              colors: [AppColors.accentIndigo, Color(0xFFFBBF24)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentIndigo.withValues(alpha: 0.3),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'A',
                              style: TextStyle(
                                fontFamily: AppTypography.displayFont,
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
                                fontFamily: AppTypography.displayFont,
                                color: isDark ? Colors.white : AppColors.slate900,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.4,
                                height: 1.1,
                              ),
                            ),
                            if (!tight)
                              _buildSubBadge(context, isDark),
                          ],
                        ),
                      ],
                    ),
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
                        borderRadius: BorderRadius.circular(AppRadius.chip),
                        onTap: () {
                          SoundService.instance.playClick();
                          LocaleController.nextLocale();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : AppColors.slate100,
                            borderRadius: BorderRadius.circular(AppRadius.chip),
                            border: Border.all(
                              color: isDark ? Colors.white12 : AppColors.slate200,
                            ),
                          ),
                          child: Text(
                            code,
                            style: TextStyle(
                              color: isDark ? Colors.white : AppColors.slate900,
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
                        color: isDark ? Colors.white70 : AppColors.slate600,
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
                            : (isDark ? Colors.white38 : AppColors.slate400),
                      ),
                      onPressed: () {
                        SoundService.instance.toggle();
                      },
                    );
                  },
                ),

                const SizedBox(width: 6),

                // Menu Pill
                Semantics(
                  button: true,
                  label: 'Open navigation menu',
                  child: InkWell(
                  onTap: () {
                    SoundService.instance.playClick();
                    onMenuPressed();
                  },
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accentIndigo.withValues(alpha: isDark ? 0.22 : 0.15),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(
                        color: AppColors.accentIndigo.withValues(alpha: 0.6),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentIndigo.withValues(alpha: 0.2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.menu_rounded, size: 14, color: AppColors.accentIndigo),
                        const SizedBox(width: 4),
                        Text(
                          'MENU',
                          style: TextStyle(
                            color: isDark ? Colors.white : AppColors.accentIndigo600,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  /// Sub-row under the ABDALLAH monogram. Falls back to the AVAILABLE
  /// presence dot when no controller is in scope; otherwise renders a
  /// live "03 · Engineering" chip so mobile users always see where they
  /// are without opening the menu.
  Widget _buildSubBadge(BuildContext context, bool isDark) {
    final controller = HomeController.maybeOf(context);
    if (controller == null) return _availableBadge(isDark);

    return ValueListenableBuilder<int>(
      valueListenable: controller.pageIndex,
      builder: (context, page, _) {
        if (page < 0) return _availableBadge(isDark);
        final labels = TopNav.getLabels(context);
        if (page >= labels.length) return _availableBadge(isDark);

        final ordinal = (page + 1).toString().padLeft(2, '0');
        final denom = ' / ${controller.pageCount.toString().padLeft(2, '0')}';
        final label = labels[page].toUpperCase();

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$ordinal$denom',
              style: TextStyle(
                fontFamily: 'Courier',
                color: AppColors.accentIndigo,
                fontSize: 9.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 1,
              height: 8,
              color: isDark ? Colors.white24 : AppColors.slate300,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: AnimatedSwitcher(
                duration: AppMotion.chipHover,
                child: Text(
                  label,
                  key: ValueKey(label),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.8)
                        : AppColors.slate600,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _availableBadge(bool isDark) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.accentGreen,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'AVAILABLE',
            style: TextStyle(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.7)
                  : AppColors.slate600,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
        ],
      );
}
