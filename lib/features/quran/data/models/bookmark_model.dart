import '../../domain/entities/bookmark.dart';

/// Model class for QuranBookmark entity
class QuranBookmarkModel extends QuranBookmark {
  const QuranBookmarkModel({
    required super.id,
    required super.surahId,
    required super.ayahNumber,
    required super.page,
    required super.surahName,
    required super.arabicSurahName,
    required super.timestamp,
    super.note,
  });

  /// Create a QuranBookmarkModel from a JSON map
  factory QuranBookmarkModel.fromJson(Map<String, dynamic> json) {
    return QuranBookmarkModel(
      id: json['id'],
      surahId: json['surahId'],
      ayahNumber: json['ayahNumber'],
      page: json['page'],
      surahName: json['surahName'],
      arabicSurahName: json['arabicSurahName'],
      timestamp: DateTime.parse(json['timestamp']),
      note: json['note'],
    );
  }

  /// Convert this QuranBookmarkModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'surahId': surahId,
      'ayahNumber': ayahNumber,
      'page': page,
      'surahName': surahName,
      'arabicSurahName': arabicSurahName,
      'timestamp': timestamp.toIso8601String(),
      'note': note,
    };
  }

  /// Create a QuranBookmarkModel from an existing QuranBookmark entity
  factory QuranBookmarkModel.fromEntity(QuranBookmark bookmark) {
    return QuranBookmarkModel(
      id: bookmark.id,
      surahId: bookmark.surahId,
      ayahNumber: bookmark.ayahNumber,
      page: bookmark.page,
      surahName: bookmark.surahName,
      arabicSurahName: bookmark.arabicSurahName,
      timestamp: bookmark.timestamp,
      note: bookmark.note,
    );
  }
}
