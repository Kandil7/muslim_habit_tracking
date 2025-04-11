import 'dart:convert';

import '../../domain/entities/dua.dart';

/// Model class for Dua entity
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
  
  /// Create a DuaModel from a JSON map
  factory DuaModel.fromJson(Map<String, dynamic> json) {
    return DuaModel(
      id: json['id'],
      title: json['title'],
      arabicText: json['arabicText'],
      transliteration: json['transliteration'],
      translation: json['translation'],
      reference: json['reference'],
      category: json['category'],
      isFavorite: json['isFavorite'],
    );
  }
  
  /// Convert this DuaModel to a JSON map
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
  
  /// Create a DuaModel from a Dua entity
  factory DuaModel.fromEntity(Dua dua) {
    return DuaModel(
      id: dua.id,
      title: dua.title,
      arabicText: dua.arabicText,
      transliteration: dua.transliteration,
      translation: dua.translation,
      reference: dua.reference,
      category: dua.category,
      isFavorite: dua.isFavorite,
    );
  }
  
  /// Create a copy of this DuaModel with the given fields replaced with the new values
  @override
  DuaModel copyWith({
    String? id,
    String? title,
    String? arabicText,
    String? transliteration,
    String? translation,
    String? reference,
    String? category,
    bool? isFavorite,
  }) {
    return DuaModel(
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
}
