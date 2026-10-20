import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';

/// Animates its child with a fade + upward slide when it first enters the
/// viewport. One-shot: once revealed, the wrapper is eliminated and the child
/// renders directly.
///
/// Uses the nearest [Scrollable] ancestor to detect scroll position changes.
/// Falls back to a simple delayed entrance when no scrollable is found (e.g.,
/// inside a desktop paged layout where each section fills the full viewport).
///
/// Respects [AppMedia.reduceMotion]: shows the child instantly.
class ScrollReveal extends StatefulWidget {
  final Widget child;

  /// Delay before starting the animation. Use for stagger effects
  /// by giving successive items increasing delays (e.g., index × 80ms).
  final Duration delay;

  /// Duration of the fade + slide animation.
  final Duration duration;

  /// Vertical slide distance in logical pixels.
  final double slideOffset;

  /// Easing curve. Defaults to Material 3 emphasizedDecel.
  final Curve curve;

  const ScrollReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppMotion.scrollReveal,
    this.slideOffset = 28,
    this.curve = AppMotion.emphasizedDecel,
  });

  /// Creates a staggered reveal with automatic delay based on [index].
  ///
  /// ```dart
  /// for (var i = 0; i < items.length; i++)
  ///   ScrollReveal.stagger(index: i, child: ItemCard(items[i])),
  /// ```
  factory ScrollReveal.stagger({
    Key? key,
    required Widget child,
    required int index,
    Duration interval = AppMotion.scrollRevealStagger,
    Duration duration = AppMotion.scrollReveal,
    double slideOffset = 28,
  }) {
    return ScrollReveal(
      key: key,
      delay: interval * index,
      duration: duration,
      slideOffset: slideOffset,
      child: child,
    );
  }

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  ScrollPosition? _scroll;
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: widget.duration);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_revealed) return;
    _scroll?.removeListener(_check);
    final scrollable = Scrollable.maybeOf(context);
    _scroll = scrollable?.position;
    _scroll?.addListener(_check);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void dispose() {
    _scroll?.removeListener(_check);
    _anim.dispose();
    super.dispose();
  }

  void _check() {
    if (_revealed || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || !box.attached) return;

    final position = box.localToGlobal(Offset.zero);
    final viewHeight = MediaQuery.sizeOf(context).height;

    // Trigger when the widget's top enters the bottom 92% of the viewport.
    if (position.dy < viewHeight * 0.92 && position.dy + box.size.height > 0) {
      _revealed = true;
      _scroll?.removeListener(_check);
      if (widget.delay > Duration.zero) {
        Future.delayed(widget.delay, () {
          if (mounted) _anim.forward();
        });
      } else {
        _anim.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (AppMedia.reduceMotion(context)) return widget.child;
    // Once done, drop the wrapper entirely.
    if (_anim.isCompleted) return widget.child;

    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        final t = widget.curve.transform(_anim.value);
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, widget.slideOffset * (1 - t)),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
