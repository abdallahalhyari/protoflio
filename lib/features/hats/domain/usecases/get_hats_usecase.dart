import 'package:profile/core/usecases/usecase.dart';
import 'package:profile/features/hats/domain/entities/hat_info.dart';
import 'package:profile/features/hats/domain/repositories/hat_repository.dart';

class GetHatsUseCase implements UseCase<List<HatInfo>, NoParams> {
  final HatRepository repository;

  const GetHatsUseCase(this.repository);

  @override
  List<HatInfo> call(NoParams params) {
    return repository.getHats();
  }

  int getHatCount() => repository.getHatCount();
}
