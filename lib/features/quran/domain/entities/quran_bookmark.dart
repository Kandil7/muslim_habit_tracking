import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Entity representing a Quran bookmark
/// This entity is designed to work with the quran_library package
class QuranBookmark extends Equatable {
  /// Unique identifier for the bookmark
  final int id;

  /// The surah name
  final String? surahName;

  /// The ayah number
  final int? ayahNumber;

  /// The ayah ID
  final int? ayahId;

  /// The page number in the Quran
  final int? page;

  /// The color of the bookmark
  final int colorCode;

  /// The name of the bookmark
  final String name;

  const QuranBookmark({
    required this.id,
    this.surahName,
    this.ayahNumber,
    this.ayahId,
    this.page,
    required this.colorCode,
    required this.name,
  });

  @override
  List<Object?> get props => [
    id,
    surahName,
    ayahNumber,
    ayahId,
    page,
    colorCode,
    name,
  ];

  /// Create a copy of this QuranBookmark with the given fields replaced with the new values
  QuranBookmark copyWith({
    int? id,
    String? surahName,
    int? ayahNumber,
    int? ayahId,
    int? page,
    int? colorCode,
    String? name,
  }) {
    return QuranBookmark(
      id: id ?? this.id,
      surahName: surahName ?? this.surahName,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      ayahId: ayahId ?? this.ayahId,
      page: page ?? this.page,
      colorCode: colorCode ?? this.colorCode,
      name: name ?? this.name,
    );
  }

  /// Factory method to create a bookmark with a color
  factory QuranBookmark.withColor({
    required int id,
    required Color color,
    required String name,
  }) {
    return QuranBookmark(id: id, colorCode: color.value, name: name);
  }
}
