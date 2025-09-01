import 'package:equatable/equatable.dart';

/// Entity representing a coding challenge
class Challenge extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String platform; // e.g., LeetCode, HackerRank
  final ChallengeDifficulty difficulty;
  final List<String> tags;
  final DateTime completedAt;
  final Duration timeTaken;
  final String? solution;
  final int rating; // 1-5 stars for difficulty/quality
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Challenge({
    required this.id,
    required this.title,
    this.description,
    required this.platform,
    required this.difficulty,
    required this.tags,
    required this.completedAt,
    required this.timeTaken,
    this.solution,
    required this.rating,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        platform,
        difficulty,
        tags,
        completedAt,
        timeTaken,
        solution,
        rating,
        isCompleted,
        createdAt,
        updatedAt,
      ];

  Challenge copyWith({
    String? id,
    String? title,
    String? description,
    String? platform,
    ChallengeDifficulty? difficulty,
    List<String>? tags,
    DateTime? completedAt,
    Duration? timeTaken,
    String? solution,
    int? rating,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Challenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      platform: platform ?? this.platform,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
      completedAt: completedAt ?? this.completedAt,
      timeTaken: timeTaken ?? this.timeTaken,
      solution: solution ?? this.solution,
      rating: rating ?? this.rating,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Enum for challenge difficulties
enum ChallengeDifficulty {
  easy,
  medium,
  hard,
}