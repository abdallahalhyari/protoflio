import 'package:flutter/material.dart';
import 'package:profile/theme/tokens.dart';

/// Wraps a page whose Dart code is behind a `deferred as` import.
/// Invokes [loader] (which should call `libname.loadLibrary()`), then
/// swaps in [builder]'s widget once the library chunk arrives.
///
/// While loading, a shimmer skeleton placeholder is shown so
/// continuous-scroll extents don't jump and perceived performance
/// feels premium. On error a retry button stays put.
class DeferredPage extends StatefulWidget {
  const DeferredPage({
    super.key,
    required this.loader,
    required this.builder,
    this.placeholderHeight = 720,
  });

  final Future<void> Function() loader;
  final Widget Function() builder;
  final double placeholderHeight;

  @override
  State<DeferredPage> createState() => _DeferredPageState();
}

class _DeferredPageState extends State<DeferredPage> {
  bool _loaded = false;
  Object? _loadError;

  @override
  void initState() {
    super.initState();
    _startLoad();
  }

  void _startLoad() {
    widget.loader().then((_) {
      if (mounted) {
        setState(() {
          _loaded = true;
          _loadError = null;
        });
      }
    }).catchError((Object err) {
      if (mounted) setState(() => _loadError = err);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (_loaded) {
      content = KeyedSubtree(
        key: const ValueKey('loaded_content'),
        child: widget.builder(),
      );
    } else if (_loadError != null) {
      content = SizedBox(
        key: const ValueKey('load_error'),
        height: widget.placeholderHeight,
        child: Center(
          child: TextButton(
            onPressed: () {
              setState(() => _loadError = null);
              _startLoad();
            },
            child: const Text('Retry'),
          ),
        ),
      );
    } else {
      content = SizedBox(
        key: const ValueKey('load_placeholder'),
        height: widget.placeholderHeight,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return AnimatedSwitcher(
      duration: AppMotion.sm,
      switchInCurve: AppMotion.standard,
      switchOutCurve: AppMotion.standard,
      child: content,
    );
  }
}
