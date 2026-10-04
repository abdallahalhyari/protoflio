import 'dart:async';

import 'package:flutter/material.dart';

/// `Image.asset` that survives a transient fetch failure.
///
/// On the web, assets are HTTP fetches; a dropped request left the plain
/// `Image.asset` blank for the rest of the session (no service worker, and
/// Flutter never retries a failed image load). This evicts the failed entry
/// and retries with a short backoff, then gives up quietly so the
/// surrounding placeholder/gradient still reads as intentional.
class RetryingAssetImage extends StatefulWidget {
  const RetryingAssetImage(
    this.path, {
    super.key,
    this.fit,
    this.cacheWidth,
    this.cacheHeight,
    this.filterQuality = FilterQuality.medium,
    this.semanticLabel,
    this.gaplessPlayback = false,
    this.maxRetries = 2,
  });

  final String path;
  final BoxFit? fit;
  final int? cacheWidth;
  final int? cacheHeight;
  final FilterQuality filterQuality;
  final String? semanticLabel;
  final bool gaplessPlayback;
  final int maxRetries;

  @override
  State<RetryingAssetImage> createState() => _RetryingAssetImageState();
}

class _RetryingAssetImageState extends State<RetryingAssetImage> {
  int _attempt = 0;
  Timer? _retryTimer;

  @override
  void dispose() {
    _retryTimer?.cancel();
    super.dispose();
  }

  void _scheduleRetry() {
    if (_retryTimer != null || _attempt >= widget.maxRetries) return;
    _retryTimer = Timer(Duration(milliseconds: 800 * (_attempt + 1)), () {
      _retryTimer = null;
      if (!mounted) return;
      final provider = AssetImage(widget.path);
      provider.evict();
      ResizeImage.resizeIfNeeded(
        widget.cacheWidth,
        widget.cacheHeight,
        provider,
      ).evict();
      setState(() => _attempt++);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      widget.path,
      key: ValueKey(_attempt),
      fit: widget.fit,
      cacheWidth: widget.cacheWidth,
      cacheHeight: widget.cacheHeight,
      filterQuality: widget.filterQuality,
      semanticLabel: widget.semanticLabel,
      gaplessPlayback: widget.gaplessPlayback,
      errorBuilder: (context, error, stackTrace) {
        _scheduleRetry();
        return const SizedBox.expand();
      },
    );
  }
}
