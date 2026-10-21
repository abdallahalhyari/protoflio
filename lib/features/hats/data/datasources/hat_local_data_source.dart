import 'package:profile/features/hats/data/models/hat_info_model.dart';

abstract class HatLocalDataSource {
  Future<List<HatInfoModel>> getBundledHats();
}

class HatLocalDataSourceImpl implements HatLocalDataSource {
  const HatLocalDataSourceImpl();

  @override
  Future<List<HatInfoModel>> getBundledHats() async {
    return const [];
  }
}
