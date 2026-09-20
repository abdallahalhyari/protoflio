import 'package:flutter/material.dart';

import '../../../service/sound_service.dart';
import '../../../theme/surface_tone.dart';
import '../../../theme/tokens.dart';
import '../home_controller.dart';
import 'directional_icon.dart';

/// Bottom-of-screen prev/next pager pill for the mobile continuous
/// scroll layout. Reads page state and nav intents from the ambient
/// [HomeController] — no props required.
class MobilePager extends StatelessWidget {
  const MobilePager({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.of(context);
    final isDark = context.isDarkMode;

    return ValueListenableBuilder<int>(
      valueListenable: controller.pageIndex,
      builder: (context, page, _) {
        final canPrev = page > 0;
        final canNext = page < controller.pageCount - 1;

        Widget iconButton({
          required IconData icon,
          required String label,
          required VoidCallback? onTap,
        }) {
          return Semantics(
            button: true,
            enabled: onTap != null,
            label: label,
            child: Tooltip(
              message: label,
              child: InkResponse(
                radius: 22,
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: DirIcon(
                    icon,
                    size: 18,
                    color: onTap == null
                        ? context.glassBorderStrong
                        : (isDark ? Colors.white : AppColors.slate700),
                  ),
                ),
              ),
            ),
          );
        }

        return Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: context.glassSurface,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: context.glassBorder),
              boxShadow: [
                BoxShadow(
                  color:
                      isDark ? AppColors.shadowMedium : AppColors.shadowSoft,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                iconButton(
                  icon: Icons.chevron_left_rounded,
                  label: 'Previous section',
                  onTap: canPrev
                      ? () {
                          SoundService.instance.playPageTurn();
                          controller.scrollToMobileSection(page - 1);
                        }
                      : null,
                ),
                const SizedBox(width: 6),
                Text(
                  '${(page + 1).toString().padLeft(2, '0')} / '
                  '${controller.pageCount.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontFamily: AppTypography.monoFont,
                    fontSize: AppTypography.caption,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: context.mutedText,
                  ),
                ),
                const SizedBox(width: 6),
                iconButton(
                  icon: Icons.chevron_right_rounded,
                  label: 'Next section',
                  onTap: canNext
                      ? () {
                          SoundService.instance.playPageTurn();
                          controller.scrollToMobileSection(page + 1);
                        }
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
