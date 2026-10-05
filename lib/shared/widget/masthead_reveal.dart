import 'package:flutter/material.dart';

import 'package:profile/theme/tokens.dart';

/// Editorial "ink-in" for a section header, played once, the first time
/// the header scrolls or turns into view: the accent rule draws across,
/// the kicker slides in, the title rises out of a mask, then the subtitle,
/// badge and hairline settle.
///
/// Every beat is a transform or an opacity on already-laid-out content, so
/// layout never shifts and nothing re-lays out per frame. It runs ~0.9s
/// once per header; reduced-motion readers get the finished header.
class MastheadReveal extends StatefulWidget {
  const MastheadReveal({super.key, required this.builder});

  /// Builds the header, wrapping each part in the matching [RevealSlots]
  /// method.
  final Widget Function(BuildContext context, RevealSlots reveal) builder;

  @override
  State<MastheadReveal> createState() => _MastheadRevealState();
}

class _MastheadRevealState extends State<MastheadReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.mastheadReveal,
  );
  late final RevealSlots _slots = RevealSlots._(_controller);

  final List<ScrollPosition> _positions = [];
  double _viewportHeight = 0;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    if (AppMedia.reduceMotion(context)) {
      _start(animate: false);
      return;
    }
    _viewportHeight = MediaQuery.sizeOf(context).height;
    _watchScrollables();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkInView());
  }

  /// Listens to every scrollable above the header: the desktop page
  /// turner and a section's own scroll on desktop, the one long column
  /// on mobile.
  void _watchScrollables() {
    _unwatch();
    BuildContext? ctx = context;
    while (ctx != null) {
      final scrollable = Scrollable.maybeOf(ctx);
      if (scrollable == null) break;
      scrollable.position.addListener(_checkInView);
      _positions.add(scrollable.position);
      ctx = scrollable.context;
    }
  }

  void _unwatch() {
    for (final position in _positions) {
      position.removeListener(_checkInView);
    }
    _positions.clear();
  }

  void _checkInView() {
    if (_started || !mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    // In view once its top is above the bottom edge (less a margin, so it
    // plays where it can be seen) and it hasn't already scrolled past.
    if (top < _viewportHeight * 0.9 && top + box.size.height > 0) {
      _start(animate: true);
    }
  }

  void _start({required bool animate}) {
    _started = true;
    _unwatch();
    if (animate) {
      _controller.forward();
    } else {
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _unwatch();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(child: widget.builder(context, _slots));
  }
}

/// The reveal's timeline, one slot per header part. Each slot listens to
/// the shared controller itself, so only the moving part repaints.
class RevealSlots {
  RevealSlots._(this._controller);

  final AnimationController _controller;

  Animation<double> _beat(double begin, double end) => CurvedAnimation(
        parent: _controller,
        curve: Interval(begin, end, curve: AppMotion.emphasizedDecel),
      );

  late final Animation<double> _rule = _beat(0.0, 0.5);
  late final Animation<double> _kicker = _beat(0.1, 0.5);
  late final Animation<double> _title = _beat(0.15, 0.75);
  late final Animation<double> _subtitle = _beat(0.35, 0.85);
  late final Animation<double> _badge = _beat(0.5, 1.0);
  late final Animation<double> _hairline = _beat(0.4, 1.0);

  /// The heavy accent rule draws from the reading edge.
  Widget rule(Widget child) => _draw(_rule, child);

  /// The thin rule under the header draws in last.
  Widget hairline(Widget child) => _draw(_hairline, child);

  /// The kicker fades in, sliding a few pixels from the reading edge.
  Widget kicker(Widget child) => _AnimatedPart(
        animation: _kicker,
        builder: (context, t, child) => Transform.translate(
          offset: Offset((1 - t) * -10 * _readingSign(context), 0),
          child: _fade(t, child),
        ),
        child: child,
      );

  /// The title rises into place from below its own baseline, clipped so
  /// it reads as coming up out of the rule.
  Widget title(Widget child) => _AnimatedPart(
        animation: _title,
        builder: (context, t, child) => ClipRect(
          child: FractionalTranslation(
            translation: Offset(0, 1 - t),
            child: child,
          ),
        ),
        child: child,
      );

  /// The subtitle fades up a few pixels.
  Widget subtitle(Widget child) => _AnimatedPart(
        animation: _subtitle,
        builder: (context, t, child) => Transform.translate(
          offset: Offset(0, (1 - t) * 6),
          child: _fade(t, child),
        ),
        child: child,
      );

  /// The count badge pops in last.
  Widget badge(Widget child) => _AnimatedPart(
        animation: _badge,
        builder: (context, t, child) => Transform.scale(
          scale: 0.9 + 0.1 * t,
          child: _fade(t, child),
        ),
        child: child,
      );

  static Widget _draw(Animation<double> animation, Widget child) =>
      _AnimatedPart(
        animation: animation,
        builder: (context, t, child) => Transform(
          alignment: AlignmentDirectional.centerStart
              .resolve(Directionality.of(context)),
          transform: Matrix4.diagonal3Values(t, 1, 1),
          child: child,
        ),
        child: child,
      );

  // Screen readers keep the text while it is still transparent.
  static Widget _fade(double t, Widget? child) =>
      Opacity(opacity: t, alwaysIncludeSemantics: true, child: child);

  static double _readingSign(BuildContext context) =>
      Directionality.of(context) == TextDirection.rtl ? -1 : 1;
}

class _AnimatedPart extends StatelessWidget {
  const _AnimatedPart({
    required this.animation,
    required this.builder,
    required this.child,
  });

  final Animation<double> animation;
  final Widget Function(BuildContext context, double t, Widget? child) builder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // At rest (before or after) the part costs nothing but this check.
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => animation.value >= 1
          ? child!
          : builder(context, animation.value, child),
      child: child,
    );
  }
}
