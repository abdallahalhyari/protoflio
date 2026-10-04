import 'package:flutter/widgets.dart';

/// Tells a desktop section whether it is the page currently on screen.
///
/// The desktop pager pre-builds neighbouring pages and keeps visited ones
/// alive, so "mounted" no longer means "visible". Sections that grab
/// keyboard focus for their own shortcuts must key off this instead of
/// `initState`, or an off-screen page steals the arrow keys.
class PageActivity extends InheritedWidget {
  const PageActivity({
    super.key,
    required this.isActive,
    required super.child,
  });

  final bool isActive;

  /// `true` outside a pager (mobile continuous scroll, isolated tests), so
  /// standalone pages keep their existing behaviour.
  static bool isActiveOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PageActivity>()?.isActive ??
      true;

  @override
  bool updateShouldNotify(PageActivity oldWidget) =>
      oldWidget.isActive != isActive;
}

/// Requests [pageFocusNode] each time the host page becomes active.
mixin ActivePageFocusMixin<T extends StatefulWidget> on State<T> {
  FocusNode get pageFocusNode;

  bool _isActivePage = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final active = PageActivity.isActiveOf(context);
    if (active && !_isActivePage) {
      // Post-frame: the pager hands focus back to section navigation
      // during the same frame; this claim must land after it.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _isActivePage) pageFocusNode.requestFocus();
      });
    }
    _isActivePage = active;
  }
}
