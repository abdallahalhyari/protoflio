import 'package:flutter/widgets.dart';
import 'package:profile/features/shell/home_controller.dart';

/// Delays mounting of a heavy section widget until the user is within
/// [distance] pages of it, according to [HomeController.pageIndex].
class DeferredMount extends StatefulWidget {
  const DeferredMount({
    super.key,
    required this.sectionIndex,
    required this.placeholderHeight,
    required this.child,
    this.distance = 1,
  });

  final int sectionIndex;
  final double placeholderHeight;
  final int distance;
  final Widget child;

  @override
  State<DeferredMount> createState() => _DeferredMountState();
}

class _DeferredMountState extends State<DeferredMount>
    with AutomaticKeepAliveClientMixin {
  bool _mounted = false;
  bool _initializedFromScope = false;

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
    if (controller == null ||
        (widget.sectionIndex - controller.pageIndex.value).abs() <=
            widget.distance) {
      _mounted = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final controller = HomeController.maybeOf(context);
    if (controller == null || _mounted) return widget.child;

    return ValueListenableBuilder<int>(
      valueListenable: controller.pageIndex,
      builder: (context, pageIndex, child) {
        if (!_mounted &&
            (widget.sectionIndex - pageIndex).abs() <= widget.distance) {
          _mounted = true;
        }
        if (_mounted) return child!;
        return SizedBox(height: widget.placeholderHeight);
      },
      child: widget.child,
    );
  }
}
