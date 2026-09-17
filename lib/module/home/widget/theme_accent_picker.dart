import 'package:flutter/material.dart';

import '../../../service/sound_service.dart';
import '../../../theme/surface_tone.dart';
import '../../../theme/tokens.dart';
import '../../../theme_controller.dart';

/// Floating chromatic palette customizer.
///
/// Allows visitors to personalize the portfolio's primary accent tone
/// across Electric Indigo, Neo Emerald, Quantum Cyan, Solar Amber,
/// Coral Rose, Cyber Violet, or switch back to Section-Dynamic sync.
class ThemeAccentPickerButton extends StatelessWidget {
  const ThemeAccentPickerButton({
    super.key,
    this.isMobile = false,
  });

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return ValueListenableBuilder<Color>(
      valueListenable: ThemeController.seedColor,
      builder: (context, activeColor, _) {
        return ValueListenableBuilder<Color?>(
          valueListenable: ThemeController.customAccent,
          builder: (context, customAccent, _) {
            final isDynamic = customAccent == null;

            return PopupMenuButton<Color?>(
              tooltip: 'Theme accent palette',
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                side: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.14)
                      : AppColors.slate300,
                  width: 1.0,
                ),
              ),
              color: isDark
                  ? const Color(0xF20B101D)
                  : Colors.white.withValues(alpha: 0.96),
              offset: const Offset(0, 42),
              onSelected: (color) {
                SoundService.instance.playClick();
                ThemeController.setCustomAccent(color);
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem<Color?>(
                    enabled: false,
                    height: 28,
                    child: Text(
                      'CHROMATIC ACCENT',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: AppTypography.micro,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        color: isDark ? Colors.white70 : AppColors.slate600,
                      ),
                    ),
                  ),
                  const PopupMenuDivider(height: 8),
                  // Auto / Section-Adaptive mode
                  PopupMenuItem<Color?>(
                    value: null,
                    height: 38,
                    child: Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const SweepGradient(
                              colors: [
                                AppColors.accentIndigo,
                                AppColors.accentGreen,
                                AppColors.accentCyan,
                                AppColors.accentAmber,
                                AppColors.accentRose,
                                AppColors.accentViolet,
                                AppColors.accentIndigo,
                              ],
                            ),
                            border: Border.all(
                              color: isDynamic
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.4),
                              width: isDynamic ? 2.0 : 1.0,
                            ),
                            boxShadow: isDynamic
                                ? [
                                    BoxShadow(
                                      color: activeColor.withValues(alpha: 0.4),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Dynamic (Sync with Section)',
                            style: TextStyle(
                              fontSize: AppTypography.small,
                              fontWeight:
                                  isDynamic ? FontWeight.w800 : FontWeight.w500,
                              color: isDynamic
                                  ? (isDark
                                      ? AppColors.accentCyan
                                      : AppColors.accentCyanDeep)
                                  : (isDark
                                      ? Colors.white
                                      : AppColors.slate800),
                            ),
                          ),
                        ),
                        if (isDynamic)
                          Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: isDark
                                ? AppColors.accentCyan
                                : AppColors.accentCyanDeep,
                          ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(height: 8),
                  // 6 Curated Accents
                  ...AppColors.themeAccents.map((item) {
                    final label = item.$1;
                    final col = item.$2;
                    final isSelected = !isDynamic &&
                        customAccent.toARGB32() == col.toARGB32();

                    return PopupMenuItem<Color?>(
                      value: col,
                      height: 38,
                      child: Row(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: col,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.2),
                                width: isSelected ? 2.0 : 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: col.withValues(alpha: 0.4),
                                  blurRadius: 6,
                                  spreadRadius: 0.5,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: AppTypography.small,
                                fontWeight: isSelected
                                    ? FontWeight.w800
                                    : FontWeight.w500,
                                color: isSelected
                                    ? col
                                    : (isDark
                                        ? Colors.white
                                        : AppColors.slate800),
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: col,
                            ),
                        ],
                      ),
                    );
                  }),
                ];
              },
              child: isMobile
                  ? Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.palette_outlined,
                            size: 18,
                            color: isDark ? Colors.white70 : AppColors.slate600,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 2,
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: activeColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: activeColor.withValues(alpha: 0.7),
                                    blurRadius: 4,
                                    spreadRadius: 0.5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Material(
                      color: isDark
                          ? Colors.black45
                          : Colors.white.withValues(alpha: 0.9),
                      elevation: isDark ? 0 : 2,
                      shadowColor: Colors.black12,
                      shape: CircleBorder(
                        side: BorderSide(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.14)
                              : AppColors.slate200,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.palette_outlined,
                              size: 20,
                              color:
                                  isDark ? Colors.white : AppColors.slate900,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: activeColor,
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.darkSurface
                                        : Colors.white,
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          activeColor.withValues(alpha: 0.8),
                                      blurRadius: 5,
                                      spreadRadius: 0.5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            );
          },
        );
      },
    );
  }
}
