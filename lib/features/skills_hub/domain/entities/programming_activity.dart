import 'package:equatable/equatable.dart';

/// Entity representing a programming activity
class ProgrammingActivity extends Equatable {
  final String id;
  final ProgrammingActivityType type;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime? endTime;
  final Duration duration;
  final List<String> resources;
  final String? notes;
  final int difficulty; // 1-5 scale
  final List<String> tags;
  final String? projectId; // Associated project if any
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProgrammingActivity({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    required this.startTime,
    this.endTime,
    required this.duration,
    required this.resources,
    this.notes,
    required this.difficulty,
    required this.tags,
    this.projectId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        description,
        startTime,
        endTime,
        duration,
        resources,
        notes,
        difficulty,
        tags,
        projectId,
        createdAt,
        updatedAt,
      ];

  ProgrammingActivity copyWith({
    String? id,
    ProgrammingActivityType? type,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    Duration? duration,
    List<String>? resources,
    String? notes,
    int? difficulty,
    List<String>? tags,
    String? projectId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProgrammingActivity(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      resources: resources ?? this.resources,
      notes: notes ?? this.notes,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
      projectId: projectId ?? this.projectId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Enum for programming activity types
enum ProgrammingActivityType {
  course,
  documentation,
  challenge,
  project,
  practice,
}