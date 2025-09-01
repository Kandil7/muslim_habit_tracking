import 'package:muslim_habbit/features/daily_planner/domain/entities/task.dart';

/// Data model for Task that extends the entity with serialization methods
class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.title,
    super.description,
    required super.category,
    required super.timeBlock,
    required super.status,
    required super.scheduledDate,
    super.dueDate,
    super.completedAt,
    required super.priority,
    required super.estimatedDuration,
    required super.actualDuration,
    required super.tags,
    required super.dependencies,
    required super.isRecurring,
    super.recurrencePattern,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Factory method to create from entity
  factory TaskModel.fromEntity(Task entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      category: entity.category,
      timeBlock: entity.timeBlock,
      status: entity.status,
      scheduledDate: entity.scheduledDate,
      dueDate: entity.dueDate,
      completedAt: entity.completedAt,
      priority: entity.priority,
      estimatedDuration: entity.estimatedDuration,
      actualDuration: entity.actualDuration,
      tags: entity.tags,
      dependencies: entity.dependencies,
      isRecurring: entity.isRecurring,
      recurrencePattern: entity.recurrencePattern,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Factory method to create from JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      category: _categoryFromString(json['category'] as String),
      timeBlock: _timeBlockFromString(json['timeBlock'] as String),
      status: _statusFromString(json['status'] as String),
      scheduledDate: DateTime.parse(json['scheduledDate'] as String),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
      priority: json['priority'] as int,
      estimatedDuration: json['estimatedDuration'] as int,
      actualDuration: json['actualDuration'] as int,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      dependencies: (json['dependencies'] as List<dynamic>).map((e) => e as String).toList(),
      isRecurring: json['isRecurring'] as bool,
      recurrencePattern: json['recurrencePattern'] != null
          ? RecurrencePattern(
              type: _recurrenceTypeFromString(
                  (json['recurrencePattern'] as Map<String, dynamic>)['type'] as String),
              interval: (json['recurrencePattern'] as Map<String, dynamic>)['interval'] as int,
              daysOfWeek: (json['recurrencePattern'] as Map<String, dynamic>)['daysOfWeek'] != null
                  ? (json['recurrencePattern'] as Map<String, dynamic>)['daysOfWeek']
                      .map((e) => e as int)
                      .toList()
                  : [],
              dayOfMonth:
                  (json['recurrencePattern'] as Map<String, dynamic>)['dayOfMonth'] as int?,
              endDate: (json['recurrencePattern'] as Map<String, dynamic>)['endDate'] != null
                  ? DateTime.parse(
                      (json['recurrencePattern'] as Map<String, dynamic>)['endDate'] as String)
                  : null,
            )
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': _categoryToString(category),
      'timeBlock': _timeBlockToString(timeBlock),
      'status': _statusToString(status),
      'scheduledDate': scheduledDate.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'priority': priority,
      'estimatedDuration': estimatedDuration,
      'actualDuration': actualDuration,
      'tags': tags,
      'dependencies': dependencies,
      'isRecurring': isRecurring,
      'recurrencePattern': recurrencePattern != null
          ? {
              'type': _recurrenceTypeToString(recurrencePattern!.type),
              'interval': recurrencePattern!.interval,
              'daysOfWeek': recurrencePattern!.daysOfWeek,
              'dayOfMonth': recurrencePattern!.dayOfMonth,
              'endDate': recurrencePattern!.endDate?.toIso8601String(),
            }
          : null,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Convert category to string
  String _categoryToString(TaskCategory category) {
    switch (category) {
      case TaskCategory.ibadah:
        return 'ibadah';
      case TaskCategory.programming:
        return 'programming';
      case TaskCategory.selfDevelopment:
        return 'selfDevelopment';
      case TaskCategory.other:
        return 'other';
    }
  }

  /// Convert string to category
  static TaskCategory _categoryFromString(String category) {
    switch (category) {
      case 'ibadah':
        return TaskCategory.ibadah;
      case 'programming':
        return TaskCategory.programming;
      case 'selfDevelopment':
        return TaskCategory.selfDevelopment;
      case 'other':
        return TaskCategory.other;
      default:
        return TaskCategory.other;
    }
  }

  /// Convert time block to string
  String _timeBlockToString(TimeBlock timeBlock) {
    switch (timeBlock) {
      case TimeBlock.morning:
        return 'morning';
      case TimeBlock.work:
        return 'work';
      case TimeBlock.evening:
        return 'evening';
      case TimeBlock.night:
        return 'night';
      case TimeBlock.anytime:
        return 'anytime';
    }
  }

  /// Convert string to time block
  static TimeBlock _timeBlockFromString(String timeBlock) {
    switch (timeBlock) {
      case 'morning':
        return TimeBlock.morning;
      case 'work':
        return TimeBlock.work;
      case 'evening':
        return TimeBlock.evening;
      case 'night':
        return TimeBlock.night;
      case 'anytime':
        return TimeBlock.anytime;
      default:
        return TimeBlock.anytime;
    }
  }

  /// Convert status to string
  String _statusToString(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'pending';
      case TaskStatus.inProgress:
        return 'inProgress';
      case TaskStatus.completed:
        return 'completed';
      case TaskStatus.skipped:
        return 'skipped';
      case TaskStatus.overdue:
        return 'overdue';
    }
  }

  /// Convert string to status
  static TaskStatus _statusFromString(String status) {
    switch (status) {
      case 'pending':
        return TaskStatus.pending;
      case 'inProgress':
        return TaskStatus.inProgress;
      case 'completed':
        return TaskStatus.completed;
      case 'skipped':
        return TaskStatus.skipped;
      case 'overdue':
        return TaskStatus.overdue;
      default:
        return TaskStatus.pending;
    }
  }

  /// Convert recurrence type to string
  String _recurrenceTypeToString(RecurrenceType type) {
    switch (type) {
      case RecurrenceType.daily:
        return 'daily';
      case RecurrenceType.weekly:
        return 'weekly';
      case RecurrenceType.monthly:
        return 'monthly';
      case RecurrenceType.yearly:
        return 'yearly';
    }
  }

  /// Convert string to recurrence type
  static RecurrenceType _recurrenceTypeFromString(String type) {
    switch (type) {
      case 'daily':
        return RecurrenceType.daily;
      case 'weekly':
        return RecurrenceType.weekly;
      case 'monthly':
        return RecurrenceType.monthly;
      case 'yearly':
        return RecurrenceType.yearly;
      default:
        return RecurrenceType.daily;
    }
  }
}