import '../../domain/entities/quran_bookmark.dart';

/// Data model for Quran bookmark
class QuranBookmarkModel extends QuranBookmark {
  /// Constructor
  const QuranBookmarkModel({
    required super.id,
    required super.page,
    super.surahName,
    super.ayahNumber,
    required super.title,
    required super.timestamp,
  });

  /// Create from JSON
  factory QuranBookmarkModel.fromJson(Map<String, dynamic> json) {
    return QuranBookmarkModel(
      id: json['id'] as int,
      page: json['page'] as int,
      surahName: json['surahName'] as String?,
      ayahNumber: json['ayahNumber'] as int?,
      title: json['title'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'page': page,
      'surahName': surahName,
      'ayahNumber': ayahNumber,
      'title': title,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  /// Create a copy with some fields replaced
  @override
  QuranBookmarkModel copyWith({
    int? id,
    int? page,
    String? surahName,
    int? ayahNumber,
    String? title,
    DateTime? timestamp,
  }) {
    return QuranBookmarkModel(
      id: id ?? this.id,
      page: page ?? this.page,
      surahName: surahName ?? this.surahName,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      title: title ?? this.title,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
