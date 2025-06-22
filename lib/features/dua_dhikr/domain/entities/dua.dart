import 'package:equatable/equatable.dart';

class Dua extends Equatable {
  final String id;
  final String title;
  final String arabicText;
  final String transliteration;
  final String translation;
  final String reference;
  final String category;
  final bool isFavorite;

  const Dua({
    required this.id,
    required this.title,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.reference,
    required this.category,
    required this.isFavorite,
  });

  Dua copyWith({
    String? id,
    String? title,
    String? arabicText,
    String? transliteration,
    String? translation,
    String? reference,
    String? category,
    bool? isFavorite,
  }) {
    return Dua(
      id: id ?? this.id,
      title: title ?? this.title,
      arabicText: arabicText ?? this.arabicText,
      transliteration: transliteration ?? this.transliteration,
      translation: translation ?? this.translation,
      reference: reference ?? this.reference,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object> get props => [
    id,
    title,
    arabicText,
    transliteration,
    translation,
    reference,
    category,
    isFavorite,
  ];
}
