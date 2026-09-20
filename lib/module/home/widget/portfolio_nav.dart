import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profile/l10n/app_localizations.dart';
import '../../../theme/surface_tone.dart';
import '../../../theme/tokens.dart';
import '../home_controller.dart';
import 'conditional_blur.dart';

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
    final isDark = context.isDarkMode;
    final accent = Theme.of(context).colorScheme.primary;
    final controller = HomeController.of(context);

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
                    color: accent.withValues(alpha: isDark ? 0.35 : 0.22),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? accent.withValues(alpha: 0.15)
                          : AppColors.shadowSoft,
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _EdgeFadeScroller(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ValueListenableBuilder<int>(
                        valueListenable: controller.pageIndex,
                        builder: (context, current, _) {
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
                                    controller.goTo(i);
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
                        color: isDark ? Colors.white24 : Colors.black12,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Semantics(
                        button: true,
                        label: 'Download Resume PDF',
                        child: OutlinedButton.icon(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            controller.downloadResume();
                          },
                          icon: const Icon(Icons.download_rounded, size: 14),
                          label: Text(
                            AppLocalizations.of(context)!.navResume.toUpperCase(),
                            style: const TextStyle(
                              fontSize: AppTypography.caption,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            // Resume CTA locks to the amber signature in
                            // both modes — previously the button flipped
                            // to indigo in light and read as a second
                            // brand element.
                            foregroundColor: context.resumeAccent,
                            side: BorderSide(
                              color: context.resumeBorder,
                              width: 1.2,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.pill),
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

class NavItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final accent = Theme.of(context).colorScheme.primary;

    return Semantics(
      button: true,
      selected: active,
      label: 'Go to $label',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: AnimatedContainer(
          duration: AppMotion.sm,
          curve: AppMotion.emphasized,
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.smd, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: active
                ? accent.withValues(alpha: isDark ? 0.24 : 0.14)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: active
                ? Border.all(
                    color: accent.withValues(alpha: isDark ? 0.55 : 0.40),
                    width: 1)
                : null,
            boxShadow: active
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: isDark ? 0.22 : 0.12),
                      blurRadius: 10,
                      spreadRadius: 0.5,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (active) ...[
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
              Text(
                label,
                style: TextStyle(
                  color: active
                      ? (isDark ? Colors.white : accent)
                      : (isDark ? Colors.white70 : AppColors.slate600),
                  fontSize: AppTypography.small,
                  fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
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
    final controller = HomeController.of(context);

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: ValueListenableBuilder<int>(
        valueListenable: controller.pageIndex,
        builder: (context, current, _) => Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(controller.pageCount, (i) {
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
                  controller.goTo(i);
                },
                radius: 22,
                child: Center(
                  child: AnimatedContainer(
                    duration: AppMotion.sm,
                    curve: AppMotion.emphasized,
                    width: active ? 12 : 8,
                    height: active ? 12 : 8,
                    decoration: BoxDecoration(
                      color: active
                          ? (isDark ? Colors.white : AppColors.accentIndigoDeep)
                          : (isDark ? Colors.white70 : AppColors.slate400),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? Colors.black45 : Colors.white,
                        width: 1,
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
      ),
    );
  }
}
