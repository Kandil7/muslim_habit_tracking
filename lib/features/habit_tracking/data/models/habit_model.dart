import 'dart:convert';

import '../../domain/entities/habit.dart';

/// Model class for Habit entity
class HabitModel extends Habit {
  const HabitModel({
    required super.id,
    required super.name,
    required super.description,
    required super.type,
    required super.icon,
    required super.color,
    required super.goal,
    required super.goalUnit,
    required super.daysOfWeek,
    required super.isActive,
    required super.createdAt,
    super.updatedAt,
    super.currentStreak = 0,
    super.longestStreak = 0,
    super.lastCompletedDate,
    super.categoryId,
    super.tags = const [],
    super.targetStreak,
    super.targetCompletionRate,
  });

  /// Create a HabitModel from a JSON map
  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      icon: json['icon'],
      color: json['color'],
      goal: json['goal'],
      goalUnit: json['goalUnit'],
      daysOfWeek: List<String>.from(json['daysOfWeek']),
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      lastCompletedDate:
          json['lastCompletedDate'] != null
              ? DateTime.parse(json['lastCompletedDate'])
              : null,
      categoryId: json['categoryId'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : const [],
      targetStreak: json['targetStreak'],
      targetCompletionRate:
          json['targetCompletionRate'] != null
              ? (json['targetCompletionRate'] as num).toDouble()
              : null,
    );
  }

  /// Convert this HabitModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'icon': icon,
      'color': color,
      'goal': goal,
      'goalUnit': goalUnit,
      'daysOfWeek': daysOfWeek,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastCompletedDate': lastCompletedDate?.toIso8601String(),
      'categoryId': categoryId,
      'tags': tags,
      'targetStreak': targetStreak,
      'targetCompletionRate': targetCompletionRate,
    };
  }

  /// Create a HabitModel from a Habit entity
  factory HabitModel.fromEntity(Habit habit) {
    return HabitModel(
      id: habit.id,
      name: habit.name,
      description: habit.description,
      type: habit.type,
      icon: habit.icon,
      color: habit.color,
      goal: habit.goal,
      goalUnit: habit.goalUnit,
      daysOfWeek: habit.daysOfWeek,
      isActive: habit.isActive,
      createdAt: habit.createdAt,
      updatedAt: habit.updatedAt,
      currentStreak: habit.currentStreak,
      longestStreak: habit.longestStreak,
      lastCompletedDate: habit.lastCompletedDate,
      categoryId: habit.categoryId,
      tags: habit.tags,
      targetStreak: habit.targetStreak,
      targetCompletionRate: habit.targetCompletionRate,
    );
  }

  /// Create a copy of this HabitModel with the given fields replaced with the new values
  @override
  HabitModel copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    String? icon,
    String? color,
    int? goal,
    String? goalUnit,
    List<String>? daysOfWeek,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastCompletedDate,
    bool clearLastCompletedDate = false,
    String? categoryId,
    List<String>? tags,
    int? targetStreak,
    double? targetCompletionRate,
  }) {
    return HabitModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      goal: goal ?? this.goal,
      goalUnit: goalUnit ?? this.goalUnit,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastCompletedDate:
          clearLastCompletedDate
              ? null
              : (lastCompletedDate ?? this.lastCompletedDate),
      categoryId: categoryId ?? this.categoryId,
      tags: tags ?? this.tags,
      targetStreak: targetStreak ?? this.targetStreak,
      targetCompletionRate: targetCompletionRate ?? this.targetCompletionRate,
    );
  }
}
