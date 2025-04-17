import 'package:equatable/equatable.dart';

/// Entity class for Quran bookmark
class QuranBookmark extends Equatable {
  final String id;
  final int surahId;
  final int ayahNumber;
  final int page;
  final String surahName;
  final String arabicSurahName;
  final DateTime timestamp;
  final String? note;

  const QuranBookmark({
    required this.id,
    required this.surahId,
    required this.ayahNumber,
    required this.page,
    required this.surahName,
    required this.arabicSurahName,
    required this.timestamp,
    this.note,
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
        note,
      ];

  /// Create a copy of this QuranBookmark with the given fields replaced with the new values
  QuranBookmark copyWith({
    String? id,
    int? surahId,
    int? ayahNumber,
    int? page,
    String? surahName,
    String? arabicSurahName,
    DateTime? timestamp,
    String? note,
  }) {
    return QuranBookmark(
      id: id ?? this.id,
      surahId: surahId ?? this.surahId,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      page: page ?? this.page,
      surahName: surahName ?? this.surahName,
      arabicSurahName: arabicSurahName ?? this.arabicSurahName,
      timestamp: timestamp ?? this.timestamp,
      note: note ?? this.note,
    );
  }
}
