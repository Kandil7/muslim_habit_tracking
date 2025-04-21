/// Model for a Quran item (surah)
class QuranItemModel {
  /// Surah number
  final int number;

  /// Surah name in Arabic
  final String name;

  /// Surah name in English
  final String englishName;

  /// English translation of the surah name
  final String englishNameTranslation;

  /// Number of ayahs in the surah
  final int numberOfAyahs;

  /// Type of revelation (Meccan or Medinan)
  final String revelationType;

  /// Starting page number
  final int start;

  /// Constructor
  const QuranItemModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
    required this.start,
  });

  /// Create from JSON
  factory QuranItemModel.fromJson(Map<String, dynamic> json) {
    return QuranItemModel(
      number: json['number'] as int,
      name: json['name'] as String,
      englishName: json['englishName'] as String,
      englishNameTranslation: json['englishNameTranslation'] as String,
      numberOfAyahs: json['numberOfAyahs'] as int,
      revelationType: json['revelationType'] as String,
      start: json['start'] as int,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'englishName': englishName,
      'englishNameTranslation': englishNameTranslation,
      'numberOfAyahs': numberOfAyahs,
      'revelationType': revelationType,
      'start': start,
    };
  }
}
