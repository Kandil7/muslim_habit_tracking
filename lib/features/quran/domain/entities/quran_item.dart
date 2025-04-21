import 'package:equatable/equatable.dart';

/// Entity representing a Quran item (surah)
class QuranItem extends Equatable {
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
  const QuranItem({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
    required this.start,
  });

  @override
  List<Object?> get props => [
    number,
    name,
    englishName,
    englishNameTranslation,
    numberOfAyahs,
    revelationType,
    start,
  ];

  /// Create a copy with some fields replaced
  QuranItem copyWith({
    int? number,
    String? name,
    String? englishName,
    String? englishNameTranslation,
    int? numberOfAyahs,
    String? revelationType,
    int? start,
  }) {
    return QuranItem(
      number: number ?? this.number,
      name: name ?? this.name,
      englishName: englishName ?? this.englishName,
      englishNameTranslation: englishNameTranslation ?? this.englishNameTranslation,
      numberOfAyahs: numberOfAyahs ?? this.numberOfAyahs,
      revelationType: revelationType ?? this.revelationType,
      start: start ?? this.start,
    );
  }
}
