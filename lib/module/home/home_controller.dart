import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Facade over the navigation and scroll state owned by
/// `_HomeScreenState`. Provided down the tree by `HomeControllerScope`
/// so any descendant can look it up without prop-drilling through
/// `HomeScreen.build`.
///
/// The controller is intentionally a plain object (not a `ChangeNotifier`).
/// Observers listen to `pageIndex` — a `ValueListenable<int>` — via
/// `ValueListenableBuilder`, so rebuild scope stays surgical and tests
/// can drive the controller with a `ValueNotifier` stub.
class HomeController {
  const HomeController({
    required this.pageIndex,
    required this.showScrollToTop,
    required this.pageCount,
    required this.goTo,
    required this.next,
    required this.prev,
    required this.scrollToMobileSection,
  });

  final ValueListenable<int> pageIndex;
  final ValueListenable<bool> showScrollToTop;
  final int pageCount;

  /// Jump to [page]. `syncUrl` controls whether the URL hash updates —
  /// pass `false` from hash-change listeners to prevent feedback loops.
  final void Function(int page, {bool syncUrl}) goTo;
  final VoidCallback next;
  final VoidCallback prev;
  final void Function(int index, {bool syncUrl}) scrollToMobileSection;

  /// Lookup the nearest [HomeController] in the widget tree. Returns
  /// `null` outside the `HomeScreen` subtree.
  static HomeController? maybeOf(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<HomeControllerScope>();
    return scope?.controller;
  }

  /// Like [maybeOf] but asserts the controller is present. Use inside
  /// widgets that only exist under a `HomeScreen`.
  static HomeController of(BuildContext context) {
    final controller = maybeOf(context);
    assert(controller != null,
        'HomeController.of() called with no HomeControllerScope in the tree.');
    return controller!;
  }
}

/// Inherited scope that publishes a [HomeController] to descendants.
/// Descendants call `HomeController.of(context)` to look it up.
class HomeControllerScope extends InheritedWidget {
  const HomeControllerScope({
    super.key,
    required this.controller,
    required super.child,
  });

  final HomeController controller;

  @override
  bool updateShouldNotify(HomeControllerScope oldWidget) =>
      controller != oldWidget.controller;
}
