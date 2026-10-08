import 'dart:math';
import 'dart:typed_data';

/// AES (128 / 192 / 256-bit keys) with CBC mode and PKCS#7 padding, in plain
/// Dart for the encryption demo. The S-box is computed, not typed in, so
/// there is no table to get wrong. Checked against the FIPS-197 vectors.
///
/// CBC gives confidentiality only. It does not detect tampering; real
/// systems add a MAC or use an AEAD mode such as GCM.
class Aes {
  Aes(List<int> key) : _rounds = _roundsFor(key.length) {
    _roundKeys = _expandKey(Uint8List.fromList(key));
  }

  final int _rounds;
  late final List<Uint8List> _roundKeys;

  static final Uint8List _sbox = Uint8List(256);
  static final Uint8List _inv = Uint8List(256);
  static bool _ready = false;

  static int _roundsFor(int keyLen) => switch (keyLen) {
        16 => 10,
        24 => 12,
        32 => 14,
        _ => throw ArgumentError('AES key must be 16, 24 or 32 bytes'),
      };

  static int _xtime(int a) => ((a << 1) ^ ((a & 0x80) != 0 ? 0x1b : 0)) & 0xff;

  static int _mul(int a, int b) {
    var r = 0;
    var x = a;
    var y = b;
    while (y > 0) {
      if (y & 1 != 0) r ^= x;
      x = _xtime(x);
      y >>= 1;
    }
    return r;
  }

  static void _init() {
    if (_ready) return;
    // Multiplicative inverse in GF(2^8), then the affine transform.
    final inverse = Uint8List(256);
    for (var a = 1; a < 256; a++) {
      for (var b = 1; b < 256; b++) {
        if (_mul(a, b) == 1) {
          inverse[a] = b;
          break;
        }
      }
    }
    for (var i = 0; i < 256; i++) {
      final b = inverse[i];
      var s = b;
      for (var k = 1; k <= 4; k++) {
        s ^= ((b << k) | (b >> (8 - k))) & 0xff;
      }
      s ^= 0x63;
      _sbox[i] = s;
      _inv[s] = i;
    }
    _ready = true;
  }

  List<Uint8List> _expandKey(Uint8List key) {
    _init();
    final nk = key.length ~/ 4;
    final words = <Uint8List>[];
    for (var i = 0; i < nk; i++) {
      words.add(Uint8List.fromList(key.sublist(i * 4, i * 4 + 4)));
    }
    var rcon = 1;
    for (var i = nk; i < 4 * (_rounds + 1); i++) {
      final t = Uint8List.fromList(words[i - 1]);
      if (i % nk == 0) {
        final f = t[0];
        t[0] = _sbox[t[1]] ^ rcon;
        t[1] = _sbox[t[2]];
        t[2] = _sbox[t[3]];
        t[3] = _sbox[f];
        rcon = _xtime(rcon);
      } else if (nk > 6 && i % nk == 4) {
        for (var j = 0; j < 4; j++) {
          t[j] = _sbox[t[j]];
        }
      }
      final w = Uint8List(4);
      for (var j = 0; j < 4; j++) {
        w[j] = words[i - nk][j] ^ t[j];
      }
      words.add(w);
    }
    return [
      for (var r = 0; r <= _rounds; r++)
        Uint8List.fromList([for (var c = 0; c < 4; c++) ...words[r * 4 + c]]),
    ];
  }

  void _addKey(Uint8List s, int round) {
    final k = _roundKeys[round];
    for (var i = 0; i < 16; i++) {
      s[i] ^= k[i];
    }
  }

  /// Encrypts one 16-byte block.
  Uint8List encryptBlock(List<int> block) {
    final s = Uint8List.fromList(block);
    _addKey(s, 0);
    for (var r = 1; r <= _rounds; r++) {
      for (var i = 0; i < 16; i++) {
        s[i] = _sbox[s[i]];
      }
      _shiftRows(s);
      if (r != _rounds) _mixColumns(s);
      _addKey(s, r);
    }
    return s;
  }

  /// Decrypts one 16-byte block.
  Uint8List decryptBlock(List<int> block) {
    final s = Uint8List.fromList(block);
    _addKey(s, _rounds);
    for (var r = _rounds - 1; r >= 0; r--) {
      _invShiftRows(s);
      for (var i = 0; i < 16; i++) {
        s[i] = _inv[s[i]];
      }
      _addKey(s, r);
      if (r != 0) _invMixColumns(s);
    }
    return s;
  }

  // State is column-major: byte i sits at row i % 4, column i ~/ 4.
  static void _shiftRows(Uint8List s) {
    final t = Uint8List.fromList(s);
    for (var c = 0; c < 4; c++) {
      for (var r = 0; r < 4; r++) {
        s[c * 4 + r] = t[((c + r) % 4) * 4 + r];
      }
    }
  }

  static void _invShiftRows(Uint8List s) {
    final t = Uint8List.fromList(s);
    for (var c = 0; c < 4; c++) {
      for (var r = 0; r < 4; r++) {
        s[((c + r) % 4) * 4 + r] = t[c * 4 + r];
      }
    }
  }

  static void _mixColumns(Uint8List s) {
    for (var c = 0; c < 4; c++) {
      final a = s.sublist(c * 4, c * 4 + 4);
      s[c * 4] = _mul(a[0], 2) ^ _mul(a[1], 3) ^ a[2] ^ a[3];
      s[c * 4 + 1] = a[0] ^ _mul(a[1], 2) ^ _mul(a[2], 3) ^ a[3];
      s[c * 4 + 2] = a[0] ^ a[1] ^ _mul(a[2], 2) ^ _mul(a[3], 3);
      s[c * 4 + 3] = _mul(a[0], 3) ^ a[1] ^ a[2] ^ _mul(a[3], 2);
    }
  }

  static void _invMixColumns(Uint8List s) {
    for (var c = 0; c < 4; c++) {
      final a = s.sublist(c * 4, c * 4 + 4);
      s[c * 4] =
          _mul(a[0], 14) ^ _mul(a[1], 11) ^ _mul(a[2], 13) ^ _mul(a[3], 9);
      s[c * 4 + 1] =
          _mul(a[0], 9) ^ _mul(a[1], 14) ^ _mul(a[2], 11) ^ _mul(a[3], 13);
      s[c * 4 + 2] =
          _mul(a[0], 13) ^ _mul(a[1], 9) ^ _mul(a[2], 14) ^ _mul(a[3], 11);
      s[c * 4 + 3] =
          _mul(a[0], 11) ^ _mul(a[1], 13) ^ _mul(a[2], 9) ^ _mul(a[3], 14);
    }
  }

  /// CBC + PKCS#7. A fresh random IV is generated unless [iv] is given.
  ({Uint8List iv, Uint8List cipher}) encryptCbc(List<int> plain,
      {List<int>? iv}) {
    final ivBytes = Uint8List.fromList(
        iv ?? List<int>.generate(16, (_) => Random.secure().nextInt(256)));
    final pad = 16 - plain.length % 16;
    final data = Uint8List.fromList([...plain, ...List.filled(pad, pad)]);
    final out = Uint8List(data.length);
    var prev = ivBytes;
    for (var o = 0; o < data.length; o += 16) {
      final block = Uint8List(16);
      for (var i = 0; i < 16; i++) {
        block[i] = data[o + i] ^ prev[i];
      }
      prev = encryptBlock(block);
      out.setRange(o, o + 16, prev);
    }
    return (iv: ivBytes, cipher: out);
  }

  /// Throws [FormatException] when the padding is invalid, which is what a
  /// wrong key usually produces.
  Uint8List decryptCbc(List<int> cipher, List<int> iv) {
    if (cipher.isEmpty || cipher.length % 16 != 0) {
      throw const FormatException('Ciphertext length is not a block multiple');
    }
    final out = Uint8List(cipher.length);
    var prev = iv;
    for (var o = 0; o < cipher.length; o += 16) {
      final block = cipher.sublist(o, o + 16);
      final dec = decryptBlock(block);
      for (var i = 0; i < 16; i++) {
        out[o + i] = dec[i] ^ prev[i];
      }
      prev = block;
    }
    final pad = out.last;
    if (pad < 1 || pad > 16 || pad > out.length) {
      throw const FormatException('Invalid padding');
    }
    for (var i = out.length - pad; i < out.length; i++) {
      if (out[i] != pad) throw const FormatException('Invalid padding');
    }
    return Uint8List.sublistView(out, 0, out.length - pad);
  }
}
