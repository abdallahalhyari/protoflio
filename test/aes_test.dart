import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/about/domain/aes.dart';
import 'package:profile/features/about/domain/pbkdf2.dart';

List<int> _h(String s) => [
      for (var i = 0; i < s.length; i += 2)
        int.parse(s.substring(i, i + 2), radix: 16)
    ];

void main() {
  // FIPS-197 appendix C example vectors.
  final plain = _h('00112233445566778899aabbccddeeff');
  const vectors = {
    '000102030405060708090a0b0c0d0e0f': '69c4e0d86a7b0430d8cdb78070b4c55a',
    '000102030405060708090a0b0c0d0e0f1011121314151617':
        'dda97ca4864cdfe06eaf70a0ec0d7191',
    '000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f':
        '8ea2b7ca516745bfeafc49904b496089',
  };

  vectors.forEach((key, expected) {
    test('AES-${key.length * 4} matches the FIPS-197 vector', () {
      final aes = Aes(_h(key));
      final c = aes.encryptBlock(plain);
      expect(Pbkdf2.hex(c), expected);
      expect(aes.decryptBlock(c), plain);
    });
  });

  test('CBC round-trips and a wrong key fails the padding check', () {
    final aes = Aes(List.filled(32, 7));
    final r = aes.encryptCbc('hello, claim 42'.codeUnits);
    expect(String.fromCharCodes(aes.decryptCbc(r.cipher, r.iv)),
        'hello, claim 42');
    expect(() => Aes(List.filled(32, 8)).decryptCbc(r.cipher, r.iv),
        throwsFormatException);
  });
}
