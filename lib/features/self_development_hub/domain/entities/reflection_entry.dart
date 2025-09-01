import 'package:equatable/equatable.dart';

/// Entity representing a reflection journal entry
class ReflectionEntry extends Equatable {
  final String id;
  final DateTime date;
  final String title;
  final String content;
  final List<ReflectionPrompt> prompts;
  final List<String> tags;
  final String? mood; // e.g., happy, sad, anxious, peaceful
  final List<String> lessonsLearned;
  final List<String> improvementPlans;
  final List<String> associatedGoals; // Goal IDs
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReflectionEntry({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
    required this.prompts,
    required this.tags,
    this.mood,
    required this.lessonsLearned,
    required this.improvementPlans,
    required this.associatedGoals,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        date,
        title,
        content,
        prompts,
        tags,
        mood,
        lessonsLearned,
        improvementPlans,
        associatedGoals,
        createdAt,
        updatedAt,
      ];

  ReflectionEntry copyWith({
    String? id,
    DateTime? date,
    String? title,
    String? content,
    List<ReflectionPrompt>? prompts,
    List<String>? tags,
    String? mood,
    List<String>? lessonsLearned,
    List<String>? improvementPlans,
    List<String>? associatedGoals,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReflectionEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      content: content ?? this.content,
      prompts: prompts ?? this.prompts,
      tags: tags ?? this.tags,
      mood: mood ?? this.mood,
      lessonsLearned: lessonsLearned ?? this.lessonsLearned,
      improvementPlans: improvementPlans ?? this.improvementPlans,
      associatedGoals: associatedGoals ?? this.associatedGoals,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Class representing a reflection prompt and response
class ReflectionPrompt extends Equatable {
  final String prompt;
  final String response;

  const ReflectionPrompt({
    required this.prompt,
    required this.response,
  });

  @override
  List<Object?> get props => [prompt, response];

  ReflectionPrompt copyWith({
    String? prompt,
    String? response,
  }) {
    return ReflectionPrompt(
      prompt: prompt ?? this.prompt,
      response: response ?? this.response,
    );
  }
}