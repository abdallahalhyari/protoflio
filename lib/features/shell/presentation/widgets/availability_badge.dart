import 'package:flutter/material.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/shell/presentation/controllers/home_controller.dart';
import 'package:profile/l10n/app_localizations.dart';

/// Top-left status pill on wide desktop screens: availability, one click
/// from Contact. Hidden below 1180px, where the nav pill needs the room.
class AvailabilityBadge extends StatelessWidget {
  const AvailabilityBadge({super.key});

  static const double minWidth = 1180;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.sizeOf(context).width < minWidth) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context)!;
    final live = context.isDarkMode ? AppColors.tealLight : AppColors.tealDeep;
    final controller = HomeController.maybeOf(context);

    return Semantics(
      button: controller != null,
      label: l10n.navAvailable,
      excludeSemantics: true,
      child: Material(
        color: context.glassSurface,
        shape: StadiumBorder(side: BorderSide(color: context.glassBorder)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: controller == null
              ? null
              : () {
                  SoundService.instance.playClick();
                  controller.goTo(controller.pageCount - 1);
                },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration:
                      BoxDecoration(color: live, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.navAvailable,
                  style: TextStyle(
                    fontSize: AppTypography.label,
                    fontWeight: FontWeight.w600,
                    color: context.onSurface,
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
