import 'package:hive/hive.dart';

import '../../domain/entities/badge.dart';

/// Model class for Badge entity with JSON serialization/deserialization
class BadgeModel extends Badge {
  /// Creates a new BadgeModel
  const BadgeModel({
    required super.id,
    required super.name,
    required super.description,
    required super.iconPath,
    required super.category,
    required super.level,
    required super.points,
    super.isEarned = false,
    super.earnedDate,
    super.progress = 0,
    required super.requirements,
  });

  /// Create a BadgeModel from a JSON map
  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      iconPath: json['iconPath'],
      category: json['category'],
      level: json['level'],
      points: json['points'],
      isEarned: json['isEarned'] ?? false,
      earnedDate: json['earnedDate'] != null 
          ? DateTime.parse(json['earnedDate']) 
          : null,
      progress: json['progress'] ?? 0,
      requirements: Map<String, dynamic>.from(json['requirements'] ?? {}),
    );
  }

  /// Convert this BadgeModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconPath': iconPath,
      'category': category,
      'level': level,
      'points': points,
      'isEarned': isEarned,
      'earnedDate': earnedDate?.toIso8601String(),
      'progress': progress,
      'requirements': requirements,
    };
  }

  /// Create a BadgeModel from a Badge entity
  factory BadgeModel.fromEntity(Badge badge) {
    return BadgeModel(
      id: badge.id,
      name: badge.name,
      description: badge.description,
      iconPath: badge.iconPath,
      category: badge.category,
      level: badge.level,
      points: badge.points,
      isEarned: badge.isEarned,
      earnedDate: badge.earnedDate,
      progress: badge.progress,
      requirements: badge.requirements,
    );
  }

  /// Convert to Hive object for storage
  HiveBadge toHiveObject() {
    return HiveBadge(
      id: id,
      name: name,
      description: description,
      iconPath: iconPath,
      category: category,
      level: level,
      points: points,
      isEarned: isEarned,
      earnedDate: earnedDate,
      progress: progress,
      requirements: requirements,
    );
  }

  /// Create from Hive object
  factory BadgeModel.fromHiveObject(HiveBadge hiveObject) {
    return BadgeModel(
      id: hiveObject.id,
      name: hiveObject.name,
      description: hiveObject.description,
      iconPath: hiveObject.iconPath,
      category: hiveObject.category,
      level: hiveObject.level,
      points: hiveObject.points,
      isEarned: hiveObject.isEarned,
      earnedDate: hiveObject.earnedDate,
      progress: hiveObject.progress,
      requirements: Map<String, dynamic>.from(hiveObject.requirements),
    );
  }
}

/// Hive object for Badge storage
class HiveBadge extends HiveObject {
  String id;
  String name;
  String description;
  String iconPath;
  String category;
  String level;
  int points;
  bool isEarned;
  DateTime? earnedDate;
  int progress;
  Map<String, dynamic> requirements;

  HiveBadge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.category,
    required this.level,
    required this.points,
    this.isEarned = false,
    this.earnedDate,
    this.progress = 0,
    required this.requirements,
  });
}
