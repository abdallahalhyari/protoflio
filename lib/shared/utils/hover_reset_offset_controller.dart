import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

/// Tracks a pointer-relative `Offset` (for hover tilt/parallax effects) that
/// snaps back to [Offset.zero] with an animated ease-out on pointer exit.
///
/// Extracted after the same bug — a fresh `Tween.animate(...)` chain built
/// and given a new listener on every exit, leaking one listener onto the
/// shared [AnimationController] per hover/exit cycle — was independently
/// hand-written (and fixed) in both `HeroParallax` and
/// `HolographicCardPhysics`. This owns the fix once: a single persistent
/// listener on the controller reads whatever the current reset animation
/// is, so building a new `Tween`/`CurvedAnimation` per exit never leaks.
///
/// Usage:
/// ```dart
/// class _MyCardState extends State<MyCard> with SingleTickerProviderStateMixin {
///   late final _hover = HoverResetOffsetController(
///     vsync: this,
///     duration: AppMotion.sm,
///     curve: Curves.easeOutCubic,
///   );
///
///   @override
///   void dispose() {
///     _hover.dispose();
///     super.dispose();
///   }
///
///   // On pointer move: _hover.set(nextOffset);
///   // On pointer exit: _hover.animateToZero();
///   // Build against: ValueListenableBuilder(valueListenable: _hover.offset, ...)
/// }
/// ```
class HoverResetOffsetController {
  HoverResetOffsetController({
    required TickerProvider vsync,
    required this.duration,
    required this.curve,
  }) : _controller = AnimationController(vsync: vsync, duration: duration) {
    // Built once: `CurvedAnimation` registers a status listener on its
    // parent, so constructing one per exit would leak all over again.
    _curved = CurvedAnimation(parent: _controller, curve: curve);
    _controller.addListener(() {
      final anim = _resetAnimation;
      if (anim != null) offset.value = anim.value;
    });
  }

  final Duration duration;
  final Curve curve;
  final AnimationController _controller;
  late final CurvedAnimation _curved;
  Animation<Offset>? _resetAnimation;

  /// Current pointer-relative offset. Listen to this to drive tilt/parallax
  /// transforms.
  final ValueNotifier<Offset> offset = ValueNotifier<Offset>(Offset.zero);

  bool get isAnimatingToZero => _controller.isAnimating;

  /// Set the offset directly (e.g. from a pointer-move handler). Stops any
  /// in-flight reset animation.
  void set(Offset next) {
    if (_controller.isAnimating) _controller.stop();
    offset.value = next;
  }

  /// Animate [offset] back to [Offset.zero] over [duration]/[curve]. No-op
  /// if already at zero.
  void animateToZero() {
    final current = offset.value;
    if (current == Offset.zero) return;

    _resetAnimation =
        Tween<Offset>(begin: current, end: Offset.zero).animate(_curved);
    _controller
      ..reset()
      ..forward();
  }

  void dispose() {
    _curved.dispose();
    offset.dispose();
    _controller.dispose();
  }
}
