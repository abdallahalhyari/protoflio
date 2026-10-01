import 'dart:convert';
import 'package:profile/service/remote_data_service.dart';
import 'package:profile/features/hats/model/hat_info.dart';
import 'package:profile/features/hats/domain/repositories/hat_repository.dart';

class LocalHatRepository implements HatRepository {
  List<HatInfo> _hats = [];

  Future<void> load() async {
    final jsonStr =
        await RemoteDataService.instance.fetchJson('assets/data/hats.json');
    final List<dynamic> jsonList = jsonDecode(jsonStr) as List<dynamic>;
    _hats = jsonList
        .map((e) => HatInfo.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  List<HatInfo> getHats() => _hats;

  @override
  int getHatCount() => _hats.length;
}
