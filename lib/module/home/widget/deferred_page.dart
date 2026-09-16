import 'package:flutter/material.dart';

/// Wraps a page whose Dart code is behind a `deferred as` import.
/// Invokes [loader] (which should call `libname.loadLibrary()`), then
/// swaps in [builder]'s widget once the library chunk arrives.
///
/// While loading, a placeholder of [placeholderHeight] pixels is shown
/// so continuous-scroll extents don't jump. On error the placeholder
/// stays put — deferred bundle failures shouldn't crash the shell.
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
      if (mounted) setState(() { _loaded = true; _loadError = null; });
    }).catchError((Object err) {
      if (mounted) setState(() => _loadError = err);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loaded) return widget.builder();
    if (_loadError != null) {
      return SizedBox(
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
    }
    return SizedBox(
      height: widget.placeholderHeight,
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
