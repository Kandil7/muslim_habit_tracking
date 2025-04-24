import 'package:hive/hive.dart';

import '../../domain/entities/user_points.dart';

/// Model class for UserPoints entity with JSON serialization/deserialization
class UserPointsModel extends UserPoints {
  /// Creates a new UserPointsModel
  const UserPointsModel({
    super.totalPoints = 0,
    super.level = 1,
    super.pointsToNextLevel = 100,
    super.history = const [],
  });

  /// Create a UserPointsModel from a JSON map
  factory UserPointsModel.fromJson(Map<String, dynamic> json) {
    return UserPointsModel(
      totalPoints: json['totalPoints'] ?? 0,
      level: json['level'] ?? 1,
      pointsToNextLevel: json['pointsToNextLevel'] ?? 100,
      history: (json['history'] as List?)
          ?.map((e) => PointsEntry.fromJson(e))
          .toList() ?? [],
    );
  }

  /// Convert this UserPointsModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'totalPoints': totalPoints,
      'level': level,
      'pointsToNextLevel': pointsToNextLevel,
      'history': history.map((e) => e.toJson()).toList(),
    };
  }

  /// Create a UserPointsModel from a UserPoints entity
  factory UserPointsModel.fromEntity(UserPoints userPoints) {
    return UserPointsModel(
      totalPoints: userPoints.totalPoints,
      level: userPoints.level,
      pointsToNextLevel: userPoints.pointsToNextLevel,
      history: userPoints.history,
    );
  }

  /// Convert to Hive object for storage
  HiveUserPoints toHiveObject() {
    return HiveUserPoints(
      totalPoints: totalPoints,
      level: level,
      pointsToNextLevel: pointsToNextLevel,
      history: history.map((e) => HivePointsEntry(
        points: e.points,
        reason: e.reason,
        timestamp: e.timestamp,
      )).toList(),
    );
  }

  /// Create from Hive object
  factory UserPointsModel.fromHiveObject(HiveUserPoints hiveObject) {
    return UserPointsModel(
      totalPoints: hiveObject.totalPoints,
      level: hiveObject.level,
      pointsToNextLevel: hiveObject.pointsToNextLevel,
      history: hiveObject.history.map((e) => PointsEntry(
        points: e.points,
        reason: e.reason,
        timestamp: e.timestamp,
      )).toList(),
    );
  }

  @override
  UserPointsModel addPoints(int points, String reason) {
    final updatedEntity = super.addPoints(points, reason);
    return UserPointsModel.fromEntity(updatedEntity);
  }
}

/// Hive object for UserPoints storage
class HiveUserPoints extends HiveObject {
  int totalPoints;
  int level;
  int pointsToNextLevel;
  List<HivePointsEntry> history;

  HiveUserPoints({
    this.totalPoints = 0,
    this.level = 1,
    this.pointsToNextLevel = 100,
    this.history = const [],
  });
}

/// Hive object for PointsEntry storage
class HivePointsEntry {
  int points;
  String reason;
  DateTime timestamp;

  HivePointsEntry({
    required this.points,
    required this.reason,
    required this.timestamp,
  });
}
