import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
import '../home_controller.dart';
import 'portfolio_nav.dart' show TopNav;

/// Desktop bottom-left "05 / 07 · SKILLS" folio bar. Reads pageIndex
/// + pageCount from the ambient [HomeController]; labels via
/// `TopNav.getLabels`.
class FolioBar extends StatelessWidget {
  const FolioBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.of(context);
    final labels = TopNav.getLabels(context);

    return ValueListenableBuilder<int>(
      valueListenable: controller.pageIndex,
      builder: (context, page, _) {
        final currentLabel = (page >= 0 && page < labels.length)
            ? labels[page].toUpperCase()
            : '';
        return Semantics(
          container: true,
          label:
              'Current section: $currentLabel, page ${page + 1} of ${controller.pageCount}',
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: context.glassSurface,
              borderRadius: BorderRadius.circular(AppRadius.xs),
              border: Border.all(color: context.glassBorder),
              boxShadow: context.isDarkMode
                  ? null
                  : [
                      BoxShadow(
                        color: AppColors.shadowSoft,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.folioIndicator(
                    (page + 1).toString().padLeft(2, '0'),
                    controller.pageCount.toString().padLeft(2, '0'),
                  ),
                  style: TextStyle(
                    color: context.subtleText,
                    fontSize: AppTypography.micro,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 1,
                  height: 10,
                  color: context.glassBorderStrong,
                ),
                const SizedBox(width: 8),
                AnimatedContainer(
                  duration: AppMotion.sm,
                  curve: AppMotion.emphasized,
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.7),
                        blurRadius: 6,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  currentLabel,
                  style: TextStyle(
                    color: context.onSurface,
                    fontSize: AppTypography.micro,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
