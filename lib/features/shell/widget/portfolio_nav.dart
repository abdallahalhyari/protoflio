import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/core/bloc/navigation/navigation_bloc.dart';
import 'package:profile/service/cv_service.dart';
import 'package:profile/shared/widget/conditional_blur.dart';
import '../home_controller.dart';

class TopNav extends StatelessWidget {
  static List<String> getLabels(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.navHome,
      l.navExperience,
      l.navWork,
      l.navStack,
      l.navEngineering,
      l.navAbout,
      l.navContact,
    ];
  }

  const TopNav({super.key});

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final current =
        context.select((NavigationBloc bloc) => bloc.state.pageIndex);

    final width = MediaQuery.sizeOf(context).width;
    // On desktop viewports (>= tablet), reserve clearance for the top-right
    // DesktopToolbar (~140px + 12px margin = ~152px) on both sides so the
    // centered nav pill never collides with toolbar pucks on mid-size screens.
    final horizontalReserve =
        width >= AppBreakpoints.tablet ? 320.0 : AppSpacing.xl;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Section navigation',
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: math.max(0.0, width - horizontalReserve),
          ),
          child: RepaintBoundary(
            child: ConditionalBlur(
              sigma: 12,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: Container(
                margin: const EdgeInsets.only(top: AppSpacing.smd),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: context.glassSurface,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: context.navSurfaceBorder(accent),
                    width: 1,
                  ),
                  boxShadow: context.ambientGlow(accent),
                ),
                child: _EdgeFadeScroller(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Builder(
                        builder: (context) {
                          final labels = getLabels(context);
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (var i = 0; i < labels.length; i++)
                                NavItem(
                                  label: labels[i],
                                  active: current == i,
                                  onTap: () {
                                    if (i == current) return;
                                    HapticFeedback.selectionClick();
                                    HomeController.of(context).goTo(i);
                                  },
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        width: 1,
                        height: 18,
                        color: context.navDivider,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Semantics(
                        button: true,
                        label: 'Download Resume PDF',
                        child: OutlinedButton.icon(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            CvService.open(context);
                          },
                          icon: const Icon(Icons.download_rounded, size: 14),
                          label: Text(
                            AppLocalizations.of(context)!
                                .navResume
                                .toUpperCase(),
                            style: const TextStyle(
                              fontSize: AppTypography.caption,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: context.resumeAccent,
                            side: BorderSide(
                              color: context.resumeBorder,
                              width: 1.2,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.pill),
                            ),
                          ),
                        ),
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

class NavItem extends StatefulWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final accent = Theme.of(context).colorScheme.primary;
    final hovered = _isHovered && !widget.active;

    return Semantics(
      button: true,
      selected: widget.active,
      label: 'Go to ${widget.label}',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: AnimatedScale(
            scale: hovered ? 1.05 : (widget.active ? 1.02 : 1.0),
            duration: AppMotion.chipHover,
            curve: AppMotion.emphasized,
            child: AnimatedContainer(
              duration: widget.active ? AppMotion.sm : AppMotion.chipHover,
              curve: AppMotion.emphasized,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.smd, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: widget.active
                    ? context.activeChipSurface(accent)
                    : hovered
                        ? context.hoverChipSurface(accent)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: widget.active
                    ? Border.all(
                        color: context.activeChipBorder(accent), width: 1)
                    : null,
                boxShadow: widget.active
                    ? context.activeChipShadow(accent)
                    : hovered
                        ? context.hoverChipShadow(accent)
                        : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.active) ...[
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? Colors.white : accent,
                        boxShadow: [
                          BoxShadow(
                            color: accent.withValues(alpha: 0.8),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                  AnimatedDefaultTextStyle(
                    duration: AppMotion.chipHover,
                    style: TextStyle(
                      color: widget.active
                          ? (isDark ? Colors.white : accent)
                          : hovered
                              ? (isDark
                                  ? Colors.white.withValues(alpha: 0.92)
                                  : AppColors.slate800)
                              : (context.mutedText),
                      fontSize: AppTypography.small,
                      fontWeight:
                          widget.active ? FontWeight.w800 : FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                    child: Text(widget.label),
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

/// Horizontal scroller with a left/right gradient mask that appears only
/// when the child actually overflows. Signals to keyboard/mouse users that
/// the TopNav has more items off-screen on narrow desktops.
class _EdgeFadeScroller extends StatefulWidget {
  const _EdgeFadeScroller({required this.child});
  final Widget child;

  @override
  State<_EdgeFadeScroller> createState() => _EdgeFadeScrollerState();
}

class _EdgeFadeScrollerState extends State<_EdgeFadeScroller> {
  final ScrollController _controller = ScrollController();
  bool _fadeLeft = false;
  bool _fadeRight = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_recompute);
    WidgetsBinding.instance.addPostFrameCallback((_) => _recompute());
  }

  @override
  void dispose() {
    _controller.removeListener(_recompute);
    _controller.dispose();
    super.dispose();
  }

  void _recompute() {
    if (!_controller.hasClients) return;
    final pos = _controller.position;
    final left = pos.pixels > 2;
    final right = pos.pixels < pos.maxScrollExtent - 2;
    if (left != _fadeLeft || right != _fadeRight) {
      setState(() {
        _fadeLeft = left;
        _fadeRight = right;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scroller = SingleChildScrollView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      child: widget.child,
    );

    if (!_fadeLeft && !_fadeRight) return scroller;

    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: const [
            Colors.transparent,
            Colors.black,
            Colors.black,
            Colors.transparent,
          ],
          stops: [
            0.0,
            _fadeLeft ? 0.05 : 0.0,
            _fadeRight ? 0.95 : 1.0,
            1.0,
          ],
        ).createShader(rect);
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (_) {
          _recompute();
          return false;
        },
        child: scroller,
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final labels = TopNav.getLabels(context);
    final current =
        context.select((NavigationBloc bloc) => bloc.state.pageIndex);
    final pageCount =
        context.select((NavigationBloc bloc) => bloc.state.pageCount);

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(pageCount, (i) {
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
                    if (active) return;
                    HapticFeedback.selectionClick();
                    HomeController.of(context).goTo(i);
                  },
                  radius: 22,
                  child: Center(
                    child: _HoverScale(
                      child: AnimatedContainer(
                        duration: AppMotion.sm,
                        curve: AppMotion.emphasized,
                        width: active ? 12 : 8,
                        height: active ? 12 : 8,
                        decoration: BoxDecoration(
                          color: active
                              ? (isDark
                                  ? Colors.white
                                  : AppColors.accentIndigoDeep)
                              : (isDark ? Colors.white70 : AppColors.slate400),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? Colors.black45 : Colors.white,
                            width: 1,
                          ),
                          boxShadow: active
                              ? [
                                  BoxShadow(
                                    color: (isDark
                                            ? Colors.white
                                            : AppColors.accentIndigoDeep)
                                        .withValues(alpha: 0.5),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  )
                                ]
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _HoverScale extends StatefulWidget {
  final Widget child;
  const _HoverScale({required this.child});

  @override
  State<_HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<_HoverScale> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.3 : 1.0,
        duration: AppMotion.sm,
        curve: AppMotion.emphasized,
        child: widget.child,
      ),
    );
  }
}
