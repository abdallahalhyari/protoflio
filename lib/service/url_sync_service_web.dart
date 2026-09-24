import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:flutter/services.dart';
import 'url_sync_service.dart';

UrlSyncService createUrlSyncService() => UrlSyncServiceWeb();

@JS('window')
external JSObject get _window;

class UrlSyncServiceWeb extends UrlSyncService {
  String? _lastReportedHash;

  @override
  String? getInitialHash() {
    try {
      if (_window.has('location')) {
        final location = _window.getProperty('location'.toJS) as JSObject;
        if (location.has('hash')) {
          final hash = (location.getProperty('hash'.toJS) as JSString).toDart;
          if (hash.isNotEmpty) {
            return hash.replaceAll('#', '');
          }
        }
      }
    } catch (_) {}
    return null;
  }

  @override
  void updateTitle(String title) {
    try {
      SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(label: title),
      );
      if (_window.has('document')) {
        final document = _window.getProperty('document'.toJS) as JSObject;
        document.setProperty('title'.toJS, title.toJS);
      }
    } catch (_) {}
  }

  @override
  void updateHash(String hash) {
    updateTitle(titleForHash(hash));
    if (hash == _lastReportedHash) return;
    _lastReportedHash = hash;
    try {
      if (_window.has('history')) {
        final history = _window.getProperty('history'.toJS) as JSObject;
        if (history.has('replaceState')) {
          final replaceState =
              history.getProperty('replaceState'.toJS) as JSFunction;
          final newHash = '#$hash'.toJS;
          replaceState.callAsFunction(history, null, ''.toJS, newHash);
          return;
        }
      }
      if (_window.has('location')) {
        final location = _window.getProperty('location'.toJS) as JSObject;
        location.setProperty('hash'.toJS, '#$hash'.toJS);
      }
    } catch (_) {}
  }

  @override
  void pushHash(String hash) {
    updateTitle(titleForHash(hash));
    _lastReportedHash = hash;
    try {
      final history = _window.getProperty('history'.toJS) as JSObject;
      // callAsFunction, not callMethod: callMethod drops null arguments, which
      // shifted `url` into the `title` slot and silently pushed nothing.
      final pushState = history.getProperty('pushState'.toJS) as JSFunction;
      pushState.callAsFunction(history, null, ''.toJS, '#$hash'.toJS);
    } catch (_) {}
  }

  @override
  void back() {
    try {
      final history = _window.getProperty('history'.toJS) as JSObject;
      history.callMethod('back'.toJS);
    } catch (_) {}
  }

  @override
  void Function() listenToHashChanges(void Function(String hash) onHashChange) {
    try {
      if (_window.has('addEventListener')) {
        final addEventListener =
            _window.getProperty('addEventListener'.toJS) as JSFunction;
        final callback = ((JSAny? event) {
          final hash = getInitialHash() ?? 'home';
          _lastReportedHash = hash;
          onHashChange(hash);
        }).toJS;
        // `hashchange` only: browsers fire `popstate` *and* `hashchange` for
        // one fragment navigation, which double-pushed case studies. Every
        // entry the app creates has a distinct hash, so `hashchange` also
        // covers back/forward.
        addEventListener.callAsFunction(_window, 'hashchange'.toJS, callback);
        return () {
          try {
            if (_window.has('removeEventListener')) {
              final removeEventListener =
                  _window.getProperty('removeEventListener'.toJS) as JSFunction;
              removeEventListener.callAsFunction(
                  _window, 'hashchange'.toJS, callback);
            }
          } catch (_) {}
        };
      }
    } catch (_) {}
    return () {};
  }
}
