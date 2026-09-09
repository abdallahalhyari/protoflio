import 'dart:js_interop';
import 'dart:js_interop_unsafe';

@JS('window')
external JSObject get _window;

JSObject? _audioCtx;

JSObject? _getAudioContext() {
  if (_audioCtx != null) return _audioCtx;
  try {
    if (_window.has('AudioContext')) {
      final constructor = _window.getProperty('AudioContext'.toJS) as JSFunction;
      _audioCtx = constructor.callAsConstructor();
    } else if (_window.has('webkitAudioContext')) {
      final constructor = _window.getProperty('webkitAudioContext'.toJS) as JSFunction;
      _audioCtx = constructor.callAsConstructor();
    }
  } catch (_) {}
  return _audioCtx;
}

void playWebClick() {
  try {
    final ctx = _getAudioContext();
    if (ctx == null) return;
    
    final state = (ctx.getProperty('state'.toJS) as JSString).toDart;
    if (state == 'suspended') {
      ctx.callMethod('resume'.toJS);
    }
    
    final osc = ctx.callMethod('createOscillator'.toJS) as JSObject;
    final gain = ctx.callMethod('createGain'.toJS) as JSObject;
    final dest = ctx.getProperty('destination'.toJS) as JSObject;
    final currentTime = (ctx.getProperty('currentTime'.toJS) as JSNumber).toDartDouble;
    
    final freq = osc.getProperty('frequency'.toJS) as JSObject;
    freq.callMethod('setValueAtTime'.toJS, 1200.toJS, currentTime.toJS);
    freq.callMethod('exponentialRampToValueAtTime'.toJS, 400.toJS, (currentTime + 0.015).toJS);
    
    final gainNode = gain.getProperty('gain'.toJS) as JSObject;
    gainNode.callMethod('setValueAtTime'.toJS, 0.08.toJS, currentTime.toJS);
    gainNode.callMethod('exponentialRampToValueAtTime'.toJS, 0.0001.toJS, (currentTime + 0.015).toJS);
    
    osc.callMethod('connect'.toJS, gain);
    gain.callMethod('connect'.toJS, dest);
    
    osc.callMethod('start'.toJS, currentTime.toJS);
    osc.callMethod('stop'.toJS, (currentTime + 0.02).toJS);
  } catch (_) {}
}

void playWebPageTurn() {
  try {
    final ctx = _getAudioContext();
    if (ctx == null) return;
    
    final state = (ctx.getProperty('state'.toJS) as JSString).toDart;
    if (state == 'suspended') {
      ctx.callMethod('resume'.toJS);
    }
    
    final osc = ctx.callMethod('createOscillator'.toJS) as JSObject;
    final gain = ctx.callMethod('createGain'.toJS) as JSObject;
    final dest = ctx.getProperty('destination'.toJS) as JSObject;
    final currentTime = (ctx.getProperty('currentTime'.toJS) as JSNumber).toDartDouble;
    
    final freq = osc.getProperty('frequency'.toJS) as JSObject;
    freq.callMethod('setValueAtTime'.toJS, 350.toJS, currentTime.toJS);
    freq.callMethod('exponentialRampToValueAtTime'.toJS, 180.toJS, (currentTime + 0.06).toJS);
    
    final gainNode = gain.getProperty('gain'.toJS) as JSObject;
    gainNode.callMethod('setValueAtTime'.toJS, 0.07.toJS, currentTime.toJS);
    gainNode.callMethod('exponentialRampToValueAtTime'.toJS, 0.0001.toJS, (currentTime + 0.06).toJS);
    
    osc.callMethod('connect'.toJS, gain);
    gain.callMethod('connect'.toJS, dest);
    
    osc.callMethod('start'.toJS, currentTime.toJS);
    osc.callMethod('stop'.toJS, (currentTime + 0.07).toJS);
  } catch (_) {}
}
