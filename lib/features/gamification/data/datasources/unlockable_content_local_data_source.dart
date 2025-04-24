import 'package:hive/hive.dart';

import '../../../../core/error/exceptions.dart';
import '../models/unlockable_content_model.dart';
import 'predefined_unlockable_content.dart';

/// Interface for the local data source for UnlockableContent feature
abstract class UnlockableContentLocalDataSource {
  /// Get all unlockable content
  Future<List<UnlockableContentModel>> getAllContent();
  
  /// Get unlockable content by type
  Future<List<UnlockableContentModel>> getContentByType(String contentType);
  
  /// Get unlocked content
  Future<List<UnlockableContentModel>> getUnlockedContent();
  
  /// Get content by ID
  Future<UnlockableContentModel> getContentById(String id);
  
  /// Unlock content
  Future<UnlockableContentModel> unlockContent(String id);
}

/// Implementation of UnlockableContentLocalDataSource using Hive
class UnlockableContentLocalDataSourceImpl implements UnlockableContentLocalDataSource {
  final Box<HiveUnlockableContent> contentBox;
  
  /// Creates a new UnlockableContentLocalDataSourceImpl
  UnlockableContentLocalDataSourceImpl({required this.contentBox}) {
    _initializeContent();
  }
  
  /// Initialize predefined content if the box is empty
  Future<void> _initializeContent() async {
    if (contentBox.isEmpty) {
      for (final content in PredefinedUnlockableContent.content) {
        await contentBox.put(content.id, content.toHiveObject());
      }
    }
  }
  
  @override
  Future<List<UnlockableContentModel>> getAllContent() async {
    try {
      return contentBox.values
          .map((hiveContent) => UnlockableContentModel.fromHiveObject(hiveContent))
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get content from local storage: $e',
      );
    }
  }
  
  @override
  Future<List<UnlockableContentModel>> getContentByType(String contentType) async {
    try {
      return contentBox.values
          .where((hiveContent) => hiveContent.contentType == contentType)
          .map((hiveContent) => UnlockableContentModel.fromHiveObject(hiveContent))
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get content by type from local storage: $e',
      );
    }
  }
  
  @override
  Future<List<UnlockableContentModel>> getUnlockedContent() async {
    try {
      return contentBox.values
          .where((hiveContent) => hiveContent.isUnlocked)
          .map((hiveContent) => UnlockableContentModel.fromHiveObject(hiveContent))
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get unlocked content from local storage: $e',
      );
    }
  }
  
  @override
  Future<UnlockableContentModel> getContentById(String id) async {
    try {
      final hiveContent = contentBox.get(id);
      if (hiveContent == null) {
        throw CacheException(message: 'Content with ID $id not found');
      }
      return UnlockableContentModel.fromHiveObject(hiveContent);
    } catch (e) {
      throw CacheException(
        message: 'Failed to get content by ID from local storage: $e',
      );
    }
  }
  
  @override
  Future<UnlockableContentModel> unlockContent(String id) async {
    try {
      final hiveContent = contentBox.get(id);
      if (hiveContent == null) {
        throw CacheException(message: 'Content with ID $id not found');
      }
      
      // Update content
      hiveContent.isUnlocked = true;
      hiveContent.unlockedDate = DateTime.now();
      
      // Save to Hive
      await hiveContent.save();
      
      return UnlockableContentModel.fromHiveObject(hiveContent);
    } catch (e) {
      throw CacheException(
        message: 'Failed to unlock content in local storage: $e',
      );
    }
  }
}
