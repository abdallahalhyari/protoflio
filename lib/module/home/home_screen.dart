import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:profile/locale_controller.dart';

import '../../theme/tokens.dart';
import '../../theme_controller.dart';
import '../../service/sound_service.dart';
import '../../service/url_sync_service.dart';
import 'page/intro_page.dart';
import 'page/hats_grid_page.dart';
import 'page/skills_page.dart';
import 'page/projects_page.dart';
import 'page/engineering_page.dart';
import 'page/experience_page.dart';
import 'page/contact_page.dart';

import 'widget/custom_cursor.dart';
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
  bool _showScrollToTop = false;
  final FocusNode _focusNode = FocusNode();
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    final initialHash = UrlSyncService.instance.getInitialHash();
    if (initialHash != null) {
      _pageIndex = UrlSyncService.instance.hashToIndex(initialHash);
    }
    _controller = PageController(initialPage: _pageIndex);
    _controller.addListener(_onScroll);

    _mobileScrollController = ScrollController();
    _mobileScrollController.addListener(_onMobileScroll);

    UrlSyncService.instance.listenToHashChanges((hash) {
      final target = UrlSyncService.instance.hashToIndex(hash);
      if (target != _pageIndex && mounted) {
        _goTo(target, syncUrl: false);
      }
    });

    if (_pageIndex > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && MediaQuery.sizeOf(context).width < AppBreakpoints.tablet) {
          _scrollToMobileSection(_pageIndex, syncUrl: false);
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('assets/background.webp'), context);
    precacheImage(const AssetImage('assets/my_image.png'), context);
  }

  void _onScroll() {
    if (!_controller.hasClients || _controller.positions.length != 1) return;
    final page = _controller.page?.round() ?? 0;
    if (page != _pageIndex) {
      setState(() => _pageIndex = page);
      SoundService.instance.playPageTurn();
      final hash = UrlSyncService.instance.indexToHash(page);
      UrlSyncService.instance.updateHash(hash);
      final labels = TopNav.getLabels(context);
      if (page >= 0 && page < labels.length) {
        try {
          FirebaseAnalytics.instance.logScreenView(
            screenName: labels[page],
            screenClass: 'HomeScreen',
          );
        } catch (_) {
          // Firebase might not be initialized in tests
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    _mobileScrollController.removeListener(_onMobileScroll);
    _mobileScrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  double _lastMobileScrollSample = -1e9;

  void _onMobileScroll() {
    if (!_mobileScrollController.hasClients) return;
    final offset = _mobileScrollController.offset;
    final showTop = offset > 400;
    if (showTop != _showScrollToTop) {
      setState(() => _showScrollToTop = showTop);
    }

    // Section-sweep is O(N) findRenderObject + localToGlobal per call.
    // Skip until the user has scrolled at least ~10px since the last
    // sample so we're not doing that work on every wheel tick.
    if ((offset - _lastMobileScrollSample).abs() < 10) return;
    _lastMobileScrollSample = offset;

    int visibleIndex = 0;
    for (int i = 0; i < _sectionKeys.length; i++) {
      final ctx = _sectionKeys[i].currentContext;
      if (ctx != null) {
        final renderBox = ctx.findRenderObject() as RenderBox?;
        if (renderBox != null && renderBox.hasSize) {
          final pos = renderBox.localToGlobal(Offset.zero);
          if (pos.dy <= 200) {
            visibleIndex = i;
          }
        }
      }
    }
    if (visibleIndex != _pageIndex) {
      _pageIndex = visibleIndex;
      final hash = UrlSyncService.instance.indexToHash(visibleIndex);
      UrlSyncService.instance.updateHash(hash);
    }
  }

  void _scrollToMobileSection(int index, {bool syncUrl = true}) {
    final target = index.clamp(0, _pageCount - 1);
    setState(() => _pageIndex = target);
    if (syncUrl) {
      final hash = UrlSyncService.instance.indexToHash(target);
      UrlSyncService.instance.updateHash(hash);
    }
    if (target == 0 && _mobileScrollController.hasClients) {
      _mobileScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
      return;
    }
    final keyContext = _sectionKeys[target].currentContext;
    if (keyContext != null) {
      Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
        alignment: 0.0,
      );
    }
  }

  void _goTo(int page, {bool syncUrl = true}) {
    final target = page.clamp(0, _pageCount - 1);
    if (syncUrl) {
      final hash = UrlSyncService.instance.indexToHash(target);
      UrlSyncService.instance.updateHash(hash);
    }
    if (mounted && MediaQuery.sizeOf(context).width < AppBreakpoints.tablet) {
      _scrollToMobileSection(target, syncUrl: syncUrl);
      return;
    }
    if (_controller.hasClients && _controller.positions.length == 1) {
      _controller.animateToPage(
        target,
        duration: AppMotion.lg,
        curve: Curves.easeInOut,
      );
    }
  }

  void _next() {
    if (mounted && MediaQuery.sizeOf(context).width < AppBreakpoints.tablet) {
      _scrollToMobileSection(_pageIndex + 1);
    } else {
      _goTo(_pageIndex + 1);
    }
  }

  void _prev() {
    if (mounted && MediaQuery.sizeOf(context).width < AppBreakpoints.tablet) {
      _scrollToMobileSection(_pageIndex - 1);
    } else {
      _goTo(_pageIndex - 1);
    }
  }

  Future<void> _downloadResume() async {
    SoundService.instance.playClick();
    await launchUrl(Uri.parse('cv.pdf'), mode: LaunchMode.externalApplication);
  }

  // Wheel scroll — accumulate delta so a smooth trackpad flick advances
  // exactly one page per _kWheelThreshold pixels of intent, but only when
  // inner scrollable viewports (e.g. project dossier, contact page) are at their edges.
  static const double _kWheelThreshold = 80;
  static const Duration _kWheelResetGap = Duration(milliseconds: 220);
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

    // Prevent multi-page rapid jumping if a page transition is already in flight
    if (_controller.hasClients &&
        _controller.page != null &&
        (_controller.page! - _pageIndex).abs() > 0.08) {
      return;
    }

    final dy = event.scrollDelta.dy;
    if (dy.abs() < 1.0) return;

    // If an inner scrollable under the cursor can absorb this vertical scroll,
    // let Flutter's scrollable handle it and do NOT trigger a page change.
    if (_canInnerScroll(event.position, dy)) {
      _wheelAccum = 0;
      return;
    }

    final now = DateTime.now();
    if (now.difference(_lastWheelAt) > _kWheelResetGap) {
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
    return KeyEventResult.ignored;
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

    return CustomCursor(
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
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Stack(
      children: [
        Listener(
          onPointerSignal: _onPointerSignal,
          child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: _controller,
            scrollDirection: Axis.vertical,
            itemCount: 7,
            itemBuilder: (context, index) {
              final pages = [
                IntroPage(
                  onScrollDown: _next,
                  controller: _controller,
                  pageIndex: 0,
                  onViewWork: () => _goTo(1),
                  onDownloadResume: _downloadResume,
                  onContactMe: () => _goTo(6),
                ),
                ProjectsPage(controller: _controller, pageIndex: 1),
                EngineeringPage(controller: _controller, pageIndex: 2),
                ExperiencePage(controller: _controller, pageIndex: 3),
                SkillsPage(controller: _controller, pageIndex: 4),
                const HatsGridPage(),
                ContactPage(
                  controller: _controller,
                  pageIndex: 6,
                ),
              ];

              return MagazinePageTransformer(
                controller: _controller,
                index: index,
                child: pages[index],
              );
            },
          ),
        ),
        if (MediaQuery.sizeOf(context).width >= AppBreakpoints.tablet &&
            MediaQuery.sizeOf(context).height >= 340)
          Positioned(
            right: 12,
            top: 0,
            bottom: 0,
            child: Center(
              child: PageIndicator(
                count: _pageCount,
                current: _pageIndex,
                onTap: _goTo,
              ),
            ),
          ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: TopNav(
              current: _pageIndex,
              onTap: _goTo,
              onResume: _downloadResume,
            ),
          ),
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
                            icon: Icon(Icons.language, color: dark ? Colors.white : const Color(0xFF0F172A)),
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
                            color: dark ? Colors.white : const Color(0xFF0F172A),
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
                                  ? (dark ? Colors.white : const Color(0xFF0F172A))
                                  : (dark ? Colors.white.withValues(alpha: 0.60) : const Color(0xFF94A3B8)),
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
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final labels = TopNav.getLabels(context);
                final currentLabel = (_pageIndex >= 0 && _pageIndex < labels.length)
                    ? labels[_pageIndex].toUpperCase()
                    : '';
                final isDark = Theme.of(context).brightness == Brightness.dark;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.6)
                        : Colors.white.withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
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
                        'FOLIO ${(_pageIndex + 1).toString().padLeft(2, '0')} / ${_pageCount.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : const Color(0xFF64748B),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 1,
                        height: 10,
                        color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        currentLabel,
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          right: 12,
          child: SafeArea(child: _buildKeyboardHintChip(context)),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              double progress = 0.0;
              if (_controller.hasClients &&
                  _controller.positions.length == 1 &&
                  _controller.position.haveDimensions) {
                progress = (_controller.page ?? 0) / (_pageCount - 1);
              }
              return Semantics(
                label: 'Portfolio progress',
                value:
                    'Page ${_pageIndex + 1} of $_pageCount, ${(progress * 100).round()} percent',
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 3,
                    width: MediaQuery.sizeOf(context).width * progress,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Stack(
      children: [
        // Layer 1: Continuous scrollable column containing all 7 sections
        SingleChildScrollView(
          controller: _mobileScrollController,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            top: 60 + MediaQuery.paddingOf(context).top,
            bottom: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KeyedSubtree(
                key: _sectionKeys[0],
                child: IntroPage(
                  onScrollDown: () => _scrollToMobileSection(1),
                  controller: _controller,
                  pageIndex: 0,
                  onViewWork: () => _scrollToMobileSection(1),
                  onDownloadResume: _downloadResume,
                  onContactMe: () => _scrollToMobileSection(6),
                  isContinuousMobile: true,
                ),
              ),
              _buildMobileSectionDivider('02', 'SELECTED WORK'),
              KeyedSubtree(
                key: _sectionKeys[1],
                child: ProjectsPage(
                  controller: _controller,
                  pageIndex: 1,
                  isContinuousMobile: true,
                ),
              ),
              _buildMobileSectionDivider('03', 'ARCHITECTURE'),
              KeyedSubtree(
                key: _sectionKeys[2],
                child: EngineeringPage(
                  controller: _controller,
                  pageIndex: 2,
                  isContinuousMobile: true,
                ),
              ),
              _buildMobileSectionDivider('04', 'CAREER TRAJECTORY'),
              KeyedSubtree(
                key: _sectionKeys[3],
                child: ExperiencePage(
                  controller: _controller,
                  pageIndex: 3,
                  isContinuousMobile: true,
                ),
              ),
              _buildMobileSectionDivider('05', 'SKILLS & STACK'),
              KeyedSubtree(
                key: _sectionKeys[4],
                child: SkillsPage(
                  controller: _controller,
                  pageIndex: 4,
                  isContinuousMobile: true,
                ),
              ),
              _buildMobileSectionDivider('06', 'ROLES & ADVISORY'),
              KeyedSubtree(
                key: _sectionKeys[5],
                child: const HatsGridPage(isContinuousMobile: true),
              ),
              _buildMobileSectionDivider('07', 'GET IN TOUCH'),
              KeyedSubtree(
                key: _sectionKeys[6],
                child: ContactPage(
                  controller: _controller,
                  pageIndex: 6,
                  isContinuousMobile: true,
                ),
              ),
              const SizedBox(height: 48),
              _buildMobileFooter(),
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
                activeIndex: _pageIndex,
                onSelectSection: (index) => _scrollToMobileSection(index),
                onDownloadResume: _downloadResume,
              );
            },
            onLogoPressed: () => _scrollToMobileSection(0),
          ),
        ),

        // Layer 3: Floating Scroll-To-Top button
        if (_showScrollToTop)
          Positioned(
            bottom: 24,
            right: 18,
            child: _buildScrollToTopButton(),
          ),
      ],
    );
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
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.15)
                    : const Color(0xFFE2E8F0),
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
                color: Color(0xFF818CF8),
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
                  : const Color(0xFF475569),
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
                          const Color(0xFFCBD5E1),
                          const Color(0xFFE2E8F0).withValues(alpha: 0.0),
                        ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFooter() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFE2E8F0),
          ),
        ),
        color: isDark
            ? Colors.black.withValues(alpha: 0.4)
            : Colors.white.withValues(alpha: 0.7),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF38BDF8), Color(0xFF818CF8)],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'A',
                  style: TextStyle(
                    fontFamily: 'Tenada',
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'ABDALLAH AL-HYARI',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'SENIOR MOBILE ENGINEER · SYSTEM ARCHITECT',
            style: TextStyle(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.6)
                  : const Color(0xFF475569),
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '© 2026 · ALL RIGHTS RESERVED',
            style: TextStyle(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.35)
                  : const Color(0xFF94A3B8),
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyboardHintChip(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Tooltip(
      preferBelow: false,
      richMessage: TextSpan(
        style: const TextStyle(fontSize: 12, height: 1.5, color: Colors.white),
        children: const [
          TextSpan(text: 'Keyboard shortcuts\n', style: TextStyle(fontWeight: FontWeight.w900)),
          TextSpan(text: '1–7   jump to section\n'),
          TextSpan(text: '↑ ↓   prev / next page\n'),
          TextSpan(text: 'Home  first page\n'),
          TextSpan(text: 'End   last page'),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkResponse(
          radius: 22,
          onTap: () {
            SoundService.instance.playClick();
            HapticFeedback.selectionClick();
          },
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? Colors.black.withValues(alpha: 0.55)
                  : Colors.white.withValues(alpha: 0.92),
              border: Border.all(
                color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
                width: 1,
              ),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Icon(
              Icons.keyboard_alt_outlined,
              size: 16,
              color: isDark ? Colors.white70 : const Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollToTopButton() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          SoundService.instance.playClick();
          _mobileScrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
          );
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E293B).withValues(alpha: 0.9)
                : Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFF818CF8).withValues(alpha: isDark ? 0.5 : 0.4),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.4)
                    : Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.keyboard_arrow_up_rounded,
            color: isDark ? Colors.white : const Color(0xFF4F46E5),
            size: 24,
          ),
        ),
      ),
    );
  }
}
