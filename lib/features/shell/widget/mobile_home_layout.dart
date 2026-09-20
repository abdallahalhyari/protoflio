import 'package:flutter/material.dart';

import 'package:profile/theme/tokens.dart';
import '../home_controller.dart';
import 'package:profile/features/contact/page/contact_page.dart' deferred as contact_lib;
import 'package:profile/features/engineering/page/engineering_page.dart' deferred as engineering_lib;
import 'package:profile/features/experience/page/experience_page.dart' deferred as experience_lib;
import 'package:profile/features/hats/page/hats_grid_page.dart' deferred as hats_lib;
import 'package:profile/features/intro/page/intro_page.dart';
import 'package:profile/features/projects/page/projects_page.dart' deferred as projects_lib;
import 'package:profile/features/skills/page/skills_page.dart' deferred as skills_lib;
import 'deferred_mount.dart';
import 'deferred_page.dart';
import 'mobile_app_bar.dart';
import 'mobile_footer.dart';
import 'mobile_nav_sheet.dart';
import 'mobile_pager.dart';
import 'mobile_progress_rail.dart';
import 'mobile_section_divider.dart';
import 'portfolio_nav.dart' show TopNav;
import 'scroll_to_top_button.dart';

/// Mobile continuous-scroll layout for the portfolio. Owns the Stack
/// with the scrollable section column + 5 positioned overlay layers
/// (app bar, scroll-to-top, progress rail, pager). Reads
/// `pageIndex`, `showScrollToTop`, and nav intents from the ambient
/// [HomeController].
///
/// `_HomeScreenState` retains ownership of the [ScrollController] and
/// [GlobalKey] list so the section-sweep in `_onMobileScroll` and the
/// jump animator can measure section positions.
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
        SingleChildScrollView(
          key: const PageStorageKey<String>('mobile_scrollview'),
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            top: 60 + MediaQuery.paddingOf(context).top,
            bottom: 80 + MediaQuery.paddingOf(context).bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RepaintBoundary(
                child: KeyedSubtree(
                  key: sectionKeys[0],
                  child: IntroPage(
                    onScrollDown: () => controller.scrollToMobileSection(1),
                    onViewWork: () => controller.scrollToMobileSection(2),
                    onDownloadResume: controller.downloadResume,
                    onContactMe: () => controller.scrollToMobileSection(6),
                    isContinuousMobile: true,
                  ),
                ),
              ),
              MobileSectionDivider(
                  number: '02', title: _dividerLabel(labels, 1)),
              DeferredMount(
                sectionIndex: 1,
                placeholderHeight: 720,
                child: RepaintBoundary(
                  child: KeyedSubtree(
                    key: sectionKeys[1],
                    child: DeferredPage(
                      loader: experience_lib.loadLibrary,
                      builder: () => experience_lib.ExperiencePage(
                          isContinuousMobile: true),
                    ),
                  ),
                ),
              ),
              MobileSectionDivider(
                  number: '03', title: _dividerLabel(labels, 2)),
              DeferredMount(
                sectionIndex: 2,
                placeholderHeight: 720,
                child: RepaintBoundary(
                  child: KeyedSubtree(
                    key: sectionKeys[2],
                    child: DeferredPage(
                      loader: projects_lib.loadLibrary,
                      builder: () => projects_lib.ProjectsPage(
                          isContinuousMobile: true),
                    ),
                  ),
                ),
              ),
              MobileSectionDivider(
                  number: '04', title: _dividerLabel(labels, 3)),
              DeferredMount(
                sectionIndex: 3,
                placeholderHeight: 720,
                child: RepaintBoundary(
                  child: KeyedSubtree(
                    key: sectionKeys[3],
                    child: DeferredPage(
                      loader: skills_lib.loadLibrary,
                      builder: () => skills_lib.SkillsPage(
                          isContinuousMobile: true),
                    ),
                  ),
                ),
              ),
              MobileSectionDivider(
                  number: '05', title: _dividerLabel(labels, 4)),
              DeferredMount(
                sectionIndex: 4,
                placeholderHeight: 720,
                child: RepaintBoundary(
                  child: KeyedSubtree(
                    key: sectionKeys[4],
                    child: DeferredPage(
                      loader: engineering_lib.loadLibrary,
                      builder: () => engineering_lib.EngineeringPage(
                          isContinuousMobile: true),
                    ),
                  ),
                ),
              ),
              MobileSectionDivider(
                  number: '06', title: _dividerLabel(labels, 5)),
              DeferredMount(
                sectionIndex: 5,
                placeholderHeight: 720,
                child: RepaintBoundary(
                  child: KeyedSubtree(
                    key: sectionKeys[5],
                    child: DeferredPage(
                      loader: hats_lib.loadLibrary,
                      builder: () => hats_lib.HatsGridPage(
                          isContinuousMobile: true),
                    ),
                  ),
                ),
              ),
              MobileSectionDivider(
                  number: '07', title: _dividerLabel(labels, 6)),
              DeferredMount(
                sectionIndex: 6,
                placeholderHeight: 720,
                child: RepaintBoundary(
                  child: KeyedSubtree(
                    key: sectionKeys[6],
                    child: DeferredPage(
                      loader: contact_lib.loadLibrary,
                      builder: () => contact_lib.ContactPage(
                          isContinuousMobile: true),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              const MobileFooter(),
            ],
          ),
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
                onDownloadResume: controller.downloadResume,
              );
            },
            onLogoPressed: () => controller.scrollToMobileSection(0),
          ),
        ),

        // Layer 3: Floating Scroll-To-Top button
        Positioned(
          bottom: 24,
          right: 18,
          child: ValueListenableBuilder<bool>(
            valueListenable: controller.showScrollToTop,
            builder: (context, show, child) {
              if (!show) return const SizedBox.shrink();
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

        // Layer 4: Vertical progress rail — tap any dot to jump.
        const Positioned(
          top: 0,
          bottom: 0,
          right: 4,
          child: Center(child: MobileProgressRail()),
        ),

        // Layer 5: Prev / Next floating pager — one-tap section skip
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
