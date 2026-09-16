import 'package:flutter/material.dart';

import '../../../theme/tokens.dart';
import '../home_controller.dart';
import 'portfolio_nav.dart' show TopNav;

/// Vertical dot column pinned to the right edge on mobile. Each dot
/// jumps to its section. Reads page + count from the ambient
/// [HomeController].
class MobileProgressRail extends StatelessWidget {
  const MobileProgressRail({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = HomeController.of(context);
    final labels = TopNav.getLabels(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withValues(alpha: 0.35)
            : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.10)
              : AppColors.slate200,
        ),
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
                            : (isDark ? Colors.white38 : AppColors.slate400),
                        shape: BoxShape.circle,
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
