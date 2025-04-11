import 'package:equatable/equatable.dart';

/// Dhikr entity representing a remembrance
class Dhikr extends Equatable {
  final String id;
  final String title;
  final String arabicText;
  final String transliteration;
  final String translation;
  final String reference;
  final int recommendedCount;
  final bool isFavorite;
  
  const Dhikr({
    required this.id,
    required this.title,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.reference,
    required this.recommendedCount,
    required this.isFavorite,
  });
  
  @override
  List<Object> get props => [
    id,
    title,
    arabicText,
    transliteration,
    translation,
    reference,
    recommendedCount,
    isFavorite,
  ];
  
  /// Create a copy of this Dhikr with the given fields replaced with the new values
  Dhikr copyWith({
    String? id,
    String? title,
    String? arabicText,
    String? transliteration,
    String? translation,
    String? reference,
    int? recommendedCount,
    bool? isFavorite,
  }) {
    return Dhikr(
      id: id ?? this.id,
      title: title ?? this.title,
      arabicText: arabicText ?? this.arabicText,
      transliteration: transliteration ?? this.transliteration,
      translation: translation ?? this.translation,
      reference: reference ?? this.reference,
      recommendedCount: recommendedCount ?? this.recommendedCount,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
