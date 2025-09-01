import 'package:muslim_habbit/features/skills_hub/domain/entities/resource.dart';
import 'package:muslim_habbit/features/skills_hub/domain/repositories/resource_repository.dart';

/// Use case to search resources
class SearchResources {
  final ResourceRepository repository;

  SearchResources(this.repository);

  /// Search resources by query
  Future<List<Resource>> call(String query) async {
    return await repository.searchResources(query);
  }
}