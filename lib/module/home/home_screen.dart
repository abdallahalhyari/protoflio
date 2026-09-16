import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/locale_controller.dart';

import '../../theme/tokens.dart';
import '../../theme_controller.dart';
import '../../service/analytics_service.dart';
import '../../service/cv_service.dart';
import '../../service/sound_service.dart';
import '../../service/url_sync_service.dart';
import 'page/intro_page.dart';
import 'page/hats_grid_page.dart';
import 'page/skills_page.dart';
import 'page/projects_page.dart';
import 'page/engineering_page.dart';
import 'page/experience_page.dart';
import 'page/contact_page.dart';

import 'home_controller.dart';
import 'widget/custom_cursor.dart';
import 'widget/deferred_mount.dart';
import 'widget/directional_icon.dart';
import 'widget/keyboard_hint_chip.dart';
import 'widget/mobile_footer.dart';
import 'widget/scroll_to_top_button.dart';
import 'widget/magazine_page_transformer.dart';
import 'widget/portfolio_nav.dart';
import 'widget/page_background.dart';
import 'widget/mobile_app_bar.dart';
import 'widget/mobile_nav_sheet.dart';

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

    UrlSyncService.instance.listenToHashChanges((hash) {
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_imagesPrecached) return;
    _imagesPrecached = true;
    precacheImage(const AssetImage('assets/background.webp'), context);
    precacheImage(const AssetImage('assets/my_image.png'), context);
    precacheImage(const AssetImage('assets/hat.png'), context);
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
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.keyboard_alt_outlined,
                          size: 22, color: scheme.primary),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          l10n.keyboardHintTitle,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        tooltip: l10n.closeTooltip,
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.smd),
                  _shortcutRow(scheme, '1–7', l10n.keyboardHintDigits),
                  _shortcutRow(scheme, '↑ ↓', l10n.keyboardHintArrows),
                  _shortcutRow(scheme, 'Home', l10n.keyboardHintHome),
                  _shortcutRow(scheme, 'End', l10n.keyboardHintEnd),
                  _shortcutRow(scheme, '?', l10n.showHelpShortcut),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _shortcutRow(ColorScheme scheme, String key, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 56,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.chip),
              border: Border.all(
                color: scheme.primary.withValues(alpha: 0.35),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              key,
              style: TextStyle(
                fontFamily: 'Courier',
                color: scheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: scheme.onSurface.withValues(alpha: 0.85),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
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
        return ExperiencePage(
          controller: _controller,
          pageIndex: 1,
        );
      case 2:
        return const ProjectsPage();
      case 3:
        return const SkillsPage();
      case 4:
        return const EngineeringPage();
      case 5:
        return const HatsGridPage();
      case 6:
        return const ContactPage();
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
              child: Center(child: PageIndicator()),
            ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(child: TopNav()),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: SafeArea(
              child: ValueListenableBuilder<ThemeMode>(
                valueListenable: ThemeController.mode,
                builder: (_, mode, __) {
                  final dark = mode == ThemeMode.dark;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Material(
                        color: dark ? Colors.black45 : Colors.white.withValues(alpha: 0.9),
                        elevation: dark ? 0 : 2,
                        shadowColor: Colors.black12,
                        shape: const CircleBorder(),
                        child: ValueListenableBuilder<Locale>(
                          valueListenable: LocaleController.locale,
                          builder: (context, locale, _) {
                            return PopupMenuButton<String>(
                              tooltip: 'Change Language',
                              icon: Icon(Icons.language, color: dark ? Colors.white : AppColors.slate900),
                              onSelected: (val) {
                                HapticFeedback.lightImpact();
                                LocaleController.changeLocale(val);
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(value: 'en', child: Text('English')),
                                PopupMenuItem(value: 'ar', child: Text('العربية')),
                                PopupMenuItem(value: 'cs', child: Text('Čeština')),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Semantics(
                        toggled: dark,
                        label: 'Dark mode',
                        child: Material(
                          color: dark ? Colors.black45 : Colors.white.withValues(alpha: 0.9),
                          elevation: dark ? 0 : 2,
                          shadowColor: Colors.black12,
                          shape: const CircleBorder(),
                          child: IconButton(
                            tooltip: dark ? 'Switch to light' : 'Switch to dark',
                            icon: Icon(
                              dark ? Icons.light_mode : Icons.dark_mode,
                              color: dark ? Colors.white : AppColors.slate900,
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              SoundService.instance.playClick();
                              ThemeController.toggle();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      ValueListenableBuilder<bool>(
                        valueListenable: SoundService.instance.isEnabled,
                        builder: (context, enabled, _) {
                          return Material(
                            color: dark ? Colors.black45 : Colors.white.withValues(alpha: 0.9),
                            elevation: dark ? 0 : 2,
                            shadowColor: Colors.black12,
                            shape: const CircleBorder(),
                            child: IconButton(
                              tooltip: enabled ? 'Mute ambient audio' : 'Enable ambient audio',
                              icon: Icon(
                                enabled ? Icons.volume_up : Icons.volume_off,
                                color: enabled
                                    ? (dark ? Colors.white : AppColors.slate900)
                                    : (dark ? Colors.white.withValues(alpha: 0.60) : AppColors.slate400),
                                size: 18,
                              ),
                              onPressed: () {
                                SoundService.instance.toggle();
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 16,
            child: SafeArea(
              child: RepaintBoundary(
                child: ValueListenableBuilder<int>(
                  valueListenable: _pageIndex,
                  builder: (context, page, __) => _buildFolioBar(context, page),
                ),
              ),
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
              child: ValueListenableBuilder<int>(
                valueListenable: _pageIndex,
                builder: (context, page, __) => _buildProgressBar(context, page),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Stack(
      children: [
        // Layer 1: Continuous scrollable column containing all 7 sections
        SingleChildScrollView(
          key: const PageStorageKey<String>('mobile_scrollview'),
          controller: _mobileScrollController,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            top: 60 + MediaQuery.paddingOf(context).top,
            bottom: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RepaintBoundary(
                child: KeyedSubtree(
                  key: _sectionKeys[0],
                  child: IntroPage(
                    onScrollDown: () => _scrollToMobileSection(1),
                    onViewWork: () => _scrollToMobileSection(2),
                    onDownloadResume: _downloadResume,
                    onContactMe: () => _scrollToMobileSection(6),
                    isContinuousMobile: true,
                  ),
                ),
              ),
              _buildMobileSectionDivider('02', _dividerLabelFor(1)),
              DeferredMount(
                sectionIndex: 1,
                placeholderHeight: 720,
                child: RepaintBoundary(
                  child: KeyedSubtree(
                    key: _sectionKeys[1],
                    child: const ExperiencePage(isContinuousMobile: true),
                  ),
                ),
              ),
              _buildMobileSectionDivider('03', _dividerLabelFor(2)),
              DeferredMount(
                sectionIndex: 2,
                placeholderHeight: 720,
                child: RepaintBoundary(
                  child: KeyedSubtree(
                    key: _sectionKeys[2],
                    child: const ProjectsPage(isContinuousMobile: true),
                  ),
                ),
              ),
              _buildMobileSectionDivider('04', _dividerLabelFor(3)),
              DeferredMount(
                sectionIndex: 3,
                placeholderHeight: 720,
                child: RepaintBoundary(
                  child: KeyedSubtree(
                    key: _sectionKeys[3],
                    child: const SkillsPage(isContinuousMobile: true),
                  ),
                ),
              ),
              _buildMobileSectionDivider('05', _dividerLabelFor(4)),
              DeferredMount(
                sectionIndex: 4,
                placeholderHeight: 720,
                child: RepaintBoundary(
                  child: KeyedSubtree(
                    key: _sectionKeys[4],
                    child: const EngineeringPage(isContinuousMobile: true),
                  ),
                ),
              ),
              _buildMobileSectionDivider('06', _dividerLabelFor(5)),
              DeferredMount(
                sectionIndex: 5,
                placeholderHeight: 720,
                child: RepaintBoundary(
                  child: KeyedSubtree(
                    key: _sectionKeys[5],
                    child: const HatsGridPage(isContinuousMobile: true),
                  ),
                ),
              ),
              _buildMobileSectionDivider('07', _dividerLabelFor(6)),
              DeferredMount(
                sectionIndex: 6,
                placeholderHeight: 720,
                child: RepaintBoundary(
                  child: KeyedSubtree(
                    key: _sectionKeys[6],
                    child: const ContactPage(isContinuousMobile: true),
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
                activeIndex: _pageIndex.value,
                onSelectSection: (index) => _scrollToMobileSection(index),
                onDownloadResume: _downloadResume,
              );
            },
            onLogoPressed: () => _scrollToMobileSection(0),
          ),
        ),

        // Layer 3: Floating Scroll-To-Top button
        Positioned(
          bottom: 24,
          right: 18,
          child: ValueListenableBuilder<bool>(
            valueListenable: _showScrollToTop,
            builder: (context, show, child) {
              if (!show) return const SizedBox.shrink();
              return ScrollToTopButton(
                onPressed: () => _mobileScrollController.animateTo(
                  0,
                  duration: AppMotion.sectionScroll,
                  curve: AppMotion.emphasized,
                ),
              );
            },
          ),
        ),

        // Layer 4: Vertical progress rail — tap any dot to jump.
        Positioned(
          top: 0,
          bottom: 0,
          right: 4,
          child: Center(
            child: ValueListenableBuilder<int>(
              valueListenable: _pageIndex,
              builder: (context, page, __) => _buildMobileProgressRail(context, page),
            ),
          ),
        ),

        // Layer 5: Prev / Next floating pager — one-tap section skip
        // without opening the menu sheet.
        Positioned(
          left: 0,
          right: 0,
          bottom: 20 + MediaQuery.paddingOf(context).bottom,
          child: Center(
            child: ValueListenableBuilder<int>(
              valueListenable: _pageIndex,
              builder: (context, page, __) => _buildMobilePager(context, page),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobilePager(BuildContext context, int page) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canPrev = page > 0;
    final canNext = page < _pageCount - 1;

    Widget iconButton({
      required IconData icon,
      required String label,
      required VoidCallback? onTap,
    }) {
      return Semantics(
        button: true,
        enabled: onTap != null,
        label: label,
        child: Tooltip(
          message: label,
          child: InkResponse(
            radius: 22,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: DirIcon(
                icon,
                size: 18,
                color: onTap == null
                    ? (isDark ? Colors.white24 : AppColors.slate300)
                    : (isDark ? Colors.white : AppColors.slate700),
              ),
            ),
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.black.withValues(alpha: 0.55)
              : Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.14)
                : AppColors.slate200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconButton(
              icon: Icons.chevron_left_rounded,
              label: 'Previous section',
              onTap: canPrev ? () => _scrollToMobileSection(page - 1) : null,
            ),
            const SizedBox(width: 6),
            Text(
              '${(page + 1).toString().padLeft(2, '0')} / ${_pageCount.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: isDark ? Colors.white70 : AppColors.slate600,
              ),
            ),
            const SizedBox(width: 6),
            iconButton(
              icon: Icons.chevron_right_rounded,
              label: 'Next section',
              onTap: canNext ? () => _scrollToMobileSection(page + 1) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileProgressRail(BuildContext context, int page) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < _pageCount; i++)
            Semantics(
              button: true,
              selected: i == page,
              label: i < labels.length ? 'Go to ${labels[i]}' : 'Go to page ${i + 1}',
              child: InkResponse(
                radius: 14,
                onTap: () => _scrollToMobileSection(i),
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
    );
  }

  /// Returns the localized nav label for `index` uppercased, used as the
  /// mobile continuous-scroll section divider title so those labels are
  /// automatically translated (en / ar / cs) with the rest of the nav.
  String _dividerLabelFor(int index) {
    final labels = TopNav.getLabels(context);
    if (index < 0 || index >= labels.length) return '';
    return labels[index].toUpperCase();
  }

  Widget _buildMobileSectionDivider(String number, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.xs),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.15)
                    : AppColors.slate200,
              ),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
            ),
            child: Text(
              number,
              style: const TextStyle(
                color: AppColors.accentIndigo,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.55)
                  : AppColors.slate600,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          Colors.white.withValues(alpha: 0.25),
                          Colors.white.withValues(alpha: 0.02),
                        ]
                      : [
                          AppColors.slate300,
                          AppColors.slate200.withValues(alpha: 0.0),
                        ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolioBar(BuildContext context, int page) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labels = TopNav.getLabels(context);
    final currentLabel = (page >= 0 && page < labels.length)
        ? labels[page].toUpperCase()
        : '';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withValues(alpha: 0.6)
            : Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(AppRadius.xs),
        border: Border.all(
          color: isDark ? Colors.white12 : AppColors.slate200,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.folioIndicator(
              (page + 1).toString().padLeft(2, '0'),
              _pageCount.toString().padLeft(2, '0'),
            ),
            style: TextStyle(
              color: isDark ? Colors.white70 : AppColors.slate500,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 1,
            height: 10,
            color: isDark ? Colors.white24 : AppColors.slate300,
          ),
          const SizedBox(width: 8),
          Text(
            currentLabel,
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.slate900,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  /// Top-edge progress bar. Only the width animates every scroll frame,
  /// so `Align` + decorated `Container` are cached via the AnimatedBuilder
  /// `child:` parameter and wrapped in a RepaintBoundary by the caller.
  Widget _buildProgressBar(BuildContext context, int page) {
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
      value: 'Page ${page + 1} of $_pageCount',
      child: AnimatedBuilder(
        animation: _controller,
        child: decoratedBar,
        builder: (context, child) {
          double progress = 0.0;
          if (_controller.hasClients &&
              _controller.positions.length == 1 &&
              _controller.position.haveDimensions) {
            progress = (_controller.page ?? 0) / (_pageCount - 1);
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
