import 'package:muslim_habbit/features/dua_dhikr/domain/entities/dhikr.dart';

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

  factory DhikrModel.fromJson(Map<String, dynamic> json) {
    return DhikrModel(
      id: json['id'] as String,
      title: json['title'] as String,
      arabicText: json['arabicText'] as String,
      transliteration: json['transliteration'] as String,
      translation: json['translation'] as String,
      reference: json['reference'] as String,
      recommendedCount: json['recommendedCount'] as int,
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
      'recommendedCount': recommendedCount,
      'isFavorite': isFavorite,
    };
  }

  Dhikr toEntity() => Dhikr(
    id: id,
    title: title,
    arabicText: arabicText,
    transliteration: transliteration,
    translation: translation,
    reference: reference,
    recommendedCount: recommendedCount,
    isFavorite: isFavorite,
  );

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

  @override
  String toString() {
    return 'DhikrModel(id: $id, title: $title, arabicText: $arabicText, transliteration: $transliteration, translation: $translation, reference: $reference, recommendedCount: $recommendedCount, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DhikrModel &&
        other.id == id &&
        other.title == title &&
        other.arabicText == arabicText &&
        other.transliteration == transliteration &&
        other.translation == translation &&
        other.reference == reference &&
        other.recommendedCount == recommendedCount &&
        other.isFavorite == isFavorite;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        arabicText.hashCode ^
        transliteration.hashCode ^
        translation.hashCode ^
        reference.hashCode ^
        recommendedCount.hashCode ^
        isFavorite.hashCode;
  }
}
