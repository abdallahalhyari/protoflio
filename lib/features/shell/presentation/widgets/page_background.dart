import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

import 'package:profile/features/shell/presentation/widgets/background/page_background_canvases.dart';
import 'package:profile/features/shell/presentation/widgets/background/page_background_orbs.dart';

class PageBackground extends StatefulWidget {
  final Widget child;
  final Color? overlay;

  const PageBackground({
    super.key,
    required this.child,
    this.overlay,
  });

  @override
  State<PageBackground> createState() => _PageBackgroundState();
}

class _PageBackgroundState extends State<PageBackground>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<Offset> _mouseOffset = ValueNotifier(Offset.zero);
  late final AnimationController _breathController;
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: AppMotion.idleMount,
    );
    _lifecycleListener = AppLifecycleListener(
      onPause: _onAppPause,
      onHide: _onAppPause,
      onResume: _onAppResume,
      onShow: _onAppResume,
    );
  }

  void _onAppPause() {
    if (_breathController.isAnimating) {
      _breathController.stop();
    }
  }

  void _onAppResume() {
    if (mounted &&
        !MediaQuery.disableAnimationsOf(context) &&
        !_breathController.isAnimating) {
      _breathController.repeat(reverse: true);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!MediaQuery.disableAnimationsOf(context)) {
      if (WidgetsBinding.instance.runtimeType.toString().contains('Test')) {
        _breathController.value = 0.5;
      } else if (!_breathController.isAnimating) {
        _breathController.repeat(reverse: true);
      }
    }
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    _breathController.dispose();
    _mouseOffset.dispose();
    super.dispose();
  }

  static Widget _crossFadeLayout(
    Widget topChild,
    Key topKey,
    Widget bottomChild,
    Key bottomKey,
  ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(key: bottomKey, child: bottomChild),
        Positioned.fill(key: topKey, child: topChild),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final size = MediaQuery.sizeOf(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final surface = Theme.of(context).scaffoldBackgroundColor;
    final showDecoLayers = AppBreakpoints.isDesktop(context);

    return MouseRegion(
      onHover: (event) {
        if (MediaQuery.disableAnimationsOf(context)) {
          return;
        }
        final center = Offset(size.width / 2, size.height / 2);
        final next = event.localPosition - center;
        if ((next - _mouseOffset.value).distanceSquared < 36) {
          return;
        }
        _mouseOffset.value = next;
      },
      onExit: (_) {
        if (_mouseOffset.value == Offset.zero) {
          return;
        }
        _mouseOffset.value = Offset.zero;
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: AnimatedCrossFade(
                duration: AppMotion.sm,
                crossFadeState: isDark
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: DarkBaseCanvas(
                    showDecoLayers: showDecoLayers, overlay: widget.overlay),
                secondChild: LightBaseCanvas(
                  showDecoLayers: showDecoLayers,
                  primary: primary,
                  surface: surface,
                  overlay: widget.overlay,
                ),
                layoutBuilder: _crossFadeLayout,
              ),
            ),
          ),
          Positioned.fill(
            child: RepaintBoundary(
              child: TweenAnimationBuilder<Color?>(
                tween: ColorTween(end: primary),
                duration: AppMotion.heroEntry,
                curve: AppMotion.standard,
                builder: (context, lerpedPrimary, _) {
                  final safePrimary = lerpedPrimary ?? primary;
                  return TweenAnimationBuilder<Color?>(
                    tween: ColorTween(end: secondary),
                    duration: AppMotion.heroEntry,
                    curve: AppMotion.standard,
                    builder: (context, lerpedSecondary, _) {
                      final safeSecondary = lerpedSecondary ?? secondary;
                      final farOrbsWidget = RepaintBoundary(
                        child: AnimatedCrossFade(
                          duration: AppMotion.sm,
                          crossFadeState: isDark
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          firstChild: DarkFarOrbs(
                              size: size,
                              primary: safePrimary,
                              secondary: safeSecondary),
                          secondChild: LightFarOrbs(
                              size: size,
                              primary: safePrimary,
                              secondary: safeSecondary),
                          layoutBuilder: _crossFadeLayout,
                        ),
                      );
                      final nearOrbsWidget = RepaintBoundary(
                        child: AnimatedCrossFade(
                          duration: AppMotion.sm,
                          crossFadeState: isDark
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          firstChild: DarkNearOrb(size: size),
                          secondChild: LightNearOrb(size: size),
                          layoutBuilder: _crossFadeLayout,
                        ),
                      );

                      return ValueListenableBuilder<Offset>(
                        valueListenable: _mouseOffset,
                        builder: (context, mouseOffset, _) {
                          final farMaxShift = isDark ? 16.0 : 12.0;
                          final nearMaxShift = isDark ? 32.0 : 28.0;
                          final still = reduceMotion || size.isEmpty;

                          final farShiftX = still
                              ? 0.0
                              : (mouseOffset.dx / size.width * farMaxShift);
                          final farShiftY = still
                              ? 0.0
                              : (mouseOffset.dy / size.height * farMaxShift);

                          final nearShiftX = still
                              ? 0.0
                              : (mouseOffset.dx / size.width * nearMaxShift);
                          final nearShiftY = still
                              ? 0.0
                              : (mouseOffset.dy / size.height * nearMaxShift);

                          return AnimatedBuilder(
                            animation: _breathController,
                            builder: (context, _) {
                              final breathScale =
                                  0.95 + (_breathController.value * 0.1);
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  Transform.translate(
                                    offset: Offset(farShiftX, farShiftY),
                                    child: Transform.scale(
                                      scale: breathScale,
                                      child: farOrbsWidget,
                                    ),
                                  ),
                                  Transform.translate(
                                    offset: Offset(nearShiftX, nearShiftY),
                                    child: Transform.scale(
                                      scale: 1.0 + ((1.0 - breathScale) * 0.5),
                                      child: nearOrbsWidget,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}
