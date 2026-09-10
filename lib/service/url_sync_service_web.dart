import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'url_sync_service.dart';

UrlSyncService createUrlSyncService() => UrlSyncServiceWeb();

@JS('window')
external JSObject get _window;

class UrlSyncServiceWeb extends UrlSyncService {
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
  void updateHash(String hash) {
    try {
      if (_window.has('history')) {
        final history = _window.getProperty('history'.toJS) as JSObject;
        if (history.has('replaceState')) {
          final replaceState = history.getProperty('replaceState'.toJS) as JSFunction;
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
  void listenToHashChanges(void Function(String hash) onHashChange) {
    try {
      if (_window.has('addEventListener')) {
        final addEventListener = _window.getProperty('addEventListener'.toJS) as JSFunction;
        final callback = ((JSAny? event) {
          final hash = getInitialHash() ?? 'home';
          onHashChange(hash);
        }).toJS;
        addEventListener.callAsFunction(_window, 'hashchange'.toJS, callback);
        addEventListener.callAsFunction(_window, 'popstate'.toJS, callback);
      }
    } catch (_) {}
  }
}
