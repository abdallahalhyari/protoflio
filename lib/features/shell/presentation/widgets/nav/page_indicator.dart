import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/shell/presentation/controllers/home_controller.dart';
import 'package:profile/features/shell/presentation/widgets/nav/hover_scale.dart';
import 'package:profile/features/shell/presentation/widgets/nav/top_nav.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.of(context);
    return ValueListenableBuilder<int>(
      valueListenable: controller.pageIndex,
      builder: (context, current, _) =>
          _build(context, current, controller.pageCount),
    );
  }

  Widget _build(BuildContext context, int current, int pageCount) {
    final isDark = context.isDarkMode;
    final labels = TopNav.getLabels(context);

    return ExcludeSemantics(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(pageCount, (i) {
            final active = i == current;
            final label = i < labels.length ? labels[i] : 'Page ${i + 1}';
            return Tooltip(
              message: label,
              preferBelow: false,
              child: Semantics(
                button: true,
                selected: active,
                label: 'Go to $label',
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: InkResponse(
                    canRequestFocus: false,
                    onTap: () {
                      if (active) return;
                      HapticFeedback.selectionClick();
                      HomeController.of(context).goTo(i);
                    },
                    radius: 22,
                    child: Center(
                      child: HoverScale(
                        child: AnimatedContainer(
                          duration: AppMotion.sm,
                          curve: AppMotion.emphasized,
                          width: active ? 12 : 8,
                          height: active ? 12 : 8,
                          decoration: BoxDecoration(
                            color: active
                                ? (isDark ? Colors.white : AppColors.teal)
                                : (isDark ? Colors.white70 : AppColors.ink400),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? Colors.black45 : Colors.white,
                            ),
                            boxShadow: active
                                ? [
                                    BoxShadow(
                                      color: (isDark
                                              ? Colors.white
                                              : AppColors.teal)
                                          .withValues(alpha: 0.5),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    )
                                  ]
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
