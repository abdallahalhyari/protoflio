import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;

/// Reads a bundled `assets/data/*.json` list.
///
/// On the web every asset is an HTTP request, and the app can't start
/// without its content: one dropped request used to throw out of `main()`
/// and leave the boot screen up for good. Each attempt bypasses the
/// bundle's cache (it keeps a failed load and would hand the same error
/// back), with a short pause between tries.
Future<List<dynamic>> loadBundledJsonList(
  String path, {
  AssetBundle? bundle,
  int attempts = 3,
  Duration retryDelay = const Duration(milliseconds: 400),
}) async {
  final source = bundle ?? rootBundle;
  for (var attempt = 1;; attempt++) {
    try {
      final text = await source.loadString(path, cache: false);
      return jsonDecode(text) as List<dynamic>;
    } on FormatException {
      rethrow; // Malformed content won't fix itself on a retry.
    } catch (_) {
      if (attempt >= attempts) rethrow;
      await Future<void>.delayed(retryDelay * attempt);
    }
  }
}
