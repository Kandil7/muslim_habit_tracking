import '../../domain/entities/reading_history.dart';

/// Model class for QuranReadingHistory entity
class QuranReadingHistoryModel extends QuranReadingHistory {
  const QuranReadingHistoryModel({
    required super.id,
    required super.surahId,
    required super.ayahNumber,
    required super.page,
    required super.surahName,
    required super.arabicSurahName,
    required super.timestamp,
  });

  /// Create a QuranReadingHistoryModel from a JSON map
  factory QuranReadingHistoryModel.fromJson(Map<String, dynamic> json) {
    return QuranReadingHistoryModel(
      id: json['id'],
      surahId: json['surahId'],
      ayahNumber: json['ayahNumber'],
      page: json['page'],
      surahName: json['surahName'],
      arabicSurahName: json['arabicSurahName'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  /// Convert this QuranReadingHistoryModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'surahId': surahId,
      'ayahNumber': ayahNumber,
      'page': page,
      'surahName': surahName,
      'arabicSurahName': arabicSurahName,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Create a QuranReadingHistoryModel from an existing QuranReadingHistory entity
  factory QuranReadingHistoryModel.fromEntity(QuranReadingHistory history) {
    return QuranReadingHistoryModel(
      id: history.id,
      surahId: history.surahId,
      ayahNumber: history.ayahNumber,
      page: history.page,
      surahName: history.surahName,
      arabicSurahName: history.arabicSurahName,
      timestamp: history.timestamp,
    );
  }
}
