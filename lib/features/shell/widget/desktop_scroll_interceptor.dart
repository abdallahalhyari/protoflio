import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:profile/theme/tokens.dart';

class DesktopScrollInterceptor extends StatefulWidget {
  final Widget child;
  final PageController pageController;
  final ValueNotifier<int> pageIndex;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  // ValueListenables, not plain bool/DateTime — read via `.value` at the
  // moment a wheel event arrives, so this always sees HomeScreen's live
  // transition state instead of whatever was current the last time this
  // widget happened to be rebuilt.
  final ValueListenable<bool> isPageTransitioning;
  final ValueListenable<DateTime> lastPageTurnCompletedAt;

  const DesktopScrollInterceptor({
    super.key,
    required this.child,
    required this.pageController,
    required this.pageIndex,
    required this.onNext,
    required this.onPrev,
    required this.isPageTransitioning,
    required this.lastPageTurnCompletedAt,
  });

  @override
  State<DesktopScrollInterceptor> createState() =>
      _DesktopScrollInterceptorState();
}

class _DesktopScrollInterceptorState extends State<DesktopScrollInterceptor> {
  // Increased threshold from 80 to 140 to require a more deliberate scroll
  // intent, preventing premature page turns from sensitive trackpads.
  static const double _kWheelThreshold = 140;
  static const Duration _kWheelCooldown = Duration(milliseconds: 320);
  double _wheelAccum = 0;
  DateTime _lastWheelAt = DateTime.fromMillisecondsSinceEpoch(0);
  double _lastDy = 0;

  bool _isIgnoringBurst = false;

  bool _canInnerScroll(Offset globalPosition, double dy) {
    if (!mounted) return false;

    final result = HitTestResult();
    final viewId = View.of(context).viewId;
    RendererBinding.instance.hitTestInView(result, globalPosition, viewId);

    for (final entry in result.path) {
      final target = entry.target;
      if (target is! RenderObject) continue;

      RenderObject? currentObj = target;
      while (currentObj != null) {
        if (currentObj is RenderAbstractViewport) {
          ViewportOffset? offset;
          if (currentObj is RenderViewportBase) {
            offset = currentObj.offset;
          } else {
            try {
              offset = (currentObj as dynamic).offset as ViewportOffset?;
            } catch (_) {}
          }

          if (offset != null) {
            // If this viewport is the outer PageView, stop ascending this branch
            if (widget.pageController.hasClients &&
                offset == widget.pageController.position) {
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
        currentObj = currentObj.parent;
      }
    }
    return false;
  }

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;

    if (!mounted) return;
    final modalRoute = ModalRoute.of(context);
    if (modalRoute != null && !modalRoute.isCurrent) {
      _wheelAccum = 0;
      return;
    }

    final now = DateTime.now();
    final timeSinceLastWheel = now.difference(_lastWheelAt);
    _lastWheelAt = now;

    final dy = event.scrollDelta.dy;

    // Detect new interaction intent to break out of burst ignore:
    // 1. Time gap (user paused)
    if (timeSinceLastWheel > AppMotion.wheelResetGap) {
      _isIgnoringBurst = false;
      _wheelAccum = 0;
    }
    // 2. Sudden velocity spike (new flick in same direction)
    else if (_lastDy != 0 &&
        dy.sign == _lastDy.sign &&
        dy.abs() > _lastDy.abs() + 15.0) {
      _isIgnoringBurst = false;
      _wheelAccum = 0;
    }
    // 3. Direction change (flick in opposite direction)
    else if (_lastDy != 0 && dy.sign != _lastDy.sign && dy.abs() > 2.0) {
      _isIgnoringBurst = false;
      _wheelAccum = 0;
    }

    _lastDy = dy;

    // Drop further wheel events while a transition animation is actively in flight
    // or within the post-turn cooldown window.
    if (widget.isPageTransitioning.value ||
        now.difference(widget.lastPageTurnCompletedAt.value) <
            _kWheelCooldown) {
      _wheelAccum = 0;
      // We are in a transition/cooldown, so any ongoing scroll burst MUST be
      // ignored entirely, even after the cooldown finishes, until the user pauses.
      _isIgnoringBurst = true;
      return;
    }

    if (_isIgnoringBurst) {
      // Still receiving momentum events from a swipe that already triggered a turn.
      _wheelAccum = 0;
      return;
    }

    if (dy.abs() < 1.0) return;

    if (_canInnerScroll(event.position, dy)) {
      _wheelAccum = 0;
      return;
    }

    _wheelAccum += dy;

    if (_wheelAccum >= _kWheelThreshold) {
      _wheelAccum = 0;
      _isIgnoringBurst = true;
      widget.onNext();
    } else if (_wheelAccum <= -_kWheelThreshold) {
      _wheelAccum = 0;
      _isIgnoringBurst = true;
      widget.onPrev();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerSignal: _onPointerSignal,
      child: widget.child,
    );
  }
}
