import 'package:equatable/equatable.dart';

/// Entity representing a task in the daily planner
class Task extends Equatable {
  final String id;
  final String title;
  final String? description;
  final TaskCategory category;
  final TimeBlock timeBlock;
  final TaskStatus status;
  final DateTime scheduledDate;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final int priority; // 1 = Low, 2 = Medium, 3 = High
  final int estimatedDuration; // in minutes
  final int actualDuration; // in minutes
  final List<String> tags;
  final List<String> dependencies; // IDs of tasks this task depends on
  final bool isRecurring;
  final RecurrencePattern? recurrencePattern;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.timeBlock,
    required this.status,
    required this.scheduledDate,
    this.dueDate,
    this.completedAt,
    required this.priority,
    required this.estimatedDuration,
    required this.actualDuration,
    required this.tags,
    required this.dependencies,
    required this.isRecurring,
    this.recurrencePattern,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        timeBlock,
        status,
        scheduledDate,
        dueDate,
        completedAt,
        priority,
        estimatedDuration,
        actualDuration,
        tags,
        dependencies,
        isRecurring,
        recurrencePattern,
        createdAt,
        updatedAt,
      ];

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskCategory? category,
    TimeBlock? timeBlock,
    TaskStatus? status,
    DateTime? scheduledDate,
    DateTime? dueDate,
    DateTime? completedAt,
    int? priority,
    int? estimatedDuration,
    int? actualDuration,
    List<String>? tags,
    List<String>? dependencies,
    bool? isRecurring,
    RecurrencePattern? recurrencePattern,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      timeBlock: timeBlock ?? this.timeBlock,
      status: status ?? this.status,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      priority: priority ?? this.priority,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      actualDuration: actualDuration ?? this.actualDuration,
      tags: tags ?? this.tags,
      dependencies: dependencies ?? this.dependencies,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Enum for task categories
enum TaskCategory {
  ibadah, // Islamic practices
  programming, // Skill development - programming
  selfDevelopment, // Self-improvement activities
  other, // Other activities
}

/// Enum for time blocks
enum TimeBlock {
  morning, // Fajr to sunrise
  work, // Work hours
  evening, // Maghrib to Isha
  night, // After Isha
  anytime, // Any time
}

/// Enum for task status
enum TaskStatus {
  pending,
  inProgress,
  completed,
  skipped,
  overdue,
}

/// Class for recurrence pattern
class RecurrencePattern extends Equatable {
  final RecurrenceType type;
  final int interval; // e.g., every 2 days, every week
  final List<int> daysOfWeek; // 1 = Monday, 7 = Sunday
  final int? dayOfMonth; // for monthly recurrence
  final DateTime? endDate; // when recurrence should stop

  const RecurrencePattern({
    required this.type,
    required this.interval,
    required this.daysOfWeek,
    this.dayOfMonth,
    this.endDate,
  });

  @override
  List<Object?> get props => [
        type,
        interval,
        daysOfWeek,
        dayOfMonth,
        endDate,
      ];
}

/// Enum for recurrence types
enum RecurrenceType {
  daily,
  weekly,
  monthly,
  yearly,
}