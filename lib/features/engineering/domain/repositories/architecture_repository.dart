import 'package:profile/features/engineering/domain/entities/architecture_topic.dart';

/// Contract for accessing architectural design topics and simulation models.
abstract class ArchitectureRepository {
  List<ArchitectureTopic> getArchitectureTopics();
}
