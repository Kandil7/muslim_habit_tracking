import 'package:equatable/equatable.dart';

/// Entity representing a personal goal
class Goal extends Equatable {
  final String id;
  final String title;
  final String description;
  final GoalArea area; // Self, Ibadah, Skills
  final GoalType type; // Daily, Weekly, Monthly, Long-term
  final DateTime startDate;
  final DateTime? targetDate;
  final int targetValue; // For measurable goals
  final int currentValue; // Current progress
  final GoalStatus status;
  final List<String> tags;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.area,
    required this.type,
    required this.startDate,
    this.targetDate,
    required this.targetValue,
    required this.currentValue,
    required this.status,
    required this.tags,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        area,
        type,
        startDate,
        targetDate,
        targetValue,
        currentValue,
        status,
        tags,
        isFavorite,
        createdAt,
        updatedAt,
      ];

  Goal copyWith({
    String? id,
    String? title,
    String? description,
    GoalArea? area,
    GoalType? type,
    DateTime? startDate,
    DateTime? targetDate,
    int? targetValue,
    int? currentValue,
    GoalStatus? status,
    List<String>? tags,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      area: area ?? this.area,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      targetDate: targetDate ?? this.targetDate,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Calculate progress percentage
  double get progressPercentage {
    if (targetValue == 0) return 0.0;
    return (currentValue / targetValue) * 100;
  }

  /// Check if goal is overdue
  bool get isOverdue {
    if (targetDate == null) return false;
    return DateTime.now().isAfter(targetDate!) && status != GoalStatus.completed;
  }
}

/// Enum for goal areas
enum GoalArea {
  self,
  ibadah,
  skills,
}

/// Enum for goal types
enum GoalType {
  daily,
  weekly,
  monthly,
  longTerm,
}

/// Enum for goal statuses
enum GoalStatus {
  notStarted,
  inProgress,
  completed,
  overdue,
  cancelled,
}