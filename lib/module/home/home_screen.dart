import 'dart:async';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import '../../theme/tokens.dart';
import '../../util/open_url.dart';
import '../../theme_controller.dart';
import 'data/experience_data.dart';
import 'data/hats_data.dart';
import 'data/projects_data.dart';
import 'data/skills_data.dart';
import 'widget/experience_tile.dart';
import 'widget/hat_card.dart';
import 'widget/page_background.dart';
import 'widget/primary_button.dart';
import 'widget/grain_overlay.dart';
import 'widget/project_card.dart';
import 'widget/section_heading.dart';
import 'widget/site_cursor.dart';
import 'widget/skill_tile.dart';
import 'widget/stagger.dart';

/// Vertical space (px) reserved at the top of content pages so the floating
/// TopNav pill doesn't overlap section headings. Applied only on viewports
/// wide enough for the nav to render (>= 900px).
const double kTopNavReserve = 72;

double topNavPad(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= 900 ? kTopNavReserve : 0;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Single source of truth for section label KEYS + page count. Order must
  // match PageView children below. _pageCount is derived so nav + pages
  // can never drift apart. Labels resolved via easy_localization at render.
  static const List<String> _sectionLabelKeys = [
    'nav.about',
    'nav.why',
    'nav.hats',
    'nav.skills',
    'nav.projects',
    'nav.roles',
    'nav.contact',
  ];
  static final int _pageCount = _sectionLabelKeys.length;
  final PageController _controller = PageController();
  final FocusNode _focusNode = FocusNode();
  int _pageIndex = 0;
  DateTime _lastWheel = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final page = _controller.page?.round() ?? 0;
    if (page != _pageIndex) setState(() => _pageIndex = page);
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

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    final dy = event.scrollDelta.dy;
    if (dy.abs() < 4) return;
    final now = DateTime.now();
    if (now.difference(_lastWheel) < AppMotion.wheelCooldown) return;
    _lastWheel = now;
    if (dy > 0) {
      _next();
    } else {
      _prev();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SiteCursor(
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
                  _IntroPage(onScrollDown: _next),
                  _HatsIntroPage(onExplain: _next),
                  const _HatsGridPage(),
                  const _SkillsPage(),
                  const _ProjectsPage(),
                  const _ExperiencePage(),
                  const _ContactPage(),
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
                  controller: _controller,
                ),
              ),
            ),
            Positioned(
              right: 56,
              top: 0,
              bottom: 0,
              child: Center(
                child: _CurrentSectionLabel(
                  controller: _controller,
                  labelKeys: _sectionLabelKeys,
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _TopProgressBar(
                controller: _controller,
                count: _pageCount,
              ),
            ),
            if (MediaQuery.sizeOf(context).width >= 900)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: _TopNav(
                    labelKeys: _sectionLabelKeys,
                    current: _pageIndex,
                    onTap: _goTo,
                  ),
                ),
              ),
            Positioned(
              top: 12,
              right: 12,
              child: SafeArea(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _LanguageToggle(),
                    const SizedBox(width: AppSpacing.sm),
                    _ThemeToggle(),
                  ],
                ),
              ),
            ),
            const Positioned.fill(child: GrainOverlay(opacity: 0.045)),
          ],
        ),
      ),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (_, mode, __) {
        final dark = mode == ThemeMode.dark;
        return Semantics(
          toggled: dark,
          label: 'theme.label'.tr(),
          child: Material(
            color: AppColors.scrimSurface,
            shape: const CircleBorder(),
            child: IconButton(
              tooltip:
                  (dark ? 'theme.switch_to_light' : 'theme.switch_to_dark').tr(),
              focusColor: Colors.white.withValues(alpha: 0.30),
              hoverColor: Colors.white.withValues(alpha: 0.10),
              icon: Icon(
                dark ? Icons.light_mode : Icons.dark_mode,
                color: Colors.white,
              ),
              onPressed: () => ThemeController.toggle(),
            ),
          ),
        );
      },
    );
  }
}

class _LanguageToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return Semantics(
      label: 'language.label'.tr(),
      child: Material(
        color: AppColors.scrimSurface,
        shape: const CircleBorder(),
        child: IconButton(
          tooltip: 'language.toggle_tooltip'.tr(),
          focusColor: Colors.white.withValues(alpha: 0.30),
          hoverColor: Colors.white.withValues(alpha: 0.10),
          icon: Text(
            isArabic ? 'EN' : 'ع',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: AppTypography.body,
            ),
          ),
          onPressed: () {
            context.setLocale(
                isArabic ? const Locale('en') : const Locale('ar'));
          },
        ),
      ),
    );
  }
}

class _TopNav extends StatelessWidget {
  final List<String> labelKeys;
  final int current;
  final ValueChanged<int> onTap;

  const _TopNav({
    required this.labelKeys,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'a11y.section_nav'.tr(),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width - AppSpacing.xl,
          ),
          child: Container(
            margin: const EdgeInsets.only(top: AppSpacing.smd),
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.scrimSurface,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < labelKeys.length; i++)
                    _NavItem(
                      label: labelKeys[i].tr(),
                      active: current == i,
                      onTap: () => onTap(i),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
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
      label: 'a11y.goto_section'.tr(namedArgs: {'label': label}),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        focusColor: Colors.white.withValues(alpha: 0.30),
        hoverColor: Colors.white.withValues(alpha: 0.10),
        child: AnimatedContainer(
          duration: AppMotion.sm,
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.smd, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: active
                ? Colors.white.withValues(alpha: 0.25)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: active
                ? Border.all(color: Colors.white70, width: 1)
                : null,
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
  final PageController controller;

  static const double _slot = 44;

  const _PageIndicator({
    required this.count,
    required this.current,
    required this.onTap,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: _slot,
      height: _slot * count,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              // controller.page is null until first paint completes; fall
              // back to the currently-snapped page in that window.
              final page = controller.hasClients && controller.page != null
                  ? controller.page!
                  : current.toDouble();
              final clamped = page.clamp(0, count - 1);
              return Positioned(
                top: clamped * _slot + (_slot - 22) / 2,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.22),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: scheme.primary.withValues(alpha: 0.55),
                      width: 1,
                    ),
                  ),
                ),
              );
            },
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(count, (i) {
              final active = i == current;
              return Semantics(
                button: true,
                selected: active,
                label: 'a11y.goto_page'.tr(
                    namedArgs: {'n': '${i + 1}', 'total': '$count'}),
                child: SizedBox(
                  width: _slot,
                  height: _slot,
                  child: InkResponse(
                    onTap: () => onTap(i),
                    radius: 22,
                    child: Center(
                      child: AnimatedContainer(
                        duration: AppMotion.sm,
                        width: active ? 10 : 6,
                        height: active ? 10 : 6,
                        decoration: BoxDecoration(
                          color: active ? Colors.white : Colors.white70,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.black45, width: 1),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _IntroPage extends StatefulWidget {
  final VoidCallback onScrollDown;
  const _IntroPage({required this.onScrollDown});

  @override
  State<_IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<_IntroPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  );
  Offset _parallax = Offset.zero;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Respect the OS-level "reduce motion" toggle: skip the long-running
    // halo spin so we don't drain battery or trigger vestibular issues.
    if (!_started && !MediaQuery.of(context).disableAnimations) {
      _spin.repeat();
      _started = true;
    }
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width >= 800;
    final isShort = size.height < 560;
    // Cap avatar by BOTH height and shortestSide so it doesn't crowd the
    // title/CTA on short viewports; on landscape phones (< 560 tall) we
    // clamp even smaller so the whole hero fits without inner scroll.
    final maxAvatar = isShort
        ? (size.height * 0.24).clamp(48.0, 88.0)
        : (size.height * 0.28).clamp(80.0, 180.0);
    final avatarRadius =
        (size.shortestSide * 0.22).clamp(48.0, maxAvatar).toDouble();
    final titleSize =
        (size.width * 0.06).clamp(AppTypography.heading, AppTypography.heroLg);
    final subtitleSize =
        (size.width * 0.035).clamp(AppTypography.title, AppTypography.display);

    return PageBackground(
      asset: 'assets/background.webp',
      overlay: AppColors.scrimMedium,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: size.height,
                maxWidth: 900,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: isWide ? AppSpacing.xxl - 8 : AppSpacing.lg),
                  Semantics(
                    header: true,
                    label:
                        '${'intro.hello_line1'.tr()} ${'intro.hello_line2'.tr()}',
                    child: ExcludeSemantics(
                      child: DefaultTextStyle(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.1,
                          shadows: const [
                            Shadow(color: Colors.black87, blurRadius: 12),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stagger(
                              delay: const Duration(milliseconds: 120),
                              duration: const Duration(milliseconds: 700),
                              offsetY: 24,
                              child: Text('intro.hello_line1'.tr()),
                            ),
                            Stagger(
                              delay: const Duration(milliseconds: 320),
                              duration: const Duration(milliseconds: 700),
                              offsetY: 24,
                              child: Text('intro.hello_line2'.tr()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.lg),
                _AnimatedPortrait(
                  radius: avatarRadius,
                  spin: _spin,
                  parallax: _parallax,
                  onParallax: (o) => setState(() => _parallax = o),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'intro.role'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: subtitleSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: const [
                      Shadow(color: Colors.black87, blurRadius: 10),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'intro.tagline'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: (subtitleSize * 0.55)
                        .clamp(AppTypography.body, AppTypography.title),
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.85),
                    letterSpacing: 0.5,
                    shadows: const [
                      Shadow(color: Colors.black87, blurRadius: 8),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const _PlatformChips(),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                    label: 'intro.scroll_down'.tr(),
                    onPressed: widget.onScrollDown),
                if (!isShort) ...[
                  const SizedBox(height: AppSpacing.md),
                  ExcludeSemantics(
                      child: Lottie.asset('assets/arrow_white.json',
                          height: 80)),
                ],
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }
}

class _AnimatedPortrait extends StatelessWidget {
  final double radius;
  final Animation<double> spin;
  final Offset parallax;
  final ValueChanged<Offset> onParallax;

  const _AnimatedPortrait({
    required this.radius,
    required this.spin,
    required this.parallax,
    required this.onParallax,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final glowSize = radius * 2 + AppSpacing.lg;
    return Semantics(
      label: 'intro.portrait_alt'.tr(),
      image: true,
      child: MouseRegion(
        onHover: (e) {
          if (MediaQuery.of(context).disableAnimations) return;
          // Translate relative pointer offset from widget center into a small
          // parallax vector (max ~12px each axis). Non-desktop hover events
          // just don't fire, so this is a no-op on touch.
          final box = context.findRenderObject() as RenderBox?;
          if (box == null) return;
          final local = box.globalToLocal(e.position);
          final center = box.size.center(Offset.zero);
          final rel = (local - center) / box.size.longestSide;
          onParallax(Offset(rel.dx * 12, rel.dy * 12));
        },
        onExit: (_) => onParallax(Offset.zero),
        child: SizedBox(
          width: glowSize,
          height: glowSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: spin,
                builder: (context, _) {
                  return Transform.rotate(
                    angle: spin.value * 2 * 3.14159,
                    child: Container(
                      width: glowSize,
                      height: glowSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            scheme.primary.withValues(alpha: 0.0),
                            scheme.primary.withValues(alpha: 0.55),
                            scheme.primary.withValues(alpha: 0.0),
                            scheme.tertiary.withValues(alpha: 0.55),
                            scheme.primary.withValues(alpha: 0.0),
                          ],
                          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                        ),
                      ),
                    ),
                  );
                },
              ),
              AnimatedContainer(
                duration: AppMotion.md,
                curve: Curves.easeOut,
                transform:
                    Matrix4.translationValues(parallax.dx, parallax.dy, 0),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(AppSpacing.xs - 1),
                  child: CircleAvatar(
                    radius: radius,
                    backgroundColor: Colors.brown.shade300,
                    backgroundImage:
                        const AssetImage('assets/my_image.png'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlatformChips extends StatelessWidget {
  const _PlatformChips();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.smd,
      runSpacing: AppSpacing.sm,
      children: const [
        _PlatformChip(icon: Icons.flutter_dash, label: 'Flutter'),
        _PlatformChip(icon: Icons.android, label: 'Android'),
        _PlatformChip(icon: Icons.phone_iphone, label: 'iOS'),
      ],
    );
  }
}

class _PlatformChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _PlatformChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: AppTypography.title),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: AppTypography.body,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              shadows: [Shadow(color: Colors.black87, blurRadius: 6)],
            ),
          ),
        ],
      ),
    );
  }
}

class _HatsIntroPage extends StatelessWidget {
  final VoidCallback onExplain;
  const _HatsIntroPage({required this.onExplain});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final headingSize =
        (size.width * 0.055).clamp(AppTypography.heading + 2, AppTypography.hero);
    final overlineSize = (size.width * 0.028)
        .clamp(AppTypography.titleSm, AppTypography.heading + 2);

    return PageBackground(
      asset: 'assets/hats_background.webp',
      overlay: AppColors.scrimLight,
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            // Cap so ultra-wide viewports don't stretch the hero text
            // across the full canvas; still shrinks on narrow screens.
            maxWidth: (size.width / 1.3).clamp(280.0, 900.0),
            maxHeight: size.height * 0.85,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black54, Colors.black38, Colors.black26],
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.md + 2),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'hats_intro.overline'.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: overlineSize,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs + 1),
                Text(
                  'hats_intro.heading'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: headingSize,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                    label: 'hats_intro.cta'.tr(), onPressed: onExplain),
                if (size.height >= 560) ...[
                  const SizedBox(height: AppSpacing.md),
                  ExcludeSemantics(
                      child:
                          Lottie.asset('assets/arrow.json', height: 140)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HatsGridPage extends StatelessWidget {
  const _HatsGridPage();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.only(
        left: AppSpacing.sm,
        right: AppSpacing.sm,
        bottom: AppSpacing.sm,
        top: AppSpacing.sm + topNavPad(context),
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Fit all hats without inner scroll so the outer vertical
            // PageView doesn't have to fight a nested Scrollable for
            // wheel + touch drags.
            final crossAxisCount = constraints.maxWidth >= 900 ? 3 : 2;
            final rows = (kHats.length / crossAxisCount).ceil();
            const spacing = 8.0;
            final availW =
                constraints.maxWidth - (crossAxisCount - 1) * spacing;
            final availH = constraints.maxHeight - (rows - 1) * spacing;
            final cellW = availW / crossAxisCount;
            final cellH = availH / rows;
            final aspect = (cellW / cellH).clamp(0.55, 1.4);
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: kHats.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: spacing,
                crossAxisSpacing: spacing,
                childAspectRatio: aspect,
              ),
              itemBuilder: (context, i) => Stagger(
                delay: Duration(milliseconds: 70 * i),
                child: HatCard(hat: kHats[i]),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SkillsPage extends StatelessWidget {
  const _SkillsPage();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final headingSize =
        (size.width * 0.055).clamp(AppTypography.heading, AppTypography.displayLg);
    // Tuned so cards never grow wider than ~360px on ultra-wide displays.
    final cross = size.width >= 1400
        ? 4
        : size.width >= 900
            ? 3
            : size.width >= 600
                ? 2
                : 1;

    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xl + topNavPad(context),
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          child: Column(
            children: [
              SectionHeading(
                index: 3,
                total: 7,
                title: 'skills.heading'.tr(),
                titleSize: headingSize,
                color: textColor,
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: GridView.builder(
                  itemCount: kSkills.length,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cross,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    mainAxisExtent: 84,
                  ),
                  itemBuilder: (_, i) => SkillTile(
                    skill: kSkills[i],
                    delay: Duration(milliseconds: 80 * i), // staggered — keep raw
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectsPage extends StatefulWidget {
  const _ProjectsPage();

  @override
  State<_ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<_ProjectsPage> {
  final PageController _horizontal = PageController();
  int _current = 0;

  @override
  void dispose() {
    _horizontal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final headingSize =
        (size.width * 0.055).clamp(AppTypography.heading, AppTypography.displayLg);
    // Lowered from 1100 so tablet portrait (768) and iPad landscape (1024)
    // both get the 2x2 grid instead of the horizontal-swipe fallback.
    final wide = size.width >= 900;

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg + 4 + topNavPad(context),
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeading(
                index: 4,
                total: 7,
                title: 'projects.heading'.tr(),
                titleSize: headingSize,
                color: scheme.onSurface,
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Fit projects in the viewport so the inner scrollable
                    // doesn't fight the outer vertical PageView.
                    if (wide) {
                      const spacing = AppSpacing.smd;
                      const rows = 2;
                      final cellH =
                          (constraints.maxHeight - (rows - 1) * spacing) / rows;
                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: kProjects.length,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: spacing,
                          crossAxisSpacing: spacing,
                          mainAxisExtent: cellH,
                        ),
                        itemBuilder: (_, i) => Stagger(
                          delay: Duration(milliseconds: 90 * i),
                          child: ProjectCard(project: kProjects[i]),
                        ),
                      );
                    }
                    return Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: _horizontal,
                            scrollDirection: Axis.horizontal,
                            onPageChanged: (i) =>
                                setState(() => _current = i),
                            itemCount: kProjects.length,
                            itemBuilder: (_, i) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.xs),
                              child:
                                  ProjectCard(project: kProjects[i]),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _HorizontalDots(
                          count: kProjects.length,
                          current: _current,
                          onTap: (i) => _horizontal.animateToPage(
                            i,
                            duration: AppMotion.md,
                            curve: Curves.easeInOut,
                          ),
                        ),
                      ],
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

class _HorizontalDots extends StatelessWidget {
  final int count;
  final int current;
  final ValueChanged<int> onTap;

  const _HorizontalDots({
    required this.count,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return Semantics(
          button: true,
          selected: active,
          label: 'Go to project ${i + 1} of $count',
          child: SizedBox(
            width: 32,
            height: 32,
            child: InkResponse(
              onTap: () => onTap(i),
              radius: 16,
              child: Center(
                child: AnimatedContainer(
                  duration: AppMotion.sm,
                  width: active ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active
                        ? scheme.primary
                        : scheme.onSurface.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
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

class _ExperiencePage extends StatelessWidget {
  const _ExperiencePage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final headingSize =
        (size.width * 0.055).clamp(AppTypography.heading, AppTypography.displayLg);
    final isWide = size.width >= 900;

    final expList = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < kExperience.length; i++)
          Stagger(
            delay: Duration(milliseconds: 80 * i),
            child: ExperienceTile(
              exp: kExperience[i],
              isFirst: i == 0,
              isLast: i == kExperience.length - 1,
            ),
          ),
      ],
    );

    final eduSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'experience.education'.tr(),
          style: TextStyle(
            color: scheme.onSurface,
            fontSize: AppTypography.title,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.smd),
        ...kEducation.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.mdx),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.degree,
                  style: TextStyle(
                    fontSize: AppTypography.bodyMd,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                Text(
                  '${e.institution} · ${e.period}',
                  style: TextStyle(
                    fontSize: AppTypography.small,
                    color: scheme.primary,
                  ),
                ),
                if (e.note != null)
                  Text(
                    e.note!,
                    style: TextStyle(
                      fontSize: AppTypography.caption,
                      color: scheme.onSurface.withValues(alpha: 0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg - 4),
        Text(
          'experience.certifications'.tr(),
          style: TextStyle(
            color: scheme.onSurface,
            fontSize: AppTypography.title,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.sm + 2),
        ...kCertifications.map(
          (c) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.smx),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.smx),
                  child: Icon(Icons.verified,
                      size: 14, color: scheme.primary),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    c,
                    style: TextStyle(
                      fontSize: AppTypography.small,
                      color: scheme.onSurface.withValues(alpha: 0.85),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg + 4 + topNavPad(context),
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeading(
                index: 5,
                total: 7,
                title: 'experience.heading'.tr(),
                titleSize: headingSize,
                color: scheme.onSurface,
              ),
              const SizedBox(height: AppSpacing.lg - 4),
              Expanded(
                child: SingleChildScrollView(
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: expList),
                            const SizedBox(width: AppSpacing.xl + 8),
                            Expanded(flex: 2, child: eduSection),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            expList,
                            const SizedBox(height: AppSpacing.lg - 4),
                            eduSection,
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactPage extends StatelessWidget {
  const _ContactPage();

  Future<void> _open(BuildContext context, String url) => openUrl(context, url);

  Future<void> _copy(BuildContext context, String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    final msg = 'contact.copied'.tr(namedArgs: {'value': value});
    // ignore: deprecated_member_use
    SemanticsService.announce(msg, ui.TextDirection.ltr);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: AppMotion.snack),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final headingSize =
        (size.width * 0.055).clamp(AppTypography.heading, AppTypography.hero);
    final rowSize =
        (size.width * 0.035).clamp(AppTypography.bodyLg, AppTypography.head + 6);

    return PageBackground(
      asset: 'assets/hats_background.webp',
      overlay: AppColors.scrimHeavy,
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: (size.width / 1.15).clamp(280.0, 720.0),
            maxHeight: size.height * 0.9,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black26, Colors.black38, Colors.black54],
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.md + 2),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const _AvailabilityChip(),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'contact.heading'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: headingSize,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'contact.hint'.tr(),
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize:
                        (rowSize * 0.55).clamp(AppTypography.micro, AppTypography.bodyLg),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _ContactRow(
                  icon: Icons.mail_outline,
                  label: 'contact.email'.tr(),
                  value: 'alhyariabdallh@gmail.com',
                  onTap: () =>
                      _open(context, 'mailto:alhyariabdallh@gmail.com'),
                  onLongPress: () =>
                      _copy(context, 'alhyariabdallh@gmail.com'),
                  fontSize: rowSize,
                ),
                const SizedBox(height: AppSpacing.md),
                _ContactRow(
                  icon: Icons.phone_outlined,
                  label: 'contact.phone'.tr(),
                  value: '+962-787032264',
                  onTap: () => _open(context, 'tel:+962787032264'),
                  onLongPress: () => _copy(context, '+962787032264'),
                  fontSize: rowSize,
                ),
                const SizedBox(height: AppSpacing.md),
                _ContactRow(
                  icon: Icons.link,
                  label: 'contact.linkedin'.tr(),
                  value: 'abdallah-alhyari',
                  onTap: () => _open(context,
                      'https://www.linkedin.com/in/abdallah-alhyari-95b915201/'),
                  onLongPress: () => _copy(
                      context,
                      'https://www.linkedin.com/in/abdallah-alhyari-95b915201/'),
                  fontSize: rowSize,
                  linkStyle: true,
                ),
                const SizedBox(height: AppSpacing.xl),
                Semantics(
                  label: 'contact.download_cv_semantic'.tr(),
                  button: true,
                  child: PrimaryButton(
                    label: 'contact.download_cv'.tr(),
                    onPressed: () => _open(context, 'cv.pdf'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactRow extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final double fontSize;
  final bool linkStyle;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    required this.fontSize,
    this.onLongPress,
    this.linkStyle = false,
  });

  @override
  State<_ContactRow> createState() => _ContactRowState();
}

class _ContactRowState extends State<_ContactRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: AppMotion.chip,
  );
  bool _showCopied = false;

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _flash({bool asCopy = false}) {
    _pulse.forward(from: 0);
    if (asCopy) {
      setState(() => _showCopied = true);
      Future.delayed(AppMotion.toast, () {
        if (mounted) setState(() => _showCopied = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final labelSize =
        (widget.fontSize * 0.5).clamp(AppTypography.caption, AppTypography.body);
    return Semantics(
      label: '${widget.label} ${widget.value}',
      button: true,
      child: InkWell(
        onTap: () {
          widget.onTap();
          _flash();
        },
        onLongPress: widget.onLongPress == null
            ? null
            : () {
                widget.onLongPress!();
                _flash(asCopy: true);
              },
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: AnimatedBuilder(
          animation: _pulse,
          builder: (context, child) {
            final t = 1 - _pulse.value;
            return DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                color: scheme.primary.withValues(alpha: 0.35 * t),
                border: Border.all(
                  color: scheme.primary.withValues(alpha: 0.6 * t),
                  width: 1,
                ),
              ),
              child: child,
            );
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.smd),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ExcludeSemantics(
                  child: Icon(widget.icon,
                      color: Colors.white, size: widget.fontSize * 1.1),
                ),
                const SizedBox(width: AppSpacing.md),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.label,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: labelSize,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                              shadows: const [
                                Shadow(color: Colors.black87, blurRadius: 4),
                              ],
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: AppMotion.sm,
                            child: _showCopied
                                ? Padding(
                                    key: const ValueKey('copied'),
                                    padding: const EdgeInsets.only(
                                        left: AppSpacing.sm),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: AppSpacing.sm,
                                          vertical: 2),
                                      decoration: BoxDecoration(
                                        color: scheme.primary
                                            .withValues(alpha: 0.9),
                                        borderRadius: BorderRadius.circular(
                                            AppRadius.pill),
                                      ),
                                      child: Text(
                                        'contact.copied_chip'.tr(),
                                        style: TextStyle(
                                          color: scheme.onPrimary,
                                          fontSize: AppTypography.micro,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(
                                    key: ValueKey('empty'), width: 0),
                          ),
                        ],
                      ),
                      Text(
                        widget.value,
                        style: TextStyle(
                          color: widget.linkStyle
                              ? AppColors.linkOnScrim
                              : Colors.white,
                          decoration: widget.linkStyle
                              ? TextDecoration.underline
                              : TextDecoration.none,
                          decorationColor: Colors.white,
                          fontSize: widget.fontSize,
                          fontWeight: FontWeight.bold,
                          shadows: const [
                            Shadow(color: Colors.black87, blurRadius: 6),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }
}

/// "Open for roles · Brno 2027" pill shown above the contact heading.
/// Green outline, pulsing dot on the left; pulse disables when the OS
/// "reduce motion" setting is on.
class _AvailabilityChip extends StatefulWidget {
  const _AvailabilityChip();

  @override
  State<_AvailabilityChip> createState() => _AvailabilityChipState();
}

class _AvailabilityChipState extends State<_AvailabilityChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started && !MediaQuery.of(context).disableAnimations) {
      _pulse.repeat(reverse: true);
      _started = true;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF22C55E);
    return Semantics(
      label: 'contact.availability_a11y'.tr(),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.smd, vertical: AppSpacing.smx),
        decoration: BoxDecoration(
          color: green.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: green.withValues(alpha: 0.55), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _pulse,
              builder: (_, __) {
                final t = _pulse.value;
                return SizedBox(
                  width: 12,
                  height: 12,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 8 + 4 * t,
                        height: 8 + 4 * t,
                        decoration: BoxDecoration(
                          color: green.withValues(alpha: 0.35 * (1 - t)),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'contact.availability'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: AppTypography.micro,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Thin primary progress bar at the top edge of the viewport that fills
/// as the outer PageView scrolls between sections (0 -> pageCount-1).
class _TopProgressBar extends StatelessWidget {
  final PageController controller;
  final int count;
  const _TopProgressBar({required this.controller, required this.count});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 2,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final page =
              controller.hasClients && controller.page != null
                  ? controller.page!
                  : 0.0;
          final t = (count > 1 ? page / (count - 1) : 0.0).clamp(0.0, 1.0);
          return Row(
            children: [
              Expanded(
                flex: (t * 1000).round().clamp(0, 1000),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: scheme.primary),
                ),
              ),
              Expanded(
                flex: 1000 - (t * 1000).round().clamp(0, 1000),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.12),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Small floating label next to the right-edge page indicator that fades
/// in while the PageView is scrolling and fades out ~900ms after the
/// last movement, showing the label of the section currently under the
/// scroll offset.
class _CurrentSectionLabel extends StatefulWidget {
  final PageController controller;
  final List<String> labelKeys;
  const _CurrentSectionLabel({
    required this.controller,
    required this.labelKeys,
  });

  @override
  State<_CurrentSectionLabel> createState() => _CurrentSectionLabelState();
}

class _CurrentSectionLabelState extends State<_CurrentSectionLabel> {
  Timer? _idle;
  bool _visible = false;
  double _lastPage = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    _idle?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (!widget.controller.hasClients) return;
    final page = widget.controller.page ?? 0;
    if ((page - _lastPage).abs() < 0.005) return;
    _lastPage = page;
    if (!_visible) setState(() => _visible = true);
    _idle?.cancel();
    _idle = Timer(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _visible = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final page = widget.controller.hasClients &&
                widget.controller.page != null
            ? widget.controller.page!
            : 0.0;
        final idx = page
            .round()
            .clamp(0, widget.labelKeys.length - 1);
        return AnimatedOpacity(
          duration: AppMotion.sm,
          curve: Curves.easeOut,
          opacity: _visible ? 1 : 0,
          child: IgnorePointer(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.smd, vertical: AppSpacing.smx),
              decoration: BoxDecoration(
                color: AppColors.scrimSurface,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: Colors.white24, width: 1),
              ),
              child: Text(
                widget.labelKeys[idx].tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppTypography.micro,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.6,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
