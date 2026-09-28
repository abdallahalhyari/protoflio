import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
    this.mountPriority,
  });

  final Future<void> Function() loader;
  final Widget Function() builder;
  final double placeholderHeight;

  /// When set, the page swaps its content in through [StaggeredMount]
  /// (lowest priority first, one page per frame) instead of building the
  /// moment its code arrives. Use for independent full-screen pages that
  /// all load at once: in the wasm build every chunk resolves together,
  /// and building six sections in one frame was a 400ms+ main-thread task
  /// on desktop and a 1.2s one on a mid-range phone, where it also held
  /// back the first frame.
  final int? mountPriority;

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
      if (!mounted) return;
      final priority = widget.mountPriority;
      if (priority == null) {
        _showContent();
      } else {
        StaggeredMount.request(priority, _showContent);
      }
    }).catchError((Object err) {
      if (mounted) setState(() => _loadError = err);
    });
  }

  void _showContent() {
    if (!mounted || _loaded) return;
    setState(() {
      _loaded = true;
      _loadError = null;
    });
  }

  @override
  void dispose() {
    StaggeredMount.cancel(_showContent);
    super.dispose();
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

/// Hands out one mount per frame, lowest priority first.
///
/// Waits for the frame in progress to finish before the first mount, so
/// every page that became ready in the same burst is queued and ordered
/// by priority (distance from the page on screen) before any of them
/// builds. Each mount then gets a frame of its own: the same total work,
/// split into short tasks that don't block input.
class StaggeredMount {
  StaggeredMount._();

  static final List<(int, VoidCallback)> _pending = [];
  static bool _draining = false;
  static Completer<void>? _idle;

  /// True when nothing is queued or mounting.
  static bool get isIdle => !_draining && _pending.isEmpty;

  /// Completes once every queued page has mounted. Layout that measures
  /// positions (mobile section jumps) waits on this before its final pass,
  /// since each mount can change the height of what sits above a target.
  static Future<void> get idle {
    if (isIdle) return Future<void>.value();
    return (_idle ??= Completer<void>()).future;
  }

  static void request(int priority, VoidCallback mount) {
    // Stable insert: equal priorities keep request order.
    final at = _pending.indexWhere((e) => e.$1 > priority);
    _pending.insert(at < 0 ? _pending.length : at, (priority, mount));
    _drain();
  }

  static void cancel(VoidCallback mount) =>
      _pending.removeWhere((e) => e.$2 == mount);

  static Future<void> _drain() async {
    if (_draining) return;
    _draining = true;
    try {
      await SchedulerBinding.instance.endOfFrame;
      while (_pending.isNotEmpty) {
        _pending.removeAt(0).$2();
        await SchedulerBinding.instance.endOfFrame;
      }
    } finally {
      _draining = false;
      final idle = _idle;
      _idle = null;
      idle?.complete();
    }
  }
}
