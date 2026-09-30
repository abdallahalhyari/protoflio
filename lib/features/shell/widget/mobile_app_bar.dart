import 'package:flutter/material.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/shared/widget/conditional_blur.dart';

import 'package:profile/features/shell/widget/app_bar/app_bar_brand_signature.dart';
import 'package:profile/features/shell/widget/app_bar/app_bar_language_toggle.dart';
import 'package:profile/features/shell/widget/app_bar/app_bar_theme_toggle.dart';
import 'package:profile/features/shell/widget/app_bar/app_bar_audio_toggle.dart';
import 'package:profile/features/shell/widget/app_bar/app_bar_menu_pill.dart';

class MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
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
  Widget build(BuildContext context) => MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.35,
        child: Builder(builder: _buildBar),
      );

  Widget _buildBar(BuildContext context) {
    final isDark = context.isDarkMode;
    final tight = AppBreakpoints.isCompact(context) ||
        MediaQuery.textScalerOf(context).scale(1) > 1.15;
    final ultraTight = MediaQuery.sizeOf(context).width < 360;
    final primary = Theme.of(context).colorScheme.primary;

    return RepaintBoundary(
      child: ConditionalBlur(
        sigma: 18,
        child: Container(
          height: 60 + MediaQuery.paddingOf(context).top,
          padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top,
            left: ultraTight ? AppSpacing.sm : AppSpacing.md,
            right: ultraTight ? AppSpacing.sm : AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: context.glassSurface,
            border: Border(
              bottom: BorderSide(
                color: primary.withValues(alpha: isDark ? 0.28 : 0.16),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? AppColors.shadowMedium : AppColors.shadowSoft,
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: AppBarBrandSignature(
                    tight: tight,
                    isDark: isDark,
                    onLogoPressed: onLogoPressed,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              if (!tight) ...[
                const AppBarLanguageToggle(),
                const SizedBox(width: 6),
              ],
              const AppBarThemeToggle(),
              const SizedBox(width: 6),
              if (!ultraTight) ...[
                const SizedBox(width: 6),
                const AppBarAudioToggle(),
              ],
              const SizedBox(width: 6),
              AppBarMenuPill(
                tight: ultraTight,
                isDark: isDark,
                onMenuPressed: onMenuPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
