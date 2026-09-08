import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/locale_controller.dart';

import '../../theme/tokens.dart';
import '../../theme_controller.dart';
import 'page/intro_page.dart';
import 'page/hats_intro_page.dart';
import 'page/hats_grid_page.dart';
import 'page/skills_page.dart';
import 'page/projects_page.dart';
import 'page/experience_page.dart';
import 'page/contact_page.dart';

import 'widget/custom_cursor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const int _pageCount = 7;
  final PageController _controller = PageController();
  final FocusNode _focusNode = FocusNode();
  int _pageIndex = 0;
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final page = _controller.page?.round() ?? 0;
    if (page != _pageIndex) {
      setState(() => _pageIndex = page);
      final labels = _TopNav.getLabels(context);
      if (page >= 0 && page < labels.length) {
        FirebaseAnalytics.instance.logScreenView(
          screenName: labels[page],
          screenClass: 'HomeScreen',
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    _controller.animateToPage(
      page.clamp(0, _pageCount - 1),
      duration: AppMotion.lg,
      curve: Curves.easeInOut,
    );
  }

  void _next() => _goTo(_pageIndex + 1);
  void _prev() => _goTo(_pageIndex - 1);

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      if (_isScrolling) return;

      if (event.scrollDelta.dy > 0) {
        _next();
      } else if (event.scrollDelta.dy < 0) {
        _prev();
      }

      _isScrolling = true;
      Future.delayed(AppMotion.sm).then((_) {
        if (mounted) {
          _isScrolling = false;
        }
      });
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
    return CustomCursor(
      child: Scaffold(
        body: Focus(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _handleKey,
        child: Stack(
          children: [
            Listener(
              onPointerSignal: _onPointerSignal,
              child: PageView(
                controller: _controller,
                scrollDirection: Axis.vertical,
                children: [
                  IntroPage(
                    onScrollDown: _next,
                    controller: _controller,
                    pageIndex: 0,
                  ),
                  HatsIntroPage(
                    onExplain: _next,
                    controller: _controller,
                    pageIndex: 1,
                  ),
                  const HatsGridPage(),
                  const SkillsPage(),
                  const ProjectsPage(),
                  const ExperiencePage(),
                  ContactPage(
                    controller: _controller,
                    pageIndex: 6,
                  ),
                ],
              ),
            ),
            Positioned(
              right: 12,
              top: 0,
              bottom: 0,
              child: Center(
                child: _PageIndicator(
                  count: _pageCount,
                  current: _pageIndex,
                  onTap: _goTo,
                ),
              ),
            ),
            if (MediaQuery.sizeOf(context).width >= 900)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: _TopNav(
                    current: _pageIndex,
                    onTap: _goTo,
                  ),
                ),
              )
            else
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: _MobileNav(
                    current: _pageIndex,
                    onTap: _goTo,
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
                          color: Colors.black45,
                          shape: const CircleBorder(),
                          child: ValueListenableBuilder<Locale>(
                            valueListenable: LocaleController.locale,
                            builder: (context, locale, _) {
                              return PopupMenuButton<String>(
                                tooltip: 'Change Language',
                                icon: const Icon(Icons.language, color: Colors.white),
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
                            }
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Semantics(
                          toggled: dark,
                          label: 'Dark mode',
                          child: Material(
                            color: Colors.black45,
                            shape: const CircleBorder(),
                            child: IconButton(
                              tooltip: dark ? 'Switch to light' : 'Switch to dark',
                              icon: Icon(
                                dark ? Icons.light_mode : Icons.dark_mode,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                ThemeController.toggle();
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  double progress = 0.0;
                  if (_controller.hasClients && _controller.position.haveDimensions) {
                    progress = (_controller.page ?? 0) / (_pageCount - 1);
                  }
                  return Align(
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
                          )
                        ]
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class _TopNav extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;

  static List<String> getLabels(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.navAbout,
      l.navWhy,
      l.navHats,
      l.navSkills,
      l.navProjects,
      l.navExperience,
      l.navContact,
    ];
  }

  const _TopNav({required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Section navigation',
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width - AppSpacing.xl,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                margin: const EdgeInsets.only(top: AppSpacing.smd),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                  for (var i = 0; i < getLabels(context).length; i++)
                      _NavItem(
                        label: getLabels(context)[i],
                        active: current == i,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          onTap(i);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}

class _MobileNav extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;

  const _MobileNav({required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width - AppSpacing.lg),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: Colors.white24, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _iconBtn(0, Icons.person, _TopNav.getLabels(context)[0], onTap, current, context),
                    _iconBtn(1, Icons.lightbulb, _TopNav.getLabels(context)[1], onTap, current, context),
                    _iconBtn(2, Icons.style, _TopNav.getLabels(context)[2], onTap, current, context),
                    _iconBtn(3, Icons.code, _TopNav.getLabels(context)[3], onTap, current, context),
                    _iconBtn(4, Icons.work, _TopNav.getLabels(context)[4], onTap, current, context),
                    _iconBtn(5, Icons.timeline, _TopNav.getLabels(context)[5], onTap, current, context),
                    _iconBtn(6, Icons.mail, _TopNav.getLabels(context)[6], onTap, current, context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconBtn(int idx, IconData icon, String tooltip, ValueChanged<int> onTap, int current, BuildContext context) {
    final active = current == idx;
    return IconButton(
      icon: Icon(icon, color: active ? Theme.of(context).colorScheme.primary : Colors.white70),
      onPressed: () { HapticFeedback.selectionClick(); onTap(idx); },
      tooltip: tooltip,
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      label: 'Go to $label',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: AnimatedContainer(
          duration: AppMotion.sm,
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.smd, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: active
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppTypography.small,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int count;
  final int current;
  final ValueChanged<int> onTap;

  const _PageIndicator({
    required this.count,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final labels = _TopNav.getLabels(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
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
              onTap: () {
                HapticFeedback.selectionClick();
                onTap(i);
              },
              radius: 22,
              child: Center(
                child: AnimatedContainer(
                  duration: AppMotion.sm,
                  width: active ? 12 : 8,
                  height: active ? 12 : 8,
                  decoration: BoxDecoration(
                    color: active ? Colors.white : Colors.white70,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black45, width: 1),
                  ),
                ),
              ),
            ),
          ),
          ),
        );
      }),
    );
  }
}
