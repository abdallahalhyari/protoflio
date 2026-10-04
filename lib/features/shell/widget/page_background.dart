import 'package:flutter/material.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';

import 'package:profile/features/shell/widget/background/page_background_canvases.dart';
import 'package:profile/features/shell/widget/background/page_background_orbs.dart';

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

class _PageBackgroundState extends State<PageBackground> {
  final ValueNotifier<Offset> _mouseOffset = ValueNotifier(Offset.zero);

  @override
  void dispose() {
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
    final showDecoLayers = size.width >= AppBreakpoints.tablet;

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
                          
                          final farShiftX = still ? 0.0 : (mouseOffset.dx / size.width * farMaxShift);
                          final farShiftY = still ? 0.0 : (mouseOffset.dy / size.height * farMaxShift);
                          
                          final nearShiftX = still ? 0.0 : (mouseOffset.dx / size.width * nearMaxShift);
                          final nearShiftY = still ? 0.0 : (mouseOffset.dy / size.height * nearMaxShift);
                          
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Transform.translate(
                                offset: Offset(farShiftX, farShiftY),
                                child: farOrbsWidget,
                              ),
                              Transform.translate(
                                offset: Offset(nearShiftX, nearShiftY),
                                child: nearOrbsWidget,
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Positioned.fill(
            child: RepaintBoundary(
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
