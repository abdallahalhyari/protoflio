import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../../theme/tokens.dart';
import '../../theme_controller.dart';
import '../../service/analytics_service.dart';
import '../../service/cv_service.dart';
import '../../service/sound_service.dart';
import '../../service/url_sync_service.dart';
import 'page/intro_page.dart';
import 'page/hats_grid_page.dart' deferred as hats_lib;
import 'page/skills_page.dart' deferred as skills_lib;
import 'page/projects_page.dart' deferred as projects_lib;
import 'page/engineering_page.dart' deferred as engineering_lib;
import 'page/experience_page.dart' deferred as experience_lib;
import 'page/contact_page.dart' deferred as contact_lib;

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const int _pageCount = 7;
  late final PageController _controller;
  late final ScrollController _mobileScrollController;
  final List<GlobalKey> _sectionKeys = List.generate(7, (_) => GlobalKey());
  final ValueNotifier<bool> _showScrollToTop = ValueNotifier<bool>(false);
  final FocusNode _focusNode = FocusNode();
  final ValueNotifier<int> _pageIndex = ValueNotifier<int>(0);
  bool _imagesPrecached = false;
  Timer? _settleTimer;
  bool _isPageTransitioning = false;
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
    if (initialHash != null) {
      _pageIndex.value = UrlSyncService.instance.hashToIndex(initialHash);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ThemeController.updateSeedFromHash(initialHash);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ThemeController.updateSeedFromHash('home');
      });
    }
    _controller = PageController(initialPage: _pageIndex.value);
    _controller.addListener(_onScroll);

    _mobileScrollController = ScrollController();
    _mobileScrollController.addListener(_onMobileScroll);

    _schedulePrefetch();

    _cancelHashListener = UrlSyncService.instance.listenToHashChanges((hash) {
      final target = UrlSyncService.instance.hashToIndex(hash);
      if (target != _pageIndex.value && mounted) {
        _goTo(target, syncUrl: false);
      }
    });

    if (_pageIndex.value > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && MediaQuery.sizeOf(context).width < AppBreakpoints.tablet) {
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
      ]..sort((a, b) =>
          (a.$1 - current).abs().compareTo((b.$1 - current).abs()));
      for (final entry in loaders) {
        if (!mounted) return;
        try {
          await entry.$2();
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
    // fight with Dart VM boot for main-thread time.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      precacheImage(const AssetImage('assets/background.webp'), context);
      precacheImage(const AssetImage('assets/my_image.webp'), context);
      precacheImage(const AssetImage('assets/hat.webp'), context);
    });
  }

  void _scheduleSettle(int page) {
    _settleTimer?.cancel();
    _settleTimer = Timer(const Duration(milliseconds: 250), () {
      if (!mounted) return;
      final hash = UrlSyncService.instance.indexToHash(page);
      UrlSyncService.instance.updateHash(hash);
      ThemeController.updateSeedFromHash(hash);
      final labels = TopNav.getLabels(context);
      if (page >= 0 && page < labels.length) {
        Analytics.screen(labels[page], className: 'HomeScreen');
      }
    });
  }

  void _onScroll() {
    if (!_controller.hasClients || _controller.positions.length != 1) return;
    final page = _controller.page?.round() ?? 0;
    if (page != _pageIndex.value) {
      _pageIndex.value = page;
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
      _scheduleSettle(visibleIndex);
    }
  }

  void _scrollToMobileSection(int index, {bool syncUrl = true}) {
    final target = index.clamp(0, _pageCount - 1);
    _pageIndex.value = target;
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
    final barClearance = MobileAppBar.kBarHeight +
        MediaQuery.paddingOf(context).top;
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
    if (target == _pageIndex.value && !_isPageTransitioning) return;
    if (syncUrl) {
      _scheduleSettle(target);
    }
    if (mounted && MediaQuery.sizeOf(context).width < AppBreakpoints.tablet) {
      _scrollToMobileSection(target, syncUrl: syncUrl);
      return;
    }

    if (mounted && target != _pageIndex.value) {
      _pageIndex.value = target;
    }

    if (_controller.hasClients && _controller.positions.length == 1) {
      final current = _controller.page?.round() ?? _pageIndex.value;
      if ((target - current).abs() > 1) {
        // Pre-jump to the step right before target so only 1 slide is rendered,
        // skipping unneeded mounting and layout of all intermediate pages.
        final preStep = target > current ? target - 1 : target + 1;
        _controller.jumpToPage(preStep);
      }
      _isPageTransitioning = true;
      _controller.animateToPage(
        target,
        duration: AppMotion.pageTurn,
        curve: AppMotion.emphasized,
      ).then((_) {
        if (mounted) {
          _isPageTransitioning = false;
          _wheelAccum = 0;
        }
      }).catchError((_) {
        if (mounted) _isPageTransitioning = false;
      });
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
  static const double _kWheelThreshold = 80;
  double _wheelAccum = 0;
  DateTime _lastWheelAt = DateTime.fromMillisecondsSinceEpoch(0);

  bool _canInnerScroll(Offset globalPosition, double dy) {
    if (!mounted) return false;

    // Fast-path: On desktop, Experience (1), Skills (3), Engineering (4),
    // and Hats (5) have no vertical inner scrollables. Bypass expensive
    // hit-testing and parent ascension completely.
    final current = _pageIndex.value;
    if (current == 1 || current == 3 || current == 4 || current == 5) {
      return false;
    }

    final result = HitTestResult();
    final viewId = View.of(context).viewId;
    RendererBinding.instance.hitTestInView(result, globalPosition, viewId);

    for (final entry in result.path) {
      final target = entry.target;
      if (target is! RenderObject) continue;

      RenderObject? current = target;
      while (current != null) {
        if (current is RenderAbstractViewport) {
          ViewportOffset? offset;
          if (current is RenderViewportBase) {
            offset = current.offset;
          } else {
            try {
              offset = (current as dynamic).offset as ViewportOffset?;
            } catch (_) {}
          }

          if (offset != null) {
            // If this viewport is the outer PageView, stop ascending this branch
            if (_controller.hasClients && offset == _controller.position) {
              break;
            }

            if (offset is ScrollPosition) {
              final pos = offset;
              if (pos.axis == Axis.vertical &&
                  pos.hasContentDimensions &&
                  pos.maxScrollExtent > 0) {
                if (dy > 0) {
                  // Scrolling down: can inner scroll further down?
                  if (pos.pixels < pos.maxScrollExtent - 2.0) {
                    return true;
                  }
                } else if (dy < 0) {
                  // Scrolling up: can inner scroll further up?
                  if (pos.pixels > pos.minScrollExtent + 2.0) {
                    return true;
                  }
                }
              }
            }
          }
        }
        current = current.parent;
      }
    }
    return false;
  }

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;

    // Drop further wheel events while a transition animation is actively in flight
    if (_isPageTransitioning) return;

    final dy = event.scrollDelta.dy;
    if (dy.abs() < 1.0) return;

    if (_canInnerScroll(event.position, dy)) {
      _wheelAccum = 0;
      return;
    }

    final now = DateTime.now();
    if (now.difference(_lastWheelAt) > AppMotion.wheelResetGap) {
      _wheelAccum = 0;
    }
    _lastWheelAt = now;
    _wheelAccum += dy;

    if (_wheelAccum >= _kWheelThreshold) {
      _wheelAccum = 0;
      _next();
    } else if (_wheelAccum <= -_kWheelThreshold) {
      _wheelAccum = 0;
      _prev();
    }
  }

  KeyEventResult _handleKey(FocusNode _, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final k = event.logicalKey;
    if (k == LogicalKeyboardKey.arrowDown ||
        k == LogicalKeyboardKey.pageDown ||
        k == LogicalKeyboardKey.space) {
      _next();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowUp || k == LogicalKeyboardKey.pageUp) {
      _prev();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.home) {
      _goTo(0);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.end) {
      _goTo(_pageCount - 1);
      return KeyEventResult.handled;
    }
    final digit = _digitKeyToIndex(k);
    if (digit != null) {
      _goTo(digit);
      return KeyEventResult.handled;
    }
    // "?" (Shift+/) or Slash — open the keyboard shortcut modal so
    // discoverability isn't limited to the tiny bottom-right hint chip.
    if (k == LogicalKeyboardKey.question || k == LogicalKeyboardKey.slash) {
      _showShortcutHelp();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _showShortcutHelp() {
    if (!mounted) return;
    showShortcutHelpDialog(context);
  }

  int? _digitKeyToIndex(LogicalKeyboardKey k) {
    final id = k.keyId;
    final digitBase = LogicalKeyboardKey.digit1.keyId;
    if (id >= digitBase && id < digitBase + _pageCount) return id - digitBase;
    final numBase = LogicalKeyboardKey.numpad1.keyId;
    if (id >= numBase && id < numBase + _pageCount) return id - numBase;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= AppBreakpoints.tablet;

    return HomeControllerScope(
      controller: _homeController,
      child: CustomCursor(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Focus(
            focusNode: _focusNode,
            autofocus: true,
            onKeyEvent: _handleKey,
            child: PageBackground(
              asset: 'assets/background.webp',
              overlay: AppColors.scrimMedium,
              child: isDesktop ? _buildDesktopLayout(context) : _buildMobileLayout(context),
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
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerSignal: _onPointerSignal,
      child: Stack(
        children: [
          PageView.builder(
            key: const PageStorageKey<String>('desktop_pageview'),
            physics: const NeverScrollableScrollPhysics(),
            controller: _controller,
            scrollDirection: Axis.vertical,
            itemCount: _pageCount,
            itemBuilder: (context, index) {
              return MagazinePageTransformer(
                controller: _controller,
                index: index,
                child: RepaintBoundary(
                  key: ValueKey('desktop_page_repaint_$index'),
                  child: _buildDesktopPage(index),
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
            child: SafeArea(child: DesktopToolbar()),
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
