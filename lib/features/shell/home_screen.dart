import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';
import 'package:profile/core/bloc/theme/theme_event.dart';
import 'package:profile/service/analytics_service.dart';
import 'package:profile/service/cv_service.dart';
import 'package:profile/service/sound_service.dart';
import 'package:profile/service/url_sync_service.dart';
import 'package:profile/features/case_study/case_study_router.dart';
import 'package:profile/shared/widget/page_activity.dart';
import 'package:profile/features/intro/page/intro_page.dart';
import 'package:profile/features/hats/page/hats_grid_page.dart'
    deferred as hats_lib;
import 'package:profile/features/skills/page/skills_page.dart'
    deferred as skills_lib;
import 'package:profile/features/projects/page/projects_page.dart'
    deferred as projects_lib;
import 'package:profile/features/engineering/page/engineering_page.dart'
    deferred as engineering_lib;
import 'package:profile/features/experience/page/experience_page.dart'
    deferred as experience_lib;
import 'package:profile/features/contact/page/contact_page.dart'
    deferred as contact_lib;

import 'home_controller.dart';
import 'widget/custom_cursor.dart';
import 'widget/deferred_page.dart';
import 'widget/desktop_toolbar.dart';
import 'widget/folio_bar.dart';
import 'widget/keyboard_hint_chip.dart';
import 'widget/mobile_home_layout.dart';
import 'widget/progress_bar.dart';
import 'widget/shortcut_help_dialog.dart';
import 'widget/magazine_page_transformer.dart';
import 'widget/portfolio_nav.dart';
import 'widget/page_background.dart';
import 'widget/mobile_app_bar.dart';
import 'widget/desktop_keyboard_nav.dart';
import 'widget/desktop_scroll_interceptor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const int _pageCount = 7;

  // Hashes look like `home`, `work`, or `work/nathealth`.
  // Return the section slug (`home`, `work`, ...) or null when malformed.
  static String? _sectionFromHash(String? hash) {
    if (hash == null) return null;
    final clean = hash.replaceAll('#', '');
    if (clean.isEmpty) return null;
    return clean.split('/').first;
  }

  // Case-study slug when the hash is `work/<slug>`; otherwise null.
  static String? _slugFromHash(String? hash) {
    if (hash == null) return null;
    final parts = hash.replaceAll('#', '').split('/');
    if (parts.length < 2 || parts.first != 'work') return null;
    final slug = parts[1];
    return slug.isEmpty ? null : slug;
  }

  late final PageController _controller;
  late final ScrollController _mobileScrollController;
  final List<GlobalKey> _sectionKeys = List.generate(7, (_) => GlobalKey());
  final ValueNotifier<bool> _showScrollToTop = ValueNotifier<bool>(false);
  final FocusNode _focusNode = FocusNode();
  final ValueNotifier<int> _pageIndex = ValueNotifier<int>(0);
  bool _imagesPrecached = false;
  Timer? _settleTimer;
  // ValueNotifiers (not plain fields) so DesktopScrollInterceptor reads the
  // live value from its event handler — HomeScreen itself never calls
  // setState, so a plain field would freeze at whatever it was when
  // DesktopScrollInterceptor was last constructed.
  final ValueNotifier<bool> _isPageTransitioning = ValueNotifier<bool>(false);
  int _turnId = 0;
  void Function()? _cancelHashListener;

  late final HomeController _homeController = HomeController(
    pageIndex: _pageIndex,
    showScrollToTop: _showScrollToTop,
    pageCount: _pageCount,
    goTo: _goTo,
    next: _next,
    prev: _prev,
    scrollToMobileSection: _scrollToMobileSection,
    downloadResume: _downloadResume,
  );

  @override
  void initState() {
    super.initState();
    final initialHash = UrlSyncService.instance.getInitialHash();
    final initialSection = _sectionFromHash(initialHash);
    final initialSlug = _slugFromHash(initialHash);

    if (initialSection != null) {
      _pageIndex.value = UrlSyncService.instance.hashToIndex(initialSection);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context
            .read<ThemeBloc>()
            .add(ThemeAccentUpdatedFromHash(initialSection));
        UrlSyncService.instance.updateTitle(
          UrlSyncService.instance.titleForHash(initialHash ?? initialSection),
        );
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ThemeBloc>().add(const ThemeAccentUpdatedFromHash('home'));
        UrlSyncService.instance.updateTitle(UrlSyncService.baseTitle);
      });
    }

    // Deep-link into a case study when the URL had `#work/<slug>`.
    // Deferred until after first frame so the outer section paints
    // behind the pushed page.
    if (initialSlug != null && CaseStudyRouter.has(initialSlug)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        // Put `#work` underneath so Back closes the study onto Projects
        // instead of leaving the site.
        UrlSyncService.instance.updateHash('work');
        CaseStudyRouter.push(context, initialSlug);
      });
    }
    _controller = PageController(initialPage: _pageIndex.value);
    _controller.addListener(_onScroll);

    _mobileScrollController = ScrollController();
    _mobileScrollController.addListener(_onMobileScroll);

    _schedulePrefetch();

    _cancelHashListener = UrlSyncService.instance.listenToHashChanges((hash) {
      final section = _sectionFromHash(hash);
      final slug = _slugFromHash(hash);
      if (!mounted) return;
      UrlSyncService.instance
          .updateTitle(UrlSyncService.instance.titleForHash(hash));
      if (slug != null && CaseStudyRouter.has(slug)) {
        if (!CaseStudyRouter.isOpen(slug)) {
          CaseStudyRouter.closeFromUrl();
          CaseStudyRouter.push(context, slug, fromUrl: true);
        }
        return;
      }
      // Back (or a manual edit) moved off `#work/<slug>`.
      CaseStudyRouter.closeFromUrl();
      if (section != null) {
        final target = UrlSyncService.instance.hashToIndex(section);
        if (target != _pageIndex.value && mounted) {
          _goTo(target, syncUrl: false);
        }
      }
    });

    if (_pageIndex.value > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted &&
            MediaQuery.sizeOf(context).width < AppBreakpoints.tablet) {
          _scrollToMobileSection(_pageIndex.value, syncUrl: false);
        }
      });
    }
  }

  // Warm up deferred page bundles after first frame, in order of
  // distance from the current page. `loadLibrary` is idempotent, so
  // re-mount by `DeferredPage` costs nothing once the future resolves.
  // Skipped in test environments — the prefetch chain returns Futures
  // that don't complete synchronously and would strand the test binding.
  void _schedulePrefetch() {
    if (WidgetsBinding.instance.runtimeType.toString().contains('Test')) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final current = _pageIndex.value;
      final loaders = <(int, Future<void> Function())>[
        (1, experience_lib.loadLibrary),
        (2, projects_lib.loadLibrary),
        (3, skills_lib.loadLibrary),
        (4, engineering_lib.loadLibrary),
        (5, hats_lib.loadLibrary),
        (6, contact_lib.loadLibrary),
      ]..sort(
          (a, b) => (a.$1 - current).abs().compareTo((b.$1 - current).abs()));
      for (final entry in loaders) {
        if (!mounted) return;
        try {
          await DeferredPage.prefetch(entry.$2);
        } catch (_) {}
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_imagesPrecached) return;
    _imagesPrecached = true;
    // Defer non-critical decodes until after first frame so they don't
    // fight with Dart VM boot for main-thread time. The raster cache is
    // warm by the time IntroPage / HatsGrid / Projects actually request them.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      precacheImage(const AssetImage('assets/my_image.webp'), context);
      precacheImage(const AssetImage('assets/hat.webp'), context);
      precacheImage(
          const AssetImage('assets/images/projects/nathealth.webp'), context);
      precacheImage(
          const AssetImage('assets/images/projects/eskadenia.webp'), context);
      precacheImage(
          const AssetImage('assets/images/projects/solutions.webp'), context);
      precacheImage(
          const AssetImage('assets/images/projects/fais.webp'), context);
    });
  }

  void _scheduleSettle(int page) {
    _settleTimer?.cancel();
    _settleTimer = Timer(AppMotion.sm, () {
      if (!mounted) return;
      final hash = UrlSyncService.instance.indexToHash(page);
      // A case study owns the URL while open; replacing it would clobber
      // the `#work/<slug>` entry Back relies on.
      if (!CaseStudyRouter.hasOpen) UrlSyncService.instance.updateHash(hash);
      context.read<ThemeBloc>().add(ThemeAccentUpdatedFromHash(hash));
      final labels = TopNav.getLabels(context);
      if (page >= 0 && page < labels.length) {
        Analytics.screen(labels[page], className: 'HomeScreen');
        // This is a single-page scrollytelling app — section changes are a
        // PageView/scroll position, not a route push, so screen readers get
        // no automatic cue that content changed. Announce it explicitly.
        unawaited(SemanticsService.sendAnnouncement(
          View.of(context),
          labels[page],
          Directionality.of(context),
        ));
      }
    });
  }

  void _onScroll() {
    if (!_controller.hasClients || _controller.positions.length != 1) return;
    // Programmatic turns (`_goTo`) already published the target index,
    // accent, and settle. Tracking the rounded page mid-flight would flash
    // intermediate sections in the nav and replay the page-turn sound.
    if (_isPageTransitioning.value) return;
    final page = _controller.page?.round() ?? 0;
    if (page != _pageIndex.value) {
      _pageIndex.value = page;
      context.read<ThemeBloc>().add(ThemeAccentUpdated(page));
      SoundService.instance.playPageTurn();
      _scheduleSettle(page);
    }
  }

  @override
  void dispose() {
    _settleTimer?.cancel();
    _cancelHashListener?.call();
    _controller.removeListener(_onScroll);
    _controller.dispose();
    _mobileScrollController.removeListener(_onMobileScroll);
    _mobileScrollController.dispose();
    _showScrollToTop.dispose();
    _focusNode.dispose();
    _pageIndex.dispose();
    _isPageTransitioning.dispose();
    _lastPageTurnCompletedAt.dispose();
    super.dispose();
  }

  double _lastMobileScrollSample = -1e9;

  void _onMobileScroll() {
    if (!_mobileScrollController.hasClients) return;
    final offset = _mobileScrollController.offset;
    final showTop = offset > 400;
    if (showTop != _showScrollToTop.value) {
      _showScrollToTop.value = showTop;
    }

    // Section-sweep is O(N) findRenderObject + localToGlobal per call.
    // Skip until the user has scrolled at least ~10px since the last
    // sample so we're not doing that work on every wheel tick.
    if ((offset - _lastMobileScrollSample).abs() < 10) return;
    _lastMobileScrollSample = offset;

    const focalPoint = 180.0;
    int? visibleIndex;
    for (int i = 0; i < _sectionKeys.length; i++) {
      final ctx = _sectionKeys[i].currentContext;
      if (ctx != null && ctx.mounted) {
        final renderBox = ctx.findRenderObject() as RenderBox?;
        if (renderBox != null && renderBox.hasSize && renderBox.attached) {
          final pos = renderBox.localToGlobal(Offset.zero);
          final top = pos.dy;
          final bottom = top + renderBox.size.height;
          if (top <= focalPoint && bottom > focalPoint) {
            visibleIndex = i;
            break;
          }
        }
      }
    }
    if (visibleIndex != null && visibleIndex != _pageIndex.value) {
      _pageIndex.value = visibleIndex;
      context.read<ThemeBloc>().add(ThemeAccentUpdated(visibleIndex));
      _scheduleSettle(visibleIndex);
    }
  }

  void _scrollToMobileSection(int index, {bool syncUrl = true}) {
    final target = index.clamp(0, _pageCount - 1);
    _pageIndex.value = target;
    // Hand keys back to section navigation; a page with its own shortcuts
    // reclaims focus once it becomes active (see ActivePageFocusMixin).
    _focusNode.requestFocus();
    context.read<ThemeBloc>().add(ThemeAccentUpdated(target));
    if (syncUrl) {
      _scheduleSettle(target);
    }
    if (target == 0 && _mobileScrollController.hasClients) {
      _mobileScrollController.animateTo(
        0,
        duration: AppMotion.sectionScroll,
        curve: AppMotion.standard,
      );
      return;
    }
    _animateSectionIntoView(target);
  }

  /// Scrolls the target section top to sit *below* the sticky MobileAppBar
  /// (~60px) — plain `ensureVisible` would tuck the section title under it.
  void _animateSectionIntoView(int target, {int retry = 0}) {
    final keyContext = _sectionKeys[target].currentContext;
    // Section may be wrapped in a DeferredMount and not yet materialized
    // — bumping _pageIndex fires the mount, but the key attaches next
    // frame. Retry once via a post-frame callback so tap-from-menu jumps
    // to a section the user hasn't scrolled near still work.
    if (keyContext == null) {
      if (retry < 1 && _mobileScrollController.hasClients) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _animateSectionIntoView(target, retry: retry + 1);
        });
      }
      return;
    }
    if (!_mobileScrollController.hasClients) return;
    final box = keyContext.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || !box.attached) return;

    final currentOffset = _mobileScrollController.offset;
    // Section top in viewport coordinates.
    final topInViewport = box.localToGlobal(Offset.zero).dy;
    // Bar clearance = app bar (60) + top safe-area inset.
    final barClearance =
        MobileAppBar.kBarHeight + MediaQuery.paddingOf(context).top;
    final delta = topInViewport - barClearance;
    final targetOffset = (currentOffset + delta).clamp(
      _mobileScrollController.position.minScrollExtent,
      _mobileScrollController.position.maxScrollExtent,
    );

    _mobileScrollController.animateTo(
      targetOffset,
      duration: AppMotion.sectionScroll,
      curve: AppMotion.standard,
    );
  }

  void _goTo(int page, {bool syncUrl = true}) {
    final target = page.clamp(0, _pageCount - 1);
    if (target == _pageIndex.value) return;
    if (mounted && MediaQuery.sizeOf(context).width < AppBreakpoints.tablet) {
      _scrollToMobileSection(target, syncUrl: syncUrl);
      return;
    }

    _pageIndex.value = target;
    // Hand keys back to section navigation; a page with its own shortcuts
    // reclaims focus once it becomes active (see ActivePageFocusMixin).
    _focusNode.requestFocus();
    context.read<ThemeBloc>().add(ThemeAccentUpdated(target));
    // Settle regardless of [syncUrl]: `updateHash` is idempotent
    // (replaceState + dedupe), and settle also drives the title, analytics,
    // and the screen-reader announcement for back/forward navigation.
    _scheduleSettle(target);

    if (_controller.hasClients && _controller.positions.length == 1) {
      final wasTransitioning = _isPageTransitioning.value;
      // Raise the flag before any jump so `_onScroll` ignores it.
      _isPageTransitioning.value = true;
      final current = _controller.page?.round() ?? target;
      if (!wasTransitioning && (target - current).abs() > 1) {
        // Pre-jump to the step right before target so only 1 slide is rendered,
        // skipping unneeded mounting and layout of all intermediate pages.
        // Skipped when retargeting mid-flight — a hard cut there reads as a
        // glitch; animating on from the current fractional page is smoother.
        final preStep = target > current ? target - 1 : target + 1;
        _controller.jumpToPage(preStep);
      }
      SoundService.instance.playPageTurn();
      final turnId = ++_turnId;
      void settle() {
        // An interrupted turn completes its future early — only the latest
        // turn may clear the flag, or the wheel lock drops mid-animation.
        if (!mounted || turnId != _turnId) return;
        _isPageTransitioning.value = false;
        _lastPageTurnCompletedAt.value = DateTime.now();
      }

      _controller
          .animateToPage(
            target,
            duration: AppMotion.pageTurn,
            curve: AppMotion.emphasized,
          )
          .then((_) => settle())
          .catchError((_) => settle());
    }
  }

  void _next() => _goTo(_pageIndex.value + 1);

  void _prev() => _goTo(_pageIndex.value - 1);

  Future<void> _downloadResume() async {
    if (!mounted) return;
    await CvService.open(context);
  }

  // Wheel scroll — accumulate delta so a smooth trackpad flick advances
  // exactly one page per _kWheelThreshold pixels of intent, but only when
  // inner scrollable viewports (e.g. project dossier, contact page) are at their edges.
  final ValueNotifier<DateTime> _lastPageTurnCompletedAt =
      ValueNotifier<DateTime>(DateTime.fromMillisecondsSinceEpoch(0));

  void _showShortcutHelp() {
    if (!mounted) return;
    showShortcutHelpDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= AppBreakpoints.tablet;

    return HomeControllerScope(
      controller: _homeController,
      child: CustomCursor(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: DesktopKeyboardNav(
            focusNode: _focusNode,
            pageCount: _pageCount,
            onNext: _next,
            onPrev: _prev,
            onGoTo: (page) => _goTo(page),
            onShowHelp: _showShortcutHelp,
            child: PageBackground(
              child: isDesktop
                  ? _buildDesktopLayout(context)
                  : _buildMobileLayout(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopPage(int index) {
    switch (index) {
      case 0:
        return IntroPage(
          onScrollDown: _next,
          onViewWork: () => _goTo(2),
          onDownloadResume: _downloadResume,
          onContactMe: () => _goTo(6),
        );
      case 1:
        return DeferredPage(
          loader: experience_lib.loadLibrary,
          builder: () => experience_lib.ExperiencePage(
            controller: _controller,
            pageIndex: 1,
          ),
        );
      case 2:
        return DeferredPage(
          loader: projects_lib.loadLibrary,
          builder: () => projects_lib.ProjectsPage(),
        );
      case 3:
        return DeferredPage(
          loader: skills_lib.loadLibrary,
          builder: () => skills_lib.SkillsPage(),
        );
      case 4:
        return DeferredPage(
          loader: engineering_lib.loadLibrary,
          builder: () => engineering_lib.EngineeringPage(),
        );
      case 5:
        return DeferredPage(
          loader: hats_lib.loadLibrary,
          builder: () => hats_lib.HatsGridPage(),
        );
      case 6:
        return DeferredPage(
          loader: contact_lib.loadLibrary,
          builder: () => contact_lib.ContactPage(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return DesktopScrollInterceptor(
      pageController: _controller,
      pageIndex: _pageIndex,
      onNext: _next,
      onPrev: _prev,
      isPageTransitioning: _isPageTransitioning,
      lastPageTurnCompletedAt: _lastPageTurnCompletedAt,
      child: Stack(
        children: [
          PageView.builder(
            key: const PageStorageKey<String>('desktop_pageview'),
            physics: const NeverScrollableScrollPhysics(),
            allowImplicitScrolling: true,
            controller: _controller,
            scrollDirection: Axis.vertical,
            itemCount: _pageCount,
            itemBuilder: (context, index) {
              return MagazinePageTransformer(
                controller: _controller,
                index: index,
                // Pre-built neighbours and kept-alive pages stay mounted, so
                // only the visible page may hold keyboard focus.
                child: ValueListenableBuilder<int>(
                  valueListenable: _pageIndex,
                  builder: (context, active, page) => ExcludeFocus(
                    excluding: active != index,
                    child:
                        PageActivity(isActive: active == index, child: page!),
                  ),
                  child: RepaintBoundary(
                    key: ValueKey('desktop_page_repaint_$index'),
                    child: _buildDesktopPage(index),
                  ),
                ),
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
              child: KeyboardHintChip(onShowHelp: _showShortcutHelp),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: RepaintBoundary(
              child: PortfolioProgressBar(
                controller: _controller,
                pageCount: _pageCount,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return MobileHomeLayout(
      scrollController: _mobileScrollController,
      sectionKeys: _sectionKeys,
    );
  }
}
