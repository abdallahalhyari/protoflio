import 'package:flutter_test/flutter_test.dart';
import 'package:profile/service/analytics_service.dart';
import 'package:profile/service/sound_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('SoundService', () {
    test('starts enabled', () {
      expect(SoundService.instance.isEnabled.value, isTrue);
    });

    test('toggle flips isEnabled', () async {
      final start = SoundService.instance.isEnabled.value;
      SoundService.instance.toggle();
      expect(SoundService.instance.isEnabled.value, !start);
      SoundService.instance.toggle();
      expect(SoundService.instance.isEnabled.value, start);
    });

    test('load restores persisted preference', () async {
      SharedPreferences.setMockInitialValues({'soundEnabled': false});
      await SoundService.instance.load();
      expect(SoundService.instance.isEnabled.value, isFalse);

      // Restore
      SharedPreferences.setMockInitialValues({'soundEnabled': true});
      await SoundService.instance.load();
      expect(SoundService.instance.isEnabled.value, isTrue);
    });

    test('playClick is a no-op when disabled', () {
      SoundService.instance.isEnabled.value = false;
      expect(() => SoundService.instance.playClick(), returnsNormally);
      SoundService.instance.isEnabled.value = true;
    });
  });

  group('Analytics', () {
    test('event does not throw without Firebase initialized', () {
      expect(() => Analytics.event('test_event'), returnsNormally);
      expect(() => Analytics.screen('TestScreen'), returnsNormally);
      expect(() => Analytics.ctaEmail(), returnsNormally);
      expect(() => Analytics.ctaCvDownload(), returnsNormally);
      expect(() => Analytics.ctaProject('TestCo'), returnsNormally);
    });

    test('setEnabled(false) turns calls into no-ops', () {
      Analytics.setEnabled(false);
      expect(() => Analytics.event('should_be_noop'), returnsNormally);
      Analytics.setEnabled(true);
    });
  });
}
