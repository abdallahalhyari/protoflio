import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:profile/theme/tokens.dart';

class DesktopScrollInterceptor extends StatefulWidget {
  final Widget child;
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

  // True once the current wheel burst has scrolled content inside the page.
  // Momentum that carries past the end of that content must stop there;
  // turning the page needs a fresh gesture, or a flick through a long
  // section overshoots straight onto the next one.
  bool _innerScrolledThisBurst = false;

  // The wheel event currently waiting on the pointer-signal resolver, and
  // whether this interceptor (rather than scrollable content under the
  // cursor) ended up handling it.
  PointerScrollEvent? _pendingEvent;
  bool _handledPending = false;

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
      _innerScrolledThisBurst = false;
    }
    // 2. Sudden velocity spike (new flick in same direction)
    else if (_lastDy != 0 &&
        dy.sign == _lastDy.sign &&
        dy.abs() > _lastDy.abs() + 15.0) {
      _isIgnoringBurst = false;
      _wheelAccum = 0;
      _innerScrolledThisBurst = false;
    }
    // 3. Direction change (flick in opposite direction)
    else if (_lastDy != 0 && dy.sign != _lastDy.sign && dy.abs() > 2.0) {
      _isIgnoringBurst = false;
      _wheelAccum = 0;
      _innerScrolledThisBurst = false;
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

    // Let scrollable content inside the page take the wheel first. Every
    // Scrollable under the cursor that can still move registers with the
    // pointer-signal resolver during dispatch, deepest first; the first
    // registration wins. The outer page scroller never registers
    // (NeverScrollableScrollPhysics), so this callback only runs when no
    // content can scroll in that direction — including over blank space
    // inside a scroll area, which a render-tree hit test used to miss.
    _pendingEvent = event;
    _handledPending = false;
    GestureBinding.instance.pointerSignalResolver.register(event, (_) {
      _handledPending = true;
      _turnPageFor(dy);
    });
    scheduleMicrotask(() {
      if (_pendingEvent != event) return;
      _pendingEvent = null;
      if (!_handledPending) {
        // Content under the cursor scrolled instead.
        _wheelAccum = 0;
        _innerScrolledThisBurst = true;
      }
    });
  }

  void _turnPageFor(double dy) {
    // Content scrolled earlier in this same burst and has just reached its
    // edge: rest here. Turning the page needs a fresh gesture.
    if (_innerScrolledThisBurst) {
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
