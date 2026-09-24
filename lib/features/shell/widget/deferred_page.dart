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

  /// Warms [loader]'s chunk ahead of time and records it, so a later
  /// [DeferredPage] using the same loader mounts straight into content.
  static Future<void> prefetch(Future<void> Function() loader) async {
    await loader();
    _DeferredPageState._resolvedLoaders.add(loader);
  }

  @override
  State<DeferredPage> createState() => _DeferredPageState();
}

class _DeferredPageState extends State<DeferredPage>
    with AutomaticKeepAliveClientMixin {
  // Loaders whose chunk has already resolved (e.g. via HomeScreen's
  // prefetch). A remount can then paint content on its first frame instead
  // of flashing the placeholder and cross-fading while the page slides in.
  static final Set<Object> _resolvedLoaders = {};

  late bool _loaded = _resolvedLoaders.contains(widget.loader);
  Object? _loadError;

  // Keep every section alive across page turns so revisits don't replay
  // entrance animations; off-screen pages are already Offstage and
  // ticker-muted by MagazinePageTransformer.
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (!_loaded) _startLoad();
  }

  void _startLoad() {
    widget.loader().then((_) {
      _resolvedLoaders.add(widget.loader);
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
    super.build(context); // AutomaticKeepAliveClientMixin requirement
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
