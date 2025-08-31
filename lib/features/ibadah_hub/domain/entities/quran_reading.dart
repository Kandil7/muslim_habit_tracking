import 'package:equatable/equatable.dart';

/// Entity representing Quran reading activity
class QuranReading extends Equatable {
  final String id;
  final int surahNumber;
  final String surahName;
  final int startAyah;
  final int endAyah;
  final int pagesRead;
  final Duration timeSpent;
  final String? reflection;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  const QuranReading({
    required this.id,
    required this.surahNumber,
    required this.surahName,
    required this.startAyah,
    required this.endAyah,
    required this.pagesRead,
    required this.timeSpent,
    this.reflection,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        surahNumber,
        surahName,
        startAyah,
        endAyah,
        pagesRead,
        timeSpent,
        reflection,
        date,
        createdAt,
        updatedAt,
      ];

  QuranReading copyWith({
    String? id,
    int? surahNumber,
    String? surahName,
    int? startAyah,
    int? endAyah,
    int? pagesRead,
    Duration? timeSpent,
    String? reflection,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return QuranReading(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      surahName: surahName ?? this.surahName,
      startAyah: startAyah ?? this.startAyah,
      endAyah: endAyah ?? this.endAyah,
      pagesRead: pagesRead ?? this.pagesRead,
      timeSpent: timeSpent ?? this.timeSpent,
      reflection: reflection ?? this.reflection,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}