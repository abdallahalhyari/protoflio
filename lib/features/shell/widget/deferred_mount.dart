import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:profile/features/shell/home_controller.dart';
import 'package:profile/features/shell/widget/deferred_page.dart';

/// Delays mounting of a heavy section widget until the reader is within
/// [distance] sections of it, according to [HomeController.pageIndex].
///
/// Sections *above* the reader always mount: in a continuous column, a
/// section growing from its placeholder above the viewport would shove the
/// content being read (and land deep-link jumps short).
class DeferredMount extends StatefulWidget {
  const DeferredMount({
    super.key,
    required this.sectionIndex,
    required this.placeholderHeight,
    required this.child,
    this.distance = 10,
    this.mountWhenIdleAfter,
  });

  final int sectionIndex;
  final double placeholderHeight;
  final int distance;
  final Widget child;

  /// Also mount this long after launch even if the reader hasn't come
  /// near — queued through [StaggeredMount], one section per frame, so
  /// everything is ready before it's reached without building it all while
  /// the page is still loading.
  final Duration? mountWhenIdleAfter;

  @override
  State<DeferredMount> createState() => _DeferredMountState();
}

class _DeferredMountState extends State<DeferredMount>
    with AutomaticKeepAliveClientMixin {
  bool _mounted = false;
  bool _initializedFromScope = false;
  Timer? _idleTimer;

  bool _isNear(int pageIndex) =>
      widget.sectionIndex <= pageIndex + widget.distance;

  void _mountNow() {
    if (!mounted || _mounted) return;
    setState(() => _mounted = true);
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    StaggeredMount.cancel(_mountNow);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // One-time initial check, deferred here (not initState) since
    // HomeController.maybeOf depends on InheritedWidget resolution that
    // isn't available until the widget is attached to the tree.
    if (_initializedFromScope) return;
    _initializedFromScope = true;
    final controller = HomeController.maybeOf(context);
    if (controller == null || _isNear(controller.pageIndex.value)) {
      _mounted = true;
      return;
    }
    final delay = widget.mountWhenIdleAfter;
    if (delay != null) {
      _idleTimer = Timer(delay, () {
        if (mounted && !_mounted) {
          StaggeredMount.request(widget.sectionIndex, _mountNow);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Own PageStorage scope per section. Scrollables below carry no
    // PageStorageKey of their own, so without this every horizontal row
    // (filter chips, tabs) shared a storage slot with the mobile page's
    // vertical ListView and restored its offset — rows built mid-page
    // opened scrolled to their far end.
    return KeyedSubtree(
      key: PageStorageKey<String>('deferred_section_${widget.sectionIndex}'),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final controller = HomeController.maybeOf(context);
    if (controller == null || _mounted) return widget.child;

    return ValueListenableBuilder<int>(
      valueListenable: controller.pageIndex,
      builder: (context, pageIndex, child) {
        if (!_mounted && _isNear(pageIndex)) {
          _mounted = true;
          _idleTimer?.cancel();
          StaggeredMount.cancel(_mountNow);
        }
        if (_mounted) return child!;
        return SizedBox(height: widget.placeholderHeight);
      },
      child: widget.child,
    );
  }
}
