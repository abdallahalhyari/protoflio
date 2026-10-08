import 'dart:convert';
import 'dart:typed_data';

/// PBKDF2-HMAC-SHA256 in plain Dart, for the key-derivation demo.
///
/// Written for clarity and to run in the browser: every shift keeps its
/// intermediate under 2^32, so results are identical on the web, where
/// integers are doubles, and on the VM.
abstract final class Pbkdf2 {
  static const int _mask = 0xFFFFFFFF;

  static const List<int> _k = [
    0x428a2f98,
    0x71374491,
    0xb5c0fbcf,
    0xe9b5dba5,
    0x3956c25b,
    0x59f111f1,
    0x923f82a4,
    0xab1c5ed5,
    0xd807aa98,
    0x12835b01,
    0x243185be,
    0x550c7dc3,
    0x72be5d74,
    0x80deb1fe,
    0x9bdc06a7,
    0xc19bf174,
    0xe49b69c1,
    0xefbe4786,
    0x0fc19dc6,
    0x240ca1cc,
    0x2de92c6f,
    0x4a7484aa,
    0x5cb0a9dc,
    0x76f988da,
    0x983e5152,
    0xa831c66d,
    0xb00327c8,
    0xbf597fc7,
    0xc6e00bf3,
    0xd5a79147,
    0x06ca6351,
    0x14292967,
    0x27b70a85,
    0x2e1b2138,
    0x4d2c6dfc,
    0x53380d13,
    0x650a7354,
    0x766a0abb,
    0x81c2c92e,
    0x92722c85,
    0xa2bfe8a1,
    0xa81a664b,
    0xc24b8b70,
    0xc76c51a3,
    0xd192e819,
    0xd6990624,
    0xf40e3585,
    0x106aa070,
    0x19a4c116,
    0x1e376c08,
    0x2748774c,
    0x34b0bcb5,
    0x391c0cb3,
    0x4ed8aa4a,
    0x5b9cca4f,
    0x682e6ff3,
    0x748f82ee,
    0x78a5636f,
    0x84c87814,
    0x8cc70208,
    0x90befffa,
    0xa4506ceb,
    0xbef9a3f7,
    0xc67178f2,
  ];

  static const List<int> _iv = [
    0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, //
    0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19,
  ];

  static int _rotr(int x, int n) =>
      (x >>> n) | ((x & ((1 << n) - 1)) << (32 - n));

  static void _compress(Uint32List h, Uint32List w) {
    for (var i = 16; i < 64; i++) {
      final a = w[i - 15];
      final b = w[i - 2];
      final s0 = _rotr(a, 7) ^ _rotr(a, 18) ^ (a >>> 3);
      final s1 = _rotr(b, 17) ^ _rotr(b, 19) ^ (b >>> 10);
      w[i] = (w[i - 16] + s0 + w[i - 7] + s1) & _mask;
    }
    var a = h[0], b = h[1], c = h[2], d = h[3];
    var e = h[4], f = h[5], g = h[6], hh = h[7];
    for (var i = 0; i < 64; i++) {
      final s1 = _rotr(e, 6) ^ _rotr(e, 11) ^ _rotr(e, 25);
      final ch = (e & f) ^ ((~e & _mask) & g);
      final t1 = (hh + s1 + ch + _k[i] + w[i]) & _mask;
      final s0 = _rotr(a, 2) ^ _rotr(a, 13) ^ _rotr(a, 22);
      final maj = (a & b) ^ (a & c) ^ (b & c);
      final t2 = (s0 + maj) & _mask;
      hh = g;
      g = f;
      f = e;
      e = (d + t1) & _mask;
      d = c;
      c = b;
      b = a;
      a = (t1 + t2) & _mask;
    }
    h[0] = (h[0] + a) & _mask;
    h[1] = (h[1] + b) & _mask;
    h[2] = (h[2] + c) & _mask;
    h[3] = (h[3] + d) & _mask;
    h[4] = (h[4] + e) & _mask;
    h[5] = (h[5] + f) & _mask;
    h[6] = (h[6] + g) & _mask;
    h[7] = (h[7] + hh) & _mask;
  }

  static void _loadBlock(List<int> bytes, int offset, Uint32List w) {
    for (var i = 0; i < 16; i++) {
      final o = offset + i * 4;
      w[i] = (bytes[o] << 24) |
          (bytes[o + 1] << 16) |
          (bytes[o + 2] << 8) |
          bytes[o + 3];
    }
  }

  /// SHA-256 of [data].
  static Uint8List sha256(List<int> data) {
    final h = Uint32List.fromList(_iv);
    final padded = _pad(data, data.length);
    final w = Uint32List(64);
    for (var o = 0; o < padded.length; o += 64) {
      _loadBlock(padded, o, w);
      _compress(h, w);
    }
    return _digest(h);
  }

  static Uint8List _pad(List<int> data, int totalLength) {
    final bitLen = totalLength * 8;
    final padLen = ((data.length + 9 + 63) ~/ 64) * 64;
    final out = Uint8List(padLen)..setRange(0, data.length, data);
    out[data.length] = 0x80;
    // 64-bit big-endian length; the high word stays zero for demo sizes.
    out[padLen - 4] = (bitLen >>> 24) & 0xFF;
    out[padLen - 3] = (bitLen >>> 16) & 0xFF;
    out[padLen - 2] = (bitLen >>> 8) & 0xFF;
    out[padLen - 1] = bitLen & 0xFF;
    return out;
  }

  static Uint8List _digest(Uint32List h) {
    final out = Uint8List(32);
    for (var i = 0; i < 8; i++) {
      out[i * 4] = h[i] >>> 24;
      out[i * 4 + 1] = (h[i] >>> 16) & 0xFF;
      out[i * 4 + 2] = (h[i] >>> 8) & 0xFF;
      out[i * 4 + 3] = h[i] & 0xFF;
    }
    return out;
  }

  /// Derives a 32-byte key. Yields to the event loop every [chunk]
  /// iterations so the page stays responsive; [onProgress] gets 0..1.
  static Future<Uint8List> derive({
    required String password,
    required String salt,
    required int iterations,
    int chunk = 1500,
    void Function(double progress)? onProgress,
  }) async {
    var key = utf8.encode(password);
    if (key.length > 64) key = sha256(key);
    final keyBlock = Uint8List(64)..setRange(0, key.length, key);
    final ipad = Uint8List(64);
    final opad = Uint8List(64);
    for (var i = 0; i < 64; i++) {
      ipad[i] = keyBlock[i] ^ 0x36;
      opad[i] = keyBlock[i] ^ 0x5c;
    }

    // Chaining state after the key block: shared by every HMAC call.
    final innerState = Uint32List.fromList(_iv);
    final outerState = Uint32List.fromList(_iv);
    final w = Uint32List(64);
    _loadBlock(ipad, 0, w);
    _compress(innerState, w);
    _loadBlock(opad, 0, w);
    _compress(outerState, w);

    Uint8List hmac32(Uint8List message32) {
      final h = Uint32List.fromList(innerState);
      for (var i = 0; i < 8; i++) {
        w[i] = (message32[i * 4] << 24) |
            (message32[i * 4 + 1] << 16) |
            (message32[i * 4 + 2] << 8) |
            message32[i * 4 + 3];
      }
      w[8] = 0x80000000;
      for (var i = 9; i < 15; i++) {
        w[i] = 0;
      }
      w[15] = (64 + 32) * 8;
      _compress(h, w);
      final inner = _digest(h);
      final o = Uint32List.fromList(outerState);
      for (var i = 0; i < 8; i++) {
        w[i] = (inner[i * 4] << 24) |
            (inner[i * 4 + 1] << 16) |
            (inner[i * 4 + 2] << 8) |
            inner[i * 4 + 3];
      }
      w[8] = 0x80000000;
      for (var i = 9; i < 15; i++) {
        w[i] = 0;
      }
      w[15] = (64 + 32) * 8;
      _compress(o, w);
      return _digest(o);
    }

    // U1 = HMAC(P, salt || INT(1)); the message is not a fixed 32 bytes.
    final saltBytes = utf8.encode(salt);
    final msg = Uint8List(saltBytes.length + 4)
      ..setRange(0, saltBytes.length, saltBytes)
      ..[saltBytes.length + 3] = 1;
    final innerData = Uint8List(64 + msg.length)
      ..setRange(0, 64, ipad)
      ..setRange(64, 64 + msg.length, msg);
    final u1Inner = sha256(innerData);
    final outerData = Uint8List(96)
      ..setRange(0, 64, opad)
      ..setRange(64, 96, u1Inner);
    var u = sha256(outerData);
    final t = Uint8List.fromList(u);

    for (var i = 2; i <= iterations; i++) {
      u = hmac32(u);
      for (var j = 0; j < 32; j++) {
        t[j] ^= u[j];
      }
      if (i % chunk == 0) {
        onProgress?.call(i / iterations);
        await Future<void>.delayed(Duration.zero);
      }
    }
    onProgress?.call(1);
    return t;
  }

  static String hex(List<int> bytes) =>
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}
