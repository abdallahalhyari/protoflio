import 'package:flutter/material.dart';

import '../../../theme/surface_tone.dart';
import '../../../theme/tokens.dart';
import '../../../theme_controller.dart';
import '../home_controller.dart';
import 'portfolio_nav.dart' show TopNav;

/// Vertical dot column pinned to the right edge on mobile. Each dot
/// jumps to its section. Reads page + count from the ambient
/// [HomeController].
class MobileProgressRail extends StatelessWidget {
  const MobileProgressRail({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.of(context);
    final labels = TopNav.getLabels(context);
    final isDark = context.isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: context.glassSurface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: context.glassBorder),
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: controller.pageIndex,
        builder: (context, page, _) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < controller.pageCount; i++)
              Semantics(
                button: true,
                selected: i == page,
                label: i < labels.length
                    ? 'Go to ${labels[i]}'
                    : 'Go to page ${i + 1}',
                child: InkResponse(
                  radius: 14,
                  onTap: i == page
                      ? null
                      : () => controller.scrollToMobileSection(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: AnimatedContainer(
                      duration: AppMotion.sm,
                      width: i == page ? 8 : 5,
                      height: i == page ? 8 : 5,
                      decoration: BoxDecoration(
                        color: i == page
                            ? Theme.of(context).colorScheme.primary
                            : ThemeController.colorForIndex(i)
                                .withValues(alpha: isDark ? 0.35 : 0.45),
                        shape: BoxShape.circle,
                        boxShadow: i == page
                            ? [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: 0.7),
                                  blurRadius: 6,
                                  spreadRadius: 0.5,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
