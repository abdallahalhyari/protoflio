import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/core/bloc/navigation/navigation_bloc.dart';
import 'package:profile/core/bloc/navigation/navigation_state.dart';

/// Delays mounting of a heavy section widget until the user is within
/// [distance] pages of it, according to the NavigationBloc.
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

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<NavigationBloc?>();
    if (bloc == null) {
      _mounted = true;
    } else if ((widget.sectionIndex - bloc.state.pageIndex).abs() <=
        widget.distance) {
      _mounted = true;
    }
  }

  void _reevaluate(int pageIndex) {
    if (_mounted) return;
    if ((widget.sectionIndex - pageIndex).abs() <= widget.distance) {
      setState(() => _mounted = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bloc = context.read<NavigationBloc?>();
    if (bloc == null) return widget.child;

    return BlocConsumer<NavigationBloc, NavigationState>(
      listener: (context, state) => _reevaluate(state.pageIndex),
      builder: (context, state) {
        if (!_mounted &&
            (widget.sectionIndex - state.pageIndex).abs() <= widget.distance) {
          _mounted = true;
        }
        if (_mounted) return widget.child;
        return SizedBox(height: widget.placeholderHeight);
      },
    );
  }
}
