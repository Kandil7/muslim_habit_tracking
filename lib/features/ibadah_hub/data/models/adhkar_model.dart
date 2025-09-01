import 'package:muslim_habbit/features/ibadah_hub/domain/entities/adhkar.dart';

/// Data model for Adhkar that extends the entity with serialization methods
class AdhkarModel extends Adhkar {
  const AdhkarModel({
    required super.id,
    required super.text,
    super.transliteration,
    super.translation,
    required super.targetCount,
    required super.currentCount,
    required super.category,
    required super.isCompleted,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Factory method to create from entity
  factory AdhkarModel.fromEntity(Adhkar entity) {
    return AdhkarModel(
      id: entity.id,
      text: entity.text,
      transliteration: entity.transliteration,
      translation: entity.translation,
      targetCount: entity.targetCount,
      currentCount: entity.currentCount,
      category: entity.category,
      isCompleted: entity.isCompleted,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Factory method to create from JSON
  factory AdhkarModel.fromJson(Map<String, dynamic> json) {
    return AdhkarModel(
      id: json['id'] as String,
      text: json['text'] as String,
      transliteration: json['transliteration'] as String?,
      translation: json['translation'] as String?,
      targetCount: json['targetCount'] as int,
      currentCount: json['currentCount'] as int,
      category: _categoryFromString(json['category'] as String),
      isCompleted: json['isCompleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'transliteration': transliteration,
      'translation': translation,
      'targetCount': targetCount,
      'currentCount': currentCount,
      'category': _categoryToString(category),
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Convert category to string
  String _categoryToString(AdhkarCategory category) {
    switch (category) {
      case AdhkarCategory.morning:
        return 'morning';
      case AdhkarCategory.evening:
        return 'evening';
      case AdhkarCategory.afterPrayer:
        return 'afterPrayer';
      case AdhkarCategory.general:
        return 'general';
    }
  }

  /// Convert string to category
  static AdhkarCategory _categoryFromString(String category) {
    switch (category) {
      case 'morning':
        return AdhkarCategory.morning;
      case 'evening':
        return AdhkarCategory.evening;
      case 'afterPrayer':
        return AdhkarCategory.afterPrayer;
      case 'general':
        return AdhkarCategory.general;
      default:
        return AdhkarCategory.general;
    }
  }
}