import 'package:muslim_habbit/features/dua_dhikr/domain/entities/dua.dart';

class DuaModel extends Dua {
  const DuaModel({
    required super.id,
    required super.title,
    required super.arabicText,
    required super.transliteration,
    required super.translation,
    required super.reference,
    required super.category,
    required super.isFavorite,
  });

  factory DuaModel.fromJson(Map<String, dynamic> json) {
    return DuaModel(
      id: json['id'] as String,
      title: json['title'] as String,
      arabicText: json['arabicText'] as String,
      transliteration: json['transliteration'] as String,
      translation: json['translation'] as String,
      reference: json['reference'] as String,
      category: json['category'] as String,
      isFavorite: json['isFavorite'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'arabicText': arabicText,
      'transliteration': transliteration,
      'translation': translation,
      'reference': reference,
      'category': category,
      'isFavorite': isFavorite,
    };
  }

  Dua toEntity() {
    return Dua(
      id: id,
      title: title,
      arabicText: arabicText,
      transliteration: transliteration,
      translation: translation,
      reference: reference,
      category: category,
      isFavorite: isFavorite,
    );
  }
}
