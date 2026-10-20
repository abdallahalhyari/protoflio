import 'package:flutter/widgets.dart';

/// Pauses every ticker in [child] while the child is scrolled out of view.
///
/// Repeating animations (`AnimationController.repeat()`) keep their ticker
/// running at display rate even when their widget is off-screen — on web
/// (CanvasKit) that re-rasterizes pixels nobody sees. Wrapping the subtree
/// in a `TickerMode(enabled: false)` halts all of them at once, so no
/// per-animation plumbing is needed.
///
/// Visibility is judged by the child's global bounds against the screen,
/// recomputed when the enclosing scrollable moves. No external package;
/// the bounds check is throttled by [sampleThreshold].
class ViewportTickerGate extends StatefulWidget {
  const ViewportTickerGate({
    super.key,
    required this.child,
    this.sampleThreshold = 48.0,
    this.margin = 120.0,
  });

  final Widget child;

  /// Minimum scroll delta (px) between visibility recomputes.
  final double sampleThreshold;

  /// Extra margin (px) above and below the viewport that still counts as
  /// "visible", so the animation is already running by the time it scrolls
  /// into frame.
  final double margin;

  @override
  State<ViewportTickerGate> createState() => _ViewportTickerGateState();
}

class _ViewportTickerGateState extends State<ViewportTickerGate> {
  bool _visible = true;
  double _lastSample = double.negativeInfinity;
  ScrollPosition? _position;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newPos = Scrollable.maybeOf(context)?.position;
    if (newPos != _position) {
      _position?.removeListener(_onScroll);
      _position = newPos;
      _position?.addListener(_onScroll);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _reevaluate());
  }

  @override
  void dispose() {
    _position?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final offset = _position?.pixels ?? 0;
    if ((offset - _lastSample).abs() < widget.sampleThreshold) return;
    _lastSample = offset;
    // Bounds reflect the new scroll only after this frame lays out; defer.
    WidgetsBinding.instance.addPostFrameCallback((_) => _reevaluate());
  }

  void _reevaluate() {
    if (!mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || !box.attached) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final bottom = top + box.size.height;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final next =
        bottom >= -widget.margin && top <= screenHeight + widget.margin;
    if (next != _visible) {
      setState(() => _visible = next);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TickerMode(
      enabled: _visible,
      child: widget.child,
    );
  }
}
