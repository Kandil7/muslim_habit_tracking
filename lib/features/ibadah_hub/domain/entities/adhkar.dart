import 'package:equatable/equatable.dart';

/// Entity representing Adhkar (remembrances)
class Adhkar extends Equatable {
  final String id;
  final String text;
  final String? transliteration;
  final String? translation;
  final int targetCount;
  final int currentCount;
  final AdhkarCategory category;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Adhkar({
    required this.id,
    required this.text,
    this.transliteration,
    this.translation,
    required this.targetCount,
    required this.currentCount,
    required this.category,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        text,
        transliteration,
        translation,
        targetCount,
        currentCount,
        category,
        isCompleted,
        createdAt,
        updatedAt,
      ];

  Adhkar copyWith({
    String? id,
    String? text,
    String? transliteration,
    String? translation,
    int? targetCount,
    int? currentCount,
    AdhkarCategory? category,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Adhkar(
      id: id ?? this.id,
      text: text ?? this.text,
      transliteration: transliteration ?? this.transliteration,
      translation: translation ?? this.translation,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Enum for Adhkar categories
enum AdhkarCategory {
  morning,
  evening,
  afterPrayer,
  general,
}