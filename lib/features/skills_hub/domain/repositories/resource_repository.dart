import 'package:muslim_habbit/features/skills_hub/domain/entities/resource.dart';

/// Repository interface for resource management
abstract class ResourceRepository {
  /// Add a new resource
  Future<Resource> addResource(Resource resource);

  /// Get all resources
  Future<List<Resource>> getAllResources();

  /// Get resource by ID
  Future<Resource?> getResourceById(String id);

  /// Update resource
  Future<Resource> updateResource(Resource resource);

  /// Delete resource
  Future<void> deleteResource(String id);

  /// Get resources by tag
  Future<List<Resource>> getResourcesByTag(String tag);

  /// Get favorite resources
  Future<List<Resource>> getFavoriteResources();

  /// Search resources by query
  Future<List<Resource>> searchResources(String query);

  /// Get resources by type
  Future<List<Resource>> getResourcesByType(ResourceType type);
}