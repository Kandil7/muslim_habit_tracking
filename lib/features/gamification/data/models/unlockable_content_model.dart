import 'package:hive/hive.dart';

import '../../domain/entities/unlockable_content.dart';

/// Model class for UnlockableContent entity with JSON serialization/deserialization
class UnlockableContentModel extends UnlockableContent {
  /// Creates a new UnlockableContentModel
  const UnlockableContentModel({
    required super.id,
    required super.name,
    required super.description,
    required super.contentType,
    required super.contentPath,
    required super.pointsRequired,
    super.isUnlocked = false,
    super.unlockedDate,
    required super.previewPath,
  });

  /// Create an UnlockableContentModel from a JSON map
  factory UnlockableContentModel.fromJson(Map<String, dynamic> json) {
    return UnlockableContentModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      contentType: json['contentType'],
      contentPath: json['contentPath'],
      pointsRequired: json['pointsRequired'],
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedDate: json['unlockedDate'] != null 
          ? DateTime.parse(json['unlockedDate']) 
          : null,
      previewPath: json['previewPath'],
    );
  }

  /// Convert this UnlockableContentModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'contentType': contentType,
      'contentPath': contentPath,
      'pointsRequired': pointsRequired,
      'isUnlocked': isUnlocked,
      'unlockedDate': unlockedDate?.toIso8601String(),
      'previewPath': previewPath,
    };
  }

  /// Create an UnlockableContentModel from an UnlockableContent entity
  factory UnlockableContentModel.fromEntity(UnlockableContent content) {
    return UnlockableContentModel(
      id: content.id,
      name: content.name,
      description: content.description,
      contentType: content.contentType,
      contentPath: content.contentPath,
      pointsRequired: content.pointsRequired,
      isUnlocked: content.isUnlocked,
      unlockedDate: content.unlockedDate,
      previewPath: content.previewPath,
    );
  }

  /// Convert to Hive object for storage
  HiveUnlockableContent toHiveObject() {
    return HiveUnlockableContent(
      id: id,
      name: name,
      description: description,
      contentType: contentType,
      contentPath: contentPath,
      pointsRequired: pointsRequired,
      isUnlocked: isUnlocked,
      unlockedDate: unlockedDate,
      previewPath: previewPath,
    );
  }

  /// Create from Hive object
  factory UnlockableContentModel.fromHiveObject(HiveUnlockableContent hiveObject) {
    return UnlockableContentModel(
      id: hiveObject.id,
      name: hiveObject.name,
      description: hiveObject.description,
      contentType: hiveObject.contentType,
      contentPath: hiveObject.contentPath,
      pointsRequired: hiveObject.pointsRequired,
      isUnlocked: hiveObject.isUnlocked,
      unlockedDate: hiveObject.unlockedDate,
      previewPath: hiveObject.previewPath,
    );
  }

  @override
  UnlockableContentModel unlock() {
    if (isUnlocked) return this;
    
    return UnlockableContentModel(
      id: id,
      name: name,
      description: description,
      contentType: contentType,
      contentPath: contentPath,
      pointsRequired: pointsRequired,
      isUnlocked: true,
      unlockedDate: DateTime.now(),
      previewPath: previewPath,
    );
  }
}

/// Hive object for UnlockableContent storage
class HiveUnlockableContent extends HiveObject {
  String id;
  String name;
  String description;
  String contentType;
  String contentPath;
  int pointsRequired;
  bool isUnlocked;
  DateTime? unlockedDate;
  String previewPath;

  HiveUnlockableContent({
    required this.id,
    required this.name,
    required this.description,
    required this.contentType,
    required this.contentPath,
    required this.pointsRequired,
    this.isUnlocked = false,
    this.unlockedDate,
    required this.previewPath,
  });
}
