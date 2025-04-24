import 'package:equatable/equatable.dart';

/// UserPoints entity representing a user's points and level
class UserPoints extends Equatable {
  /// Total points accumulated by the user
  final int totalPoints;
  
  /// Current level of the user
  final int level;
  
  /// Points needed to reach the next level
  final int pointsToNextLevel;
  
  /// Points history with timestamps and reasons
  final List<PointsEntry> history;

  /// Creates a new UserPoints
  const UserPoints({
    this.totalPoints = 0,
    this.level = 1,
    this.pointsToNextLevel = 100,
    this.history = const [],
  });

  @override
  List<Object> get props => [totalPoints, level, pointsToNextLevel, history];

  /// Create a copy of this UserPoints with the given fields replaced with the new values
  UserPoints copyWith({
    int? totalPoints,
    int? level,
    int? pointsToNextLevel,
    List<PointsEntry>? history,
  }) {
    return UserPoints(
      totalPoints: totalPoints ?? this.totalPoints,
      level: level ?? this.level,
      pointsToNextLevel: pointsToNextLevel ?? this.pointsToNextLevel,
      history: history ?? this.history,
    );
  }

  /// Add points to the user's total
  UserPoints addPoints(int points, String reason) {
    final newTotal = totalPoints + points;
    final entry = PointsEntry(
      points: points,
      reason: reason,
      timestamp: DateTime.now(),
    );
    
    // Calculate new level and points to next level
    int newLevel = level;
    int newPointsToNextLevel = pointsToNextLevel - points;
    
    // Level up if necessary
    while (newPointsToNextLevel <= 0) {
      newLevel++;
      // Each level requires more points (level * 100)
      final pointsForNextLevel = newLevel * 100;
      newPointsToNextLevel += pointsForNextLevel;
    }
    
    return UserPoints(
      totalPoints: newTotal,
      level: newLevel,
      pointsToNextLevel: newPointsToNextLevel,
      history: [...history, entry],
    );
  }
}

/// PointsEntry represents a single points transaction
class PointsEntry extends Equatable {
  /// Number of points (positive for earned, negative for spent)
  final int points;
  
  /// Reason for the points transaction
  final String reason;
  
  /// When the points were earned or spent
  final DateTime timestamp;

  /// Creates a new PointsEntry
  const PointsEntry({
    required this.points,
    required this.reason,
    required this.timestamp,
  });

  @override
  List<Object> get props => [points, reason, timestamp];

  /// Create a PointsEntry from a JSON map
  factory PointsEntry.fromJson(Map<String, dynamic> json) {
    return PointsEntry(
      points: json['points'],
      reason: json['reason'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  /// Convert this PointsEntry to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'points': points,
      'reason': reason,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
