import 'package:flutter/material.dart';

import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';
import '../home_controller.dart';
import 'portfolio_nav.dart' show TopNav;

/// Vertical dot column pinned to the right edge on mobile. Each dot
/// jumps to its section.
class MobileProgressRail extends StatelessWidget {
  const MobileProgressRail({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.of(context);
    final pageCount = controller.pageCount;
    final labels = TopNav.getLabels(context);

    return ValueListenableBuilder<int>(
      valueListenable: controller.pageIndex,
      builder: (context, page, _) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          decoration: BoxDecoration(
            color: context.glassSurface,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: context.glassBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < pageCount; i++)
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
                        : () {
                            SoundService.instance.playSelection();
                            controller.scrollToMobileSection(i);
                          },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: _HoverScale(
                        child: AnimatedContainer(
                          duration: AppMotion.sm,
                          curve: AppMotion.emphasized,
                          width: i == page ? 8 : 5,
                          height: i == page ? 8 : 5,
                          decoration: BoxDecoration(
                            color: i == page
                                ? Theme.of(context).colorScheme.primary
                                : context.railDot(ThemeBloc.colorForIndex(i)),
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
                ),
            ],
          ),
        );
      },
    );
  }
}

class _HoverScale extends StatefulWidget {
  final Widget child;
  const _HoverScale({required this.child});

  @override
  State<_HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<_HoverScale> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.3 : 1.0,
        duration: AppMotion.sm,
        curve: AppMotion.emphasized,
        child: widget.child,
      ),
    );
  }
}
