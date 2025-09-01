import 'package:muslim_habbit/features/skills_hub/domain/entities/resource.dart';
import 'package:muslim_habbit/features/skills_hub/domain/repositories/resource_repository.dart';

/// Use case to add a new resource
class AddResource {
  final ResourceRepository repository;

  AddResource(this.repository);

  /// Add a new resource
  Future<Resource> call(Resource resource) async {
    return await repository.addResource(resource);
  }
}