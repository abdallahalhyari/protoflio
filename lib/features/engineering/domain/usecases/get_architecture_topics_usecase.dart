import 'package:profile/core/usecases/usecase.dart';
import 'package:profile/features/engineering/domain/entities/architecture_topic.dart';
import 'package:profile/features/engineering/domain/repositories/architecture_repository.dart';

class GetArchitectureTopicsUseCase
    implements UseCase<List<ArchitectureTopic>, NoParams> {
  final ArchitectureRepository repository;

  const GetArchitectureTopicsUseCase(this.repository);

  @override
  List<ArchitectureTopic> call(NoParams params) {
    return repository.getArchitectureTopics();
  }
}
