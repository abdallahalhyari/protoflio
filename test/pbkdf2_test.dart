import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/about/domain/pbkdf2.dart';

void main() {
  // RFC 7914 / widely published PBKDF2-HMAC-SHA256 vectors.
  const vectors = {
    1: '120fb6cffcf8b32c43e7225256c4f837a86548c92ccc35480805987cb70be17b',
    2: 'ae4d0c95af6b46d32d0adff928f06dd02a303f8ef3c251dfd6e2d85a95474c43',
    4096: 'c5e478d59288c841aa530db6845c4c8d962893a001ce4e11a4963873aa98134a',
  };

  vectors.forEach((iterations, expected) {
    test('PBKDF2-HMAC-SHA256 matches the vector for $iterations iteration(s)',
        () async {
      final key = await Pbkdf2.derive(
        password: 'password',
        salt: 'salt',
        iterations: iterations,
      );
      expect(Pbkdf2.hex(key), expected);
    });
  });
}
