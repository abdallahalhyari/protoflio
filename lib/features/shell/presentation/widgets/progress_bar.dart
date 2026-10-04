import 'package:flutter/material.dart';

/// Top-edge progress bar for the desktop PageView. Only the width
/// animates every scroll frame, so the decorated `Container` is
/// cached via the AnimatedBuilder `child:` parameter and wrapped in
/// a `RepaintBoundary` by the caller.
///
/// Takes the [PageController] directly because it needs the continuous
/// `controller.page` value — an integer `pageIndex` snapshot would
/// only tick between pages and drop the smooth scroll feel.
class PortfolioProgressBar extends StatelessWidget {
  const PortfolioProgressBar({
    super.key,
    required this.controller,
    required this.pageCount,
  });

  final PageController controller;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;
    final decoratedBar = Container(
      height: 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primary.withValues(alpha: 0.3),
            primary,
            scheme.secondary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.5),
            blurRadius: 4,
          ),
        ],
      ),
    );
    final viewportWidth = MediaQuery.sizeOf(context).width;

    return Semantics(
      label: 'Portfolio progress',
      child: AnimatedBuilder(
        animation: controller,
        child: decoratedBar,
        builder: (context, child) {
          double progress = 0.0;
          if (controller.hasClients &&
              controller.positions.length == 1 &&
              controller.position.haveDimensions) {
            progress = (controller.page ?? 0) / (pageCount - 1);
          }
          return Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(width: viewportWidth * progress, child: child),
          );
        },
      ),
    );
  }
}
