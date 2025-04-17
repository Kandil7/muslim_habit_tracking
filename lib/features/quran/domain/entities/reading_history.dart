import 'package:equatable/equatable.dart';

/// Entity class for Quran reading history
class QuranReadingHistory extends Equatable {
  final String id;
  final int surahId;
  final int ayahNumber;
  final int page;
  final String surahName;
  final String arabicSurahName;
  final DateTime timestamp;

  const QuranReadingHistory({
    required this.id,
    required this.surahId,
    required this.ayahNumber,
    required this.page,
    required this.surahName,
    required this.arabicSurahName,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        id,
        surahId,
        ayahNumber,
        page,
        surahName,
        arabicSurahName,
        timestamp,
      ];

  /// Create a copy of this QuranReadingHistory with the given fields replaced with the new values
  QuranReadingHistory copyWith({
    String? id,
    int? surahId,
    int? ayahNumber,
    int? page,
    String? surahName,
    String? arabicSurahName,
    DateTime? timestamp,
  }) {
    return QuranReadingHistory(
      id: id ?? this.id,
      surahId: surahId ?? this.surahId,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      page: page ?? this.page,
      surahName: surahName ?? this.surahName,
      arabicSurahName: arabicSurahName ?? this.arabicSurahName,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
