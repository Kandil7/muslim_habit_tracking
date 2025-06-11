import '../../domain/entities/dhikr.dart';

/// Model class for Dhikr entity
class DhikrModel extends Dhikr {
  const DhikrModel({
    required super.id,
    required super.title,
    required super.arabicText,
    required super.transliteration,
    required super.translation,
    required super.reference,
    required super.recommendedCount,
    required super.isFavorite,
  });

  /// Create a DhikrModel from a JSON map
  factory DhikrModel.fromJson(Map<String, dynamic> json) {
    return DhikrModel(
      id: json['id'],
      title: json['title'],
      arabicText: json['arabicText'],
      transliteration: json['transliteration'],
      translation: json['translation'],
      reference: json['reference'],
      recommendedCount: json['recommendedCount'],
      isFavorite: json['isFavorite'],
    );
  }

  /// Convert this DhikrModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'arabicText': arabicText,
      'transliteration': transliteration,
      'translation': translation,
      'reference': reference,
      'recommendedCount': recommendedCount,
      'isFavorite': isFavorite,
    };
  }

  /// Create a DhikrModel from a Dhikr entity
  factory DhikrModel.fromEntity(Dhikr dhikr) {
    return DhikrModel(
      id: dhikr.id,
      title: dhikr.title,
      arabicText: dhikr.arabicText,
      transliteration: dhikr.transliteration,
      translation: dhikr.translation,
      reference: dhikr.reference,
      recommendedCount: dhikr.recommendedCount,
      isFavorite: dhikr.isFavorite,
    );
  }

  /// Create a copy of this DhikrModel with the given fields replaced with the new values
  @override
  DhikrModel copyWith({
    String? id,
    String? title,
    String? arabicText,
    String? transliteration,
    String? translation,
    String? reference,
    int? recommendedCount,
    bool? isFavorite,
  }) {
    return DhikrModel(
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
