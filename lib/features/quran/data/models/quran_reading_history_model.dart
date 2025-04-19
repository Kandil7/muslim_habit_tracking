import '../../domain/entities/quran_reading_history.dart';

/// Model class for QuranReadingHistory entity
class QuranReadingHistoryModel extends QuranReadingHistory {
  const QuranReadingHistoryModel({
    required super.id,
    super.surahNumber,
    super.surahName,
    super.ayahNumber,
    required super.pageNumber,
    required super.timestamp,
    super.durationSeconds,
  });

  /// Create a QuranReadingHistoryModel from a JSON map
  factory QuranReadingHistoryModel.fromJson(Map<String, dynamic> json) {
    return QuranReadingHistoryModel(
      id: json['id'],
      surahNumber: json['surahNumber'],
      surahName: json['surahName'],
      ayahNumber: json['ayahNumber'],
      pageNumber: json['pageNumber'],
      timestamp: DateTime.parse(json['timestamp']),
      durationSeconds: json['durationSeconds'],
    );
  }

  /// Create a QuranReadingHistoryModel from a Hive object
  factory QuranReadingHistoryModel.fromHiveObject(
    Map<dynamic, dynamic> hiveObject,
  ) {
    return QuranReadingHistoryModel(
      id: hiveObject['id'],
      surahNumber: hiveObject['surahNumber'],
      surahName: hiveObject['surahName'],
      ayahNumber: hiveObject['ayahNumber'],
      pageNumber: hiveObject['pageNumber'],
      timestamp: DateTime.parse(hiveObject['timestamp']),
      durationSeconds: hiveObject['durationSeconds'],
    );
  }

  /// Convert this QuranReadingHistoryModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'surahNumber': surahNumber,
      'surahName': surahName,
      'ayahNumber': ayahNumber,
      'pageNumber': pageNumber,
      'timestamp': timestamp.toIso8601String(),
      'durationSeconds': durationSeconds,
    };
  }

  /// Convert this QuranReadingHistoryModel to a Hive object
  Map<String, dynamic> toHiveObject() {
    return {
      'id': id,
      'surahNumber': surahNumber,
      'surahName': surahName,
      'ayahNumber': ayahNumber,
      'pageNumber': pageNumber,
      'timestamp': timestamp.toIso8601String(),
      'durationSeconds': durationSeconds,
    };
  }

  /// Create a QuranReadingHistoryModel from a QuranReadingHistory entity
  factory QuranReadingHistoryModel.fromEntity(QuranReadingHistory history) {
    return QuranReadingHistoryModel(
      id: history.id,
      surahNumber: history.surahNumber,
      surahName: history.surahName,
      ayahNumber: history.ayahNumber,
      pageNumber: history.pageNumber,
      timestamp: history.timestamp,
      durationSeconds: history.durationSeconds,
    );
  }
}
