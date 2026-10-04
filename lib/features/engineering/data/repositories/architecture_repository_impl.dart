import 'package:profile/features/engineering/data/datasources/architecture_data.dart';
import 'package:profile/features/engineering/domain/entities/architecture_topic.dart';
import 'package:profile/features/engineering/domain/repositories/architecture_repository.dart';

class ArchitectureRepositoryImpl implements ArchitectureRepository {
  const ArchitectureRepositoryImpl();

  @override
  List<ArchitectureTopic> getArchitectureTopics() => kArchitectureTopics;
}
