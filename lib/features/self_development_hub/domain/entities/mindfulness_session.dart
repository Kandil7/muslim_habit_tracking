import 'package:equatable/equatable.dart';

/// Entity representing a mindfulness session
class MindfulnessSession extends Equatable {
  final String id;
  final MindfulnessType type;
  final DateTime startTime;
  final DateTime? endTime;
  final Duration duration;
  final String? notes;
  final int rating; // 1-5 stars
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MindfulnessSession({
    required this.id,
    required this.type,
    required this.startTime,
    this.endTime,
    required this.duration,
    this.notes,
    required this.rating,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        startTime,
        endTime,
        duration,
        notes,
        rating,
        tags,
        createdAt,
        updatedAt,
      ];

  MindfulnessSession copyWith({
    String? id,
    MindfulnessType? type,
    DateTime? startTime,
    DateTime? endTime,
    Duration? duration,
    String? notes,
    int? rating,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MindfulnessSession(
      id: id ?? this.id,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      notes: notes ?? this.notes,
      rating: rating ?? this.rating,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if session is active (not completed)
  bool get isActive {
    return endTime == null;
  }
}

/// Enum for mindfulness types
enum MindfulnessType {
  breathing,
  bodyScan,
  gratitude,
  visualization,
  walking,
}