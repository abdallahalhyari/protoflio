import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:profile/core/bloc/navigation/navigation_bloc.dart';
import 'package:profile/core/bloc/navigation/navigation_event.dart';
import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/shared/widget/directional_icon.dart';

/// Bottom-of-screen prev/next pager pill for the mobile continuous
/// scroll layout. Reads page state from NavigationBloc.
class MobilePager extends StatelessWidget {
  const MobilePager({super.key});

  @override
  Widget build(BuildContext context) {
    final page = context.select((NavigationBloc bloc) => bloc.state.pageIndex);
    final pageCount =
        context.select((NavigationBloc bloc) => bloc.state.pageCount);
    final isDark = context.isDarkMode;

    final canPrev = page > 0;
    final canNext = page < pageCount - 1;

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
              color: isDark ? AppColors.shadowMedium : AppColors.shadowSoft,
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
                      context
                          .read<NavigationBloc>()
                          .add(NavigationPageSelected(page - 1));
                    }
                  : null,
            ),
            const SizedBox(width: 6),
            AnimatedSwitcher(
              duration: AppMotion.switcher,
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: Text(
                '${(page + 1).toString().padLeft(2, '0')} / '
                '${pageCount.toString().padLeft(2, '0')}',
                key: ValueKey<int>(page),
                style: TextStyle(
                  fontFamily: AppTypography.monoFont,
                  fontSize: AppTypography.caption,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: context.mutedText,
                ),
              ),
            ),
            const SizedBox(width: 6),
            iconButton(
              icon: Icons.chevron_right_rounded,
              label: 'Next section',
              onTap: canNext
                  ? () {
                      SoundService.instance.playPageTurn();
                      context
                          .read<NavigationBloc>()
                          .add(NavigationPageSelected(page + 1));
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
