import 'package:equatable/equatable.dart';

/// Entity representing a lecture log entry
class LectureLog extends Equatable {
  final String id;
  final String title;
  final String? speaker;
  final String? description;
  final DateTime date;
  final Duration duration;
  final int rating; // 1-5 stars
  final String? notes;
  final List<String> tags;
  final String? externalLink;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LectureLog({
    required this.id,
    required this.title,
    this.speaker,
    this.description,
    required this.date,
    required this.duration,
    required this.rating,
    this.notes,
    required this.tags,
    this.externalLink,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        speaker,
        description,
        date,
        duration,
        rating,
        notes,
        tags,
        externalLink,
        createdAt,
        updatedAt,
      ];

  LectureLog copyWith({
    String? id,
    String? title,
    String? speaker,
    String? description,
    DateTime? date,
    Duration? duration,
    int? rating,
    String? notes,
    List<String>? tags,
    String? externalLink,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LectureLog(
      id: id ?? this.id,
      title: title ?? this.title,
      speaker: speaker ?? this.speaker,
      description: description ?? this.description,
      date: date ?? this.date,
      duration: duration ?? this.duration,
      rating: rating ?? this.rating,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      externalLink: externalLink ?? this.externalLink,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}