import 'package:equatable/equatable.dart';

/// Habit entity representing a habit to track
class Habit extends Equatable {
  final String id;
  final String name;
  final String description;
  final String type;
  final String icon;
  final String color;
  final int goal;
  final String goalUnit;
  final List<String> daysOfWeek;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastCompletedDate;
  final String? categoryId;
  final List<String> tags;

  // Goal tracking
  final int? targetStreak;
  final double? targetCompletionRate;

  const Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.icon,
    required this.color,
    required this.goal,
    required this.goalUnit,
    required this.daysOfWeek,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastCompletedDate,
    this.categoryId,
    this.tags = const [],
    this.targetStreak,
    this.targetCompletionRate,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    type,
    icon,
    color,
    goal,
    goalUnit,
    daysOfWeek,
    isActive,
    createdAt,
    updatedAt,
    currentStreak,
    longestStreak,
    lastCompletedDate,
    categoryId,
    tags,
    targetStreak,
    targetCompletionRate,
  ];

  /// Create a copy of this Habit with the given fields replaced with the new values
  Habit copyWith({
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
    return Habit(
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
