import 'package:flutter/material.dart';

/// Wraps a scrollable child with a fade gradient at the trailing edge
/// (bottom by default, right for horizontal) that appears only while
/// there is more content to scroll toward. Signals "there's more" to
/// users who might otherwise think the surface is fully rendered.
class FadeEdge extends StatefulWidget {
  const FadeEdge({
    super.key,
    required this.controller,
    required this.child,
    this.axis = Axis.vertical,
    this.fadeSize = 24,
    this.tint,
  });

  final ScrollController controller;
  final Widget child;
  final Axis axis;
  final double fadeSize;

  /// Color to fade toward. Defaults to `Theme.of(context).colorScheme.surface`.
  final Color? tint;

  @override
  State<FadeEdge> createState() => _FadeEdgeState();
}

class _FadeEdgeState extends State<FadeEdge> {
  bool _showLeading = false;
  bool _showTrailing = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_recompute);
    WidgetsBinding.instance.addPostFrameCallback((_) => _recompute());
  }

  @override
  void dispose() {
    widget.controller.removeListener(_recompute);
    super.dispose();
  }

  void _recompute() {
    if (!mounted || !widget.controller.hasClients) return;
    final pos = widget.controller.position;
    final leading = pos.pixels > 4;
    final trailing = pos.pixels < pos.maxScrollExtent - 4;
    if (leading != _showLeading || trailing != _showTrailing) {
      setState(() {
        _showLeading = leading;
        _showTrailing = trailing;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tint = widget.tint ?? Theme.of(context).colorScheme.surface;
    final vertical = widget.axis == Axis.vertical;

    Widget fade(bool visible, Alignment begin, Alignment end) {
      if (!visible) return const SizedBox.shrink();
      return Positioned(
        left: 0,
        right: 0,
        top: end == Alignment.topCenter ? 0 : null,
        bottom: end == Alignment.bottomCenter ? 0 : null,
        height: vertical ? widget.fadeSize : null,
        child: IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: begin,
                end: end,
                colors: [
                  tint.withValues(alpha: 0.0),
                  tint,
                ],
              ),
            ),
          ),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (_) {
        _recompute();
        return false;
      },
      child: Stack(
        children: [
          widget.child,
          if (vertical) ...[
            fade(_showLeading, Alignment.bottomCenter, Alignment.topCenter),
            fade(_showTrailing, Alignment.topCenter, Alignment.bottomCenter),
          ],
        ],
      ),
    );
  }
}
