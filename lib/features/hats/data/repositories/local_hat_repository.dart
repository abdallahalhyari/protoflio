import 'package:profile/features/hats/data/datasources/hat_local_data_source.dart';
import 'package:profile/features/hats/domain/entities/hat_info.dart';
import 'package:profile/features/hats/domain/repositories/hat_repository.dart';

class LocalHatRepository implements HatRepository {
  final HatLocalDataSource dataSource;
  List<HatInfo> _hats = [];

  LocalHatRepository([HatLocalDataSource? dataSource])
      : dataSource = dataSource ?? const HatLocalDataSourceImpl();

  Future<void> load() async {
    _hats = await dataSource.getBundledHats();
  }

  @override
  List<HatInfo> getHats() => _hats;

  @override
  int getHatCount() => _hats.length;
}
