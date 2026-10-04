import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;

import 'package:profile/core/services/cv_service.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/contact/presentation/pages/contact_page.dart'
    deferred as contact_lib;
import 'package:profile/features/engineering/presentation/pages/engineering_page.dart'
    deferred as engineering_lib;
import 'package:profile/features/experience/presentation/pages/experience_page.dart'
    deferred as experience_lib;
import 'package:profile/features/hats/presentation/pages/hats_grid_page.dart'
    deferred as hats_lib;
import 'package:profile/features/intro/presentation/pages/intro_page.dart';
import 'package:profile/features/projects/presentation/pages/projects_page.dart'
    deferred as projects_lib;
import 'package:profile/features/skills/presentation/pages/skills_page.dart'
    deferred as skills_lib;
import 'package:profile/features/shell/presentation/controllers/home_controller.dart';
import 'package:profile/features/shell/presentation/widgets/deferred_mount.dart';
import 'package:profile/features/shell/presentation/widgets/deferred_page.dart';
import 'package:profile/features/shell/presentation/widgets/mobile_app_bar.dart';
import 'package:profile/features/shell/presentation/widgets/mobile_footer.dart';
import 'package:profile/features/shell/presentation/widgets/mobile_nav_sheet.dart';
import 'package:profile/features/shell/presentation/widgets/mobile_pager.dart';
import 'package:profile/features/shell/presentation/widgets/mobile_progress_rail.dart';
import 'package:profile/features/shell/presentation/widgets/mobile_section_divider.dart';
import 'package:profile/features/shell/presentation/widgets/portfolio_nav.dart'
    show TopNav;
import 'package:profile/features/shell/presentation/widgets/scroll_to_top_button.dart';

/// Mobile continuous-scroll layout for the portfolio. Owns the Stack
/// with the scrollable section column + 5 positioned overlay layers
/// (app bar, scroll-to-top, progress rail, pager). Reads
/// `pageIndex`, `showScrollToTop`, and nav intents from [HomeController].
class MobileHomeLayout extends StatelessWidget {
  const MobileHomeLayout({
    super.key,
    required this.scrollController,
    required this.sectionKeys,
  });

  final ScrollController scrollController;
  final List<GlobalKey> sectionKeys;

  static String _dividerLabel(List<String> labels, int index) {
    if (index < 0 || index >= labels.length) return '';
    return labels[index].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.of(context);
    final labels = TopNav.getLabels(context);
    return Stack(
      children: [
        // Layer 1: Continuous scrollable column containing all 7 sections
        ListView(
          key: const PageStorageKey<String>('mobile_scrollview'),
          controller: scrollController,
          // Lay out all seven top-level slots so every section key has a
          // position for menu/hash jumps. Far sections are 720px
          // DeferredMount placeholders, so this stays cheap.
          scrollCacheExtent: const ScrollCacheExtent.pixels(100000),
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            top: 60 + MediaQuery.paddingOf(context).top,
            bottom: 80 + MediaQuery.paddingOf(context).bottom,
          ),
          children: [
            RepaintBoundary(
              child: KeyedSubtree(
                key: sectionKeys[0],
                child: IntroPage(
                  onScrollDown: () => controller.scrollToMobileSection(1),
                  onViewWork: () => controller.scrollToMobileSection(2),
                  onDownloadResume: () => CvService.open(context),
                  onContactMe: () => controller.scrollToMobileSection(6),
                  isContinuousMobile: true,
                ),
              ),
            ),
            MobileSectionDivider(number: '02', title: _dividerLabel(labels, 1)),
            // Key outside DeferredMount: the jump target must exist (and
            // have a position) even while the section is a placeholder.
            KeyedSubtree(
              key: sectionKeys[1],
              child: DeferredMount(
                sectionIndex: 1,
                placeholderHeight: 720,
                // Build the section ahead of the reader right away and the
                // rest once the intro has settled, one per frame, instead of
                // all seven while a phone is still loading the page.
                distance: 1,
                mountWhenIdleAfter: AppMotion.idleMount,
                child: RepaintBoundary(
                  child: DeferredPage(
                    // Top to bottom, one per frame: the first frame shows the
                    // cover instead of waiting for every section to build.
                    mountPriority: 1,
                    loader: experience_lib.loadLibrary,
                    builder: () =>
                        experience_lib.ExperiencePage(isContinuousMobile: true),
                  ),
                ),
              ),
            ),
            MobileSectionDivider(number: '03', title: _dividerLabel(labels, 2)),
            KeyedSubtree(
              key: sectionKeys[2],
              child: DeferredMount(
                sectionIndex: 2,
                placeholderHeight: 720,
                distance: 1,
                mountWhenIdleAfter: AppMotion.idleMount,
                child: RepaintBoundary(
                  child: DeferredPage(
                    mountPriority: 2,
                    loader: projects_lib.loadLibrary,
                    builder: () =>
                        projects_lib.ProjectsPage(isContinuousMobile: true),
                  ),
                ),
              ),
            ),
            MobileSectionDivider(number: '04', title: _dividerLabel(labels, 3)),
            KeyedSubtree(
              key: sectionKeys[3],
              child: DeferredMount(
                sectionIndex: 3,
                placeholderHeight: 720,
                distance: 1,
                mountWhenIdleAfter: AppMotion.idleMount,
                child: RepaintBoundary(
                  child: DeferredPage(
                    mountPriority: 3,
                    loader: skills_lib.loadLibrary,
                    builder: () =>
                        skills_lib.SkillsPage(isContinuousMobile: true),
                  ),
                ),
              ),
            ),
            MobileSectionDivider(number: '05', title: _dividerLabel(labels, 4)),
            KeyedSubtree(
              key: sectionKeys[4],
              child: DeferredMount(
                sectionIndex: 4,
                placeholderHeight: 720,
                distance: 1,
                mountWhenIdleAfter: AppMotion.idleMount,
                child: RepaintBoundary(
                  child: DeferredPage(
                    mountPriority: 4,
                    loader: engineering_lib.loadLibrary,
                    builder: () => engineering_lib.EngineeringPage(
                        isContinuousMobile: true),
                  ),
                ),
              ),
            ),
            MobileSectionDivider(number: '06', title: _dividerLabel(labels, 5)),
            KeyedSubtree(
              key: sectionKeys[5],
              child: DeferredMount(
                sectionIndex: 5,
                placeholderHeight: 720,
                distance: 1,
                mountWhenIdleAfter: AppMotion.idleMount,
                child: RepaintBoundary(
                  child: DeferredPage(
                    mountPriority: 5,
                    loader: hats_lib.loadLibrary,
                    builder: () =>
                        hats_lib.HatsGridPage(isContinuousMobile: true),
                  ),
                ),
              ),
            ),
            MobileSectionDivider(number: '07', title: _dividerLabel(labels, 6)),
            KeyedSubtree(
              key: sectionKeys[6],
              child: DeferredMount(
                sectionIndex: 6,
                placeholderHeight: 720,
                distance: 1,
                mountWhenIdleAfter: AppMotion.idleMount,
                child: RepaintBoundary(
                  child: DeferredPage(
                    mountPriority: 6,
                    loader: contact_lib.loadLibrary,
                    builder: () =>
                        contact_lib.ContactPage(isContinuousMobile: true),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
            const MobileFooter(),
          ],
        ),

        // Layer 2: Sticky frosted-glass MobileAppBar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: MobileAppBar(
            onMenuPressed: () {
              MobileNavSheet.show(
                context,
                activeIndex: controller.pageIndex.value,
                onSelectSection: controller.scrollToMobileSection,
                onDownloadResume: () => CvService.open(context),
              );
            },
            onLogoPressed: () => controller.scrollToMobileSection(0),
          ),
        ),

        // Layer 3: Bottom scrim — fades the scrolling content out behind
        // the pager pill and scroll-to-top button, so body copy doesn't
        // read half-covered on either side of them.
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 96 + MediaQuery.paddingOf(context).bottom,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context)
                        .scaffoldBackgroundColor
                        .withValues(alpha: 0.0),
                    Theme.of(context)
                        .scaffoldBackgroundColor
                        .withValues(alpha: 0.92),
                  ],
                  stops: const [0.0, 0.55],
                ),
              ),
            ),
          ),
        ),

        // Layer 4: Floating Scroll-To-Top button
        Positioned(
          bottom: 24,
          right: 18,
          child: ValueListenableBuilder<bool>(
            valueListenable: controller.showScrollToTop,
            builder: (context, showScrollToTop, _) {
              if (!showScrollToTop) return const SizedBox.shrink();
              return ScrollToTopButton(
                onPressed: () => scrollController.animateTo(
                  0,
                  duration: AppMotion.sectionScroll,
                  curve: AppMotion.emphasized,
                ),
              );
            },
          ),
        ),

        // Layer 5: Vertical progress rail — tap any dot to jump.
        const Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          child: Center(child: MobileProgressRail()),
        ),

        // Layer 6: Prev / Next floating pager — one-tap section skip
        // without opening the menu sheet.
        Positioned(
          left: 0,
          right: 0,
          bottom: 20 + MediaQuery.paddingOf(context).bottom,
          child: const Center(child: MobilePager()),
        ),
      ],
    );
  }
}
