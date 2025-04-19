import 'package:flutter/material.dart';

import '../../domain/entities/quran_bookmark.dart';

/// Model class for QuranBookmark entity
class QuranBookmarkModel extends QuranBookmark {
  const QuranBookmarkModel({
    required super.id,
    super.surahName,
    super.ayahNumber,
    super.ayahId,
    super.page,
    required super.colorCode,
    required super.name,
  });

  /// Create a QuranBookmarkModel from a JSON map
  factory QuranBookmarkModel.fromJson(Map<String, dynamic> json) {
    return QuranBookmarkModel(
      id: json['id'],
      surahName: json['surahName'],
      ayahNumber: json['ayahNumber'],
      ayahId: json['ayahId'],
      page: json['page'],
      colorCode: json['colorCode'],
      name: json['name'],
    );
  }

  /// Create a QuranBookmarkModel from a Hive object
  factory QuranBookmarkModel.fromHiveObject(Map<dynamic, dynamic> hiveObject) {
    return QuranBookmarkModel(
      id: hiveObject['id'],
      surahName: hiveObject['surahName'],
      ayahNumber: hiveObject['ayahNumber'],
      ayahId: hiveObject['ayahId'],
      page: hiveObject['page'],
      colorCode: hiveObject['colorCode'],
      name: hiveObject['name'],
    );
  }

  /// Convert this QuranBookmarkModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'surahName': surahName,
      'ayahNumber': ayahNumber,
      'ayahId': ayahId,
      'page': page,
      'colorCode': colorCode,
      'name': name,
    };
  }

  /// Convert this QuranBookmarkModel to a Hive object
  Map<String, dynamic> toHiveObject() {
    return {
      'id': id,
      'surahName': surahName,
      'ayahNumber': ayahNumber,
      'ayahId': ayahId,
      'page': page,
      'colorCode': colorCode,
      'name': name,
    };
  }

  /// Create a QuranBookmarkModel from a QuranBookmark entity
  factory QuranBookmarkModel.fromEntity(QuranBookmark bookmark) {
    return QuranBookmarkModel(
      id: bookmark.id,
      surahName: bookmark.surahName,
      ayahNumber: bookmark.ayahNumber,
      ayahId: bookmark.ayahId,
      page: bookmark.page,
      colorCode: bookmark.colorCode,
      name: bookmark.name,
    );
  }

  /// Factory method to create a bookmark with a color
  factory QuranBookmarkModel.withColor({
    required int id,
    required Color color,
    required String name,
  }) {
    return QuranBookmarkModel(
      id: id,
      colorCode:
          (color.r.toInt() << 16) | (color.g.toInt() << 8) | color.b.toInt(),
      name: name,
    );
  }
}
