import 'package:flutter/material.dart';

/// Fades + slides a child in on first mount. Use `delay` to build a
/// staggered reveal — e.g. `Stagger(delay: Duration(milliseconds: 80 * i))`
/// on each list child.
///
/// Skips animation entirely when `MediaQueryData.disableAnimations` is on:
/// the child renders at rest immediately.
class Stagger extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offsetY;

  const Stagger({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
    this.offsetY = 16,
  });

  @override
  State<Stagger> createState() => _StaggerState();
}

class _StaggerState extends State<Stagger>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _t = CurvedAnimation(
    parent: _c,
    curve: Curves.easeOutCubic,
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.of(context).disableAnimations) {
      _c.value = 1;
      return;
    }
    Future.delayed(widget.delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _t,
      builder: (_, child) {
        final t = _t.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, widget.offsetY * (1 - t)),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
