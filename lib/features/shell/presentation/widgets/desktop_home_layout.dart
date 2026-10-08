import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;
import 'package:profile/features/shell/presentation/widgets/desktop_scroll_interceptor.dart';
import 'package:profile/features/shell/presentation/widgets/magazine_page_transformer.dart';
import 'package:profile/shared/widgets/page_activity.dart';
import 'package:profile/features/shell/presentation/widgets/portfolio_nav.dart';
import 'package:profile/features/shell/presentation/widgets/desktop_toolbar.dart';
import 'package:profile/features/shell/presentation/widgets/folio_bar.dart';
import 'package:profile/features/shell/presentation/widgets/keyboard_hint_chip.dart';
import 'package:profile/features/shell/presentation/widgets/progress_bar.dart';

class DesktopHomeLayout extends StatelessWidget {
  const DesktopHomeLayout({
    super.key,
    required this.controller,
    required this.pageIndex,
    required this.pageCount,
    required this.isPageTransitioning,
    required this.lastPageTurnCompletedAt,
    required this.onNext,
    required this.onPrev,
    required this.onShowHelp,
    required this.buildDesktopPage,
  });

  final PageController controller;
  final ValueNotifier<int> pageIndex;
  final int pageCount;
  final ValueNotifier<bool> isPageTransitioning;
  final ValueNotifier<DateTime> lastPageTurnCompletedAt;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final VoidCallback onShowHelp;
  final Widget Function(int index) buildDesktopPage;

  @override
  Widget build(BuildContext context) {
    return DesktopScrollInterceptor(
      onNext: onNext,
      onPrev: onPrev,
      isPageTransitioning: isPageTransitioning,
      lastPageTurnCompletedAt: lastPageTurnCompletedAt,
      child: Stack(
        children: [
          Scrollable(
            key: const PageStorageKey<String>('desktop_pageview'),
            controller: controller,
            physics: const NeverScrollableScrollPhysics(),
            viewportBuilder: (context, position) {
              return Viewport(
                offset: position,
                // Keep every page laid out (100000px) so turns never stutter.
                scrollCacheExtent: const ScrollCacheExtent.pixels(100000),
                slivers: [
                  SliverFillViewport(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return MagazinePageTransformer(
                          controller: controller,
                          index: index,
                          // Pre-built neighbours and kept-alive pages stay mounted, so
                          // only the visible page may hold keyboard focus.
                          child: ValueListenableBuilder<int>(
                            valueListenable: pageIndex,
                            builder: (context, active, page) => ExcludeFocus(
                              excluding: active != index,
                              child: PageActivity(
                                  isActive: active == index, child: page!),
                            ),
                            child: RepaintBoundary(
                              key: ValueKey('desktop_page_repaint_$index'),
                              child: buildDesktopPage(index),
                            ),
                          ),
                        );
                      },
                      childCount: pageCount,
                    ),
                  ),
                ],
              );
            },
          ),
          if (MediaQuery.sizeOf(context).height >= 340)
            const Positioned(
              right: 12,
              top: 0,
              bottom: 0,
              child: RepaintBoundary(
                child: Center(child: PageIndicator()),
              ),
            ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(child: TopNav()),
          ),
          const Positioned(
            top: 12,
            right: 12,
            child: SafeArea(
              child: RepaintBoundary(child: DesktopToolbar()),
            ),
          ),
          const Positioned(
            bottom: 12,
            left: 16,
            child: SafeArea(
              child: RepaintBoundary(child: FolioBar()),
            ),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: SafeArea(
              child: KeyboardHintChip(onShowHelp: onShowHelp),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: RepaintBoundary(
              child: PortfolioProgressBar(
                controller: controller,
                pageCount: pageCount,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
