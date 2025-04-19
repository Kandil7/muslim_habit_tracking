import 'package:equatable/equatable.dart';

/// Entity representing a Quran reading history entry
class QuranReadingHistory extends Equatable {
  /// Unique identifier for the history entry
  final int id;

  /// The surah number (1-114)
  final int? surahNumber;

  /// The surah name
  final String? surahName;

  /// The ayah number
  final int? ayahNumber;

  /// The page number in the Quran
  final int pageNumber;

  /// When the user read this page
  final DateTime timestamp;

  /// Duration spent reading (in seconds), optional
  final int? durationSeconds;

  const QuranReadingHistory({
    required this.id,
    this.surahNumber,
    this.surahName,
    this.ayahNumber,
    required this.pageNumber,
    required this.timestamp,
    this.durationSeconds,
  });

  @override
  List<Object?> get props => [
    id,
    surahNumber,
    surahName,
    ayahNumber,
    pageNumber,
    timestamp,
    durationSeconds,
  ];

  /// Create a copy of this QuranReadingHistory with the given fields replaced with the new values
  QuranReadingHistory copyWith({
    int? id,
    int? surahNumber,
    String? surahName,
    int? ayahNumber,
    int? pageNumber,
    DateTime? timestamp,
    int? durationSeconds,
  }) {
    return QuranReadingHistory(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      surahName: surahName ?? this.surahName,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      pageNumber: pageNumber ?? this.pageNumber,
      timestamp: timestamp ?? this.timestamp,
      durationSeconds: durationSeconds ?? this.durationSeconds,
    );
  }
}
