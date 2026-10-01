import 'package:profile/shared/util/bundled_json.dart';
import 'package:profile/features/hats/model/hat_info.dart';
import 'package:profile/features/hats/domain/repositories/hat_repository.dart';

class LocalHatRepository implements HatRepository {
  List<HatInfo> _hats = [];

  Future<void> load() async {
    final list = await loadBundledJsonList('assets/data/hats.json');
    _hats = List.unmodifiable(
        list.map((e) => HatInfo.fromJson(e as Map<String, dynamic>)));
  }

  @override
  List<HatInfo> getHats() => _hats;

  @override
  int getHatCount() => _hats.length;
}
