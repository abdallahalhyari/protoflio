import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/shared/widget/retrying_asset_image.dart';

// 1×1 transparent PNG.
final Uint8List _png = Uint8List.fromList(const [
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);

/// Fails the first [failures] loads of the image, then serves [_png].
class _FlakyBundle extends CachingAssetBundle {
  _FlakyBundle(this.failures);
  int failures;
  int imageLoads = 0;

  @override
  Future<ByteData> load(String key) async {
    if (key == 'AssetManifest.bin') {
      return const StandardMessageCodec().encodeMessage(<String, Object>{})!;
    }
    imageLoads++;
    if (failures > 0) {
      failures--;
      throw FlutterError('network dropped');
    }
    return ByteData.sublistView(_png);
  }
}

void main() {
  testWidgets('recovers from a transient asset fetch failure', (tester) async {
    final bundle = _FlakyBundle(1);
    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: bundle,
        child: const Center(
          child: SizedBox(
            width: 10,
            height: 10,
            child: RetryingAssetImage('flaky.png'),
          ),
        ),
      ),
    );

    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();
    expect(bundle.imageLoads, 1);

    // Retry fires after the backoff and loads successfully.
    await tester.pump(const Duration(milliseconds: 900));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();
    expect(bundle.imageLoads, 2);
    final image = tester.widget<Image>(find.byType(Image));
    expect(image.key, const ValueKey(1));
  });
}
