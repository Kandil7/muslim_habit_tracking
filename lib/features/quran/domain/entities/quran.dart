import 'package:equatable/equatable.dart';

/// Entity class for Quran
class Quran extends Equatable {
  final int id;
  final String name;
  final String arabicName;
  final String englishName;
  final String revelationType;
  final int numberOfAyahs;
  final int startPage;
  final bool isBookmarked;

  const Quran({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.englishName,
    required this.revelationType,
    required this.numberOfAyahs,
    required this.startPage,
    this.isBookmarked = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        arabicName,
        englishName,
        revelationType,
        numberOfAyahs,
        startPage,
        isBookmarked,
      ];

  /// Create a copy of this Quran with the given fields replaced with the new values
  Quran copyWith({
    int? id,
    String? name,
    String? arabicName,
    String? englishName,
    String? revelationType,
    int? numberOfAyahs,
    int? startPage,
    bool? isBookmarked,
  }) {
    return Quran(
      id: id ?? this.id,
      name: name ?? this.name,
      arabicName: arabicName ?? this.arabicName,
      englishName: englishName ?? this.englishName,
      revelationType: revelationType ?? this.revelationType,
      numberOfAyahs: numberOfAyahs ?? this.numberOfAyahs,
      startPage: startPage ?? this.startPage,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
