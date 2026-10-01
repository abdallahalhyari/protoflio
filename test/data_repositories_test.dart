import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/experience/data/repositories/local_experience_repository.dart';
import 'package:profile/features/hats/data/repositories/local_hat_repository.dart';
import 'package:profile/features/projects/data/repositories/local_project_repository.dart';
import 'package:profile/features/skills/data/repositories/local_skill_repository.dart';
import 'package:profile/shared/util/bundled_json.dart';

import 'helpers/real_data.dart';

/// An asset bundle whose first [failures] loads throw, like a dropped
/// request on a flaky connection.
class _FlakyBundle extends CachingAssetBundle {
  _FlakyBundle(this.text, {this.failures = 0});

  final String text;
  int failures;
  int calls = 0;

  @override
  Future<ByteData> load(String key) async {
    calls++;
    if (failures > 0) {
      failures--;
      throw FlutterError('Unable to load asset: $key');
    }
    return ByteData.sublistView(Uint8List.fromList(text.codeUnits));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // The app's own load paths (asset keys, parsing), not the test helpers'
  // copy of them: a mistyped path here used to pass CI and blank the site.
  group('Local repositories load the bundled content', () {
    test('projects', () async {
      final repo = LocalProjectRepository();
      await repo.load();
      expect(repo.getProjectCount(), RealProjectRepository().getProjectCount());
      expect(repo.getProjectCount(), greaterThan(0));
    });

    test('skills', () async {
      final repo = LocalSkillRepository();
      await repo.load();
      expect(repo.getSkillCount(), RealSkillRepository().getSkillCount());
      expect(repo.getSkillCount(), greaterThan(0));
    });

    test('hats', () async {
      final repo = LocalHatRepository();
      await repo.load();
      expect(repo.getHatCount(), RealHatRepository().getHatCount());
      expect(repo.getHatCount(), greaterThan(0));
    });

    test('experience, education and certifications', () async {
      final repo = LocalExperienceRepository();
      await repo.load();
      final real = RealExperienceRepository();
      expect(repo.getExperiences().length, real.getExperiences().length);
      expect(repo.getEducation().length, real.getEducation().length);
      expect(repo.getCertifications(), real.getCertifications());
      expect(repo.getExperiences(), isNotEmpty);
    });

    test('loaded lists cannot be changed by callers', () async {
      final repo = LocalSkillRepository();
      await repo.load();
      expect(() => repo.getSkills().clear(), throwsUnsupportedError);
    });
  });

  group('loadBundledJsonList', () {
    test('retries a dropped request', () async {
      final bundle = _FlakyBundle('[1, 2]', failures: 2);
      final list = await loadBundledJsonList('x.json',
          bundle: bundle, retryDelay: Duration.zero);
      expect(list, [1, 2]);
      expect(bundle.calls, 3);
    });

    test('gives up after the last attempt', () async {
      final bundle = _FlakyBundle('[]', failures: 5);
      await expectLater(
        loadBundledJsonList('x.json',
            bundle: bundle, retryDelay: Duration.zero),
        throwsA(isA<FlutterError>()),
      );
      expect(bundle.calls, 3);
    });

    test('does not retry malformed content', () async {
      final bundle = _FlakyBundle('{not json');
      await expectLater(
        loadBundledJsonList('x.json',
            bundle: bundle, retryDelay: Duration.zero),
        throwsA(isA<FormatException>()),
      );
      expect(bundle.calls, 1);
    });
  });
}
