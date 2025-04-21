import 'package:equatable/equatable.dart';

/// Entity representing a Quran bookmark
class QuranBookmark extends Equatable {
  /// Unique identifier
  final int id;

  /// Page number
  final int page;

  /// Surah name (optional)
  final String? surahName;

  /// Ayah number (optional)
  final int? ayahNumber;

  /// Title or note for the bookmark
  final String title;

  /// Timestamp when the bookmark was created
  final DateTime timestamp;

  /// Constructor
  const QuranBookmark({
    required this.id,
    required this.page,
    this.surahName,
    this.ayahNumber,
    required this.title,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, page, surahName, ayahNumber, title, timestamp];

  /// Create a copy with some fields replaced
  QuranBookmark copyWith({
    int? id,
    int? page,
    String? surahName,
    int? ayahNumber,
    String? title,
    DateTime? timestamp,
  }) {
    return QuranBookmark(
      id: id ?? this.id,
      page: page ?? this.page,
      surahName: surahName ?? this.surahName,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      title: title ?? this.title,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
