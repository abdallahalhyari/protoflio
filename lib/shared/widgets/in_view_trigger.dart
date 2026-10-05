import 'package:flutter/widgets.dart';

/// Runs an entrance once, the first time its widget is actually on screen,
/// instead of when it mounts. Sections mount ahead of the reader (desktop
/// pages next door, the mobile column's idle mounts), so an entrance
/// started on mount mostly plays where nobody sees it.
///
/// Call [playWhenInView] from `didChangeDependencies`. It listens to every
/// scrollable above the widget (the desktop page turner, a section's own
/// scroll, the mobile column) and fires when the widget's top is inside
/// the viewport.
mixin InViewTrigger<T extends StatefulWidget> on State<T> {
  final List<ScrollPosition> _watched = [];
  VoidCallback? _onInView;
  double _viewportHeight = 0;
  bool _fired = false;

  void playWhenInView(VoidCallback onInView) {
    if (_fired) return;
    _onInView = onInView;
    _viewportHeight = MediaQuery.sizeOf(context).height;
    _unwatch();
    BuildContext? ctx = context;
    while (ctx != null) {
      final scrollable = Scrollable.maybeOf(ctx);
      if (scrollable == null) break;
      scrollable.position.addListener(_checkInView);
      _watched.add(scrollable.position);
      ctx = scrollable.context;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkInView());
  }

  void _checkInView() {
    if (_fired || !mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    // Its top above the bottom edge (less a margin, so it plays where it
    // can be seen) and not already scrolled past.
    if (top < _viewportHeight * 0.9 && top + box.size.height > 0) {
      _fired = true;
      _unwatch();
      _onInView?.call();
    }
  }

  void _unwatch() {
    for (final position in _watched) {
      position.removeListener(_checkInView);
    }
    _watched.clear();
  }

  @override
  void dispose() {
    _unwatch();
    super.dispose();
  }
}
