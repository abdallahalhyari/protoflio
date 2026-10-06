import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/services/analytics_service.dart';
import 'package:profile/core/services/email_service.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    EmailService.instance.reset();
  });

  group('EmailService', () {
    test('isConfigured is false by default without overrides', () {
      expect(EmailService.instance.isConfigured, isFalse);
    });

    test('configure updates credentials and sets isConfigured to true', () {
      EmailService.instance.configure(
        serviceId: 'service_123',
        templateId: 'template_123',
        publicKey: 'key_123',
      );
      expect(EmailService.instance.isConfigured, isTrue);
      expect(EmailService.instance.serviceId, 'service_123');
      expect(EmailService.instance.templateId, 'template_123');
      expect(EmailService.instance.publicKey, 'key_123');
    });

    test('reset clears runtime overrides', () {
      EmailService.instance.configure(
        serviceId: 'service_123',
      );
      expect(EmailService.instance.isConfigured, isTrue);
      EmailService.instance.reset();
      expect(EmailService.instance.isConfigured, isFalse);
    });
  });

  group('SoundService', () {
    test('starts disabled (sound effects are opt-in)', () {
      expect(SoundService.instance.isEnabled.value, isFalse);
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
      expect(SoundService.instance.playClick, returnsNormally);
      SoundService.instance.isEnabled.value = true;
    });
  });

  group('Analytics', () {
    test('event does not throw without Firebase initialized', () {
      expect(() => Analytics.event('test_event'), returnsNormally);
      expect(() => Analytics.screen('TestScreen'), returnsNormally);
      expect(Analytics.ctaEmail, returnsNormally);
      expect(Analytics.ctaCvDownload, returnsNormally);
      expect(() => Analytics.ctaProject('TestCo'), returnsNormally);
      expect(() => Analytics.ctaChapterJump('nathealth', 'architecture'), returnsNormally);
      expect(Analytics.ctaAmmanClock, returnsNormally);
      expect(() => Analytics.ctaContactPreset('Fulltime'), returnsNormally);
      expect(() => Analytics.ctaRoleHatSelect('Architect'), returnsNormally);
    });

    test('setEnabled(false) turns calls into no-ops', () {
      Analytics.setEnabled(false);
      expect(() => Analytics.event('should_be_noop'), returnsNormally);
      Analytics.setEnabled(true);
    });
  });
}
