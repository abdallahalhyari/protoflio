import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../home_controller.dart';

/// Delays mounting of a heavy section widget until the user is within
/// [distance] pages of it, according to the ambient
/// [HomeController.pageIndex]. Renders a [SizedBox] of [placeholderHeight]
/// while unmounted so the scroll extent doesn't jump when children
/// materialize.
///
/// Once a section has been mounted for the first time we keep it mounted
/// permanently — this preserves `GlobalKey` attachment for jump-to-section
/// and progress-rail sweep, and matches the existing
/// `AutomaticKeepAliveClientMixin` behavior on each page.
class DeferredMount extends StatefulWidget {
  const DeferredMount({
    super.key,
    required this.sectionIndex,
    required this.placeholderHeight,
    required this.child,
    this.distance = 1,
  });

  /// Zero-based section index this widget represents.
  final int sectionIndex;

  /// Height reserved for the section while it hasn't been mounted yet.
  /// Should be a reasonable over-estimate — anything close to the real
  /// section height keeps the scrollbar honest before first mount.
  final double placeholderHeight;

  /// Section is mounted when `(sectionIndex - currentPage).abs() <= distance`.
  /// Default 1 means the current page plus its two neighbors.
  final int distance;

  final Widget child;

  @override
  State<DeferredMount> createState() => _DeferredMountState();
}

class _DeferredMountState extends State<DeferredMount> {
  bool _mounted = false;
  ValueListenable<int>? _pageIndex;

  void _reevaluate() {
    if (_mounted) return;
    final page = _pageIndex?.value ?? 0;
    if ((widget.sectionIndex - page).abs() <= widget.distance) {
      setState(() => _mounted = true);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = HomeController.maybeOf(context);
    // No controller in scope? Mount eagerly. Better to render the section
    // (as it would in an isolated widget test or a future embedded use)
    // than to freeze on the placeholder SizedBox with no clue why.
    if (controller == null) {
      if (!_mounted) setState(() => _mounted = true);
      return;
    }
    final next = controller.pageIndex;
    if (next != _pageIndex) {
      _pageIndex?.removeListener(_reevaluate);
      _pageIndex = next;
      _pageIndex?.addListener(_reevaluate);
      _reevaluate();
    }
  }

  @override
  void dispose() {
    _pageIndex?.removeListener(_reevaluate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_mounted) return widget.child;
    return SizedBox(height: widget.placeholderHeight);
  }
}
