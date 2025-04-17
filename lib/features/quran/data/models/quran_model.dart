import '../../domain/entities/quran.dart';

/// Model class for Quran entity
class QuranModel extends Quran {
  const QuranModel({
    required super.id,
    required super.name,
    required super.arabicName,
    required super.englishName,
    required super.revelationType,
    required super.numberOfAyahs,
    required super.startPage,
    super.isBookmarked = false,
  });

  /// Create a QuranModel from a JSON map
  factory QuranModel.fromJson(Map<String, dynamic> json) {
    return QuranModel(
      id: json['id'],
      name: json['name'],
      arabicName: json['arabicName'],
      englishName: json['englishName'],
      revelationType: json['revelationType'],
      numberOfAyahs: json['numberOfAyahs'],
      startPage: json['startPage'],
      isBookmarked: json['isBookmarked'] ?? false,
    );
  }

  /// Convert this QuranModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'arabicName': arabicName,
      'englishName': englishName,
      'revelationType': revelationType,
      'numberOfAyahs': numberOfAyahs,
      'startPage': startPage,
      'isBookmarked': isBookmarked,
    };
  }

  /// Create a QuranModel from an existing Quran entity
  factory QuranModel.fromEntity(Quran quran) {
    return QuranModel(
      id: quran.id,
      name: quran.name,
      arabicName: quran.arabicName,
      englishName: quran.englishName,
      revelationType: quran.revelationType,
      numberOfAyahs: quran.numberOfAyahs,
      startPage: quran.startPage,
      isBookmarked: quran.isBookmarked,
    );
  }
}
