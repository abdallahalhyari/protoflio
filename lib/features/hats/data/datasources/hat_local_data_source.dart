import 'package:profile/features/hats/data/models/hat_info_model.dart';
import 'package:profile/shared/utils/bundled_json.dart';

abstract class HatLocalDataSource {
  Future<List<HatInfoModel>> getBundledHats();
}

class HatLocalDataSourceImpl implements HatLocalDataSource {
  const HatLocalDataSourceImpl();

  @override
  Future<List<HatInfoModel>> getBundledHats() async {
    final list = await loadBundledJsonList('assets/data/hats.json');
    return List.unmodifiable(
      list.map((e) => HatInfoModel.fromJson(e as Map<String, dynamic>)),
    );
  }
}
