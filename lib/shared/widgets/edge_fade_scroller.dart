import 'package:flutter/material.dart';

/// Horizontal scroller whose left/right edges fade out only while there is
/// more content in that direction — a quiet "this scrolls" affordance for
/// chip/tab rows that overflow on narrower screens.
///
/// The ShaderMask is always present (stops collapse to a no-op when nothing
/// overflows) so the scroller is never remounted when the fade toggles —
/// swapping widget types there would reset the scroll position.
class EdgeFadeScroller extends StatefulWidget {
  const EdgeFadeScroller(
      {super.key, required this.child, this.fraction = 0.05});

  final Widget child;

  /// Width of each fade as a fraction of the viewport.
  final double fraction;

  @override
  State<EdgeFadeScroller> createState() => _EdgeFadeScrollerState();
}

class _EdgeFadeScrollerState extends State<EdgeFadeScroller> {
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
    if (!mounted || !_controller.hasClients) return;
    final pos = _controller.position;
    if (!pos.hasContentDimensions) return;
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
    return NotificationListener<ScrollMetricsNotification>(
      // Content/viewport size changes (resize, filter toggles) don't scroll,
      // so re-evaluate the fades on metrics changes too.
      onNotification: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _recompute());
        return false;
      },
      child: ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (rect) => LinearGradient(
          colors: const [
            Colors.transparent,
            Colors.black,
            Colors.black,
            Colors.transparent,
          ],
          stops: [
            0.0,
            _fadeLeft ? widget.fraction : 0.0,
            _fadeRight ? 1 - widget.fraction : 1.0,
            1.0,
          ],
        ).createShader(rect),
        child: SingleChildScrollView(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          child: widget.child,
        ),
      ),
    );
  }
}
