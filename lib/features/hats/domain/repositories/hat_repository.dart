import 'package:profile/features/hats/domain/entities/hat_info.dart';

abstract class HatRepository {
  /// Returns all hats available.
  List<HatInfo> getHats();

  /// Returns the total number of hats.
  int getHatCount();
}
