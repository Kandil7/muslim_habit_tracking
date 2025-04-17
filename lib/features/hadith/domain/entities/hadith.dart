import 'package:equatable/equatable.dart';

/// Entity representing a Hadith
class Hadith extends Equatable {
  /// Unique identifier for the hadith
  final String id;

  /// The text content of the hadith
  final String text;

  /// The narrator of the hadith
  final String narrator;

  /// The source of the hadith (e.g., Sahih Bukhari)
  final String source;

  /// The book number or chapter
  final String book;

  /// The hadith number in the collection
  final String number;

  /// The grade of authenticity (e.g., Sahih, Hasan, etc.)
  final String grade;

  /// Whether the hadith is bookmarked by the user
  final bool isBookmarked;

  /// Tags associated with the hadith for categorization
  final List<String> tags;

  /// Creates a new Hadith instance
  const Hadith({
    required this.id,
    required this.text,
    required this.narrator,
    required this.source,
    required this.book,
    required this.number,
    required this.grade,
    this.isBookmarked = false,
    this.tags = const [],
  });

  /// Creates a copy of this Hadith with the given fields replaced with the new values
  Hadith copyWith({
    String? id,
    String? text,
    String? narrator,
    String? source,
    String? book,
    String? number,
    String? grade,
    bool? isBookmarked,
    List<String>? tags,
  }) {
    return Hadith(
      id: id ?? this.id,
      text: text ?? this.text,
      narrator: narrator ?? this.narrator,
      source: source ?? this.source,
      book: book ?? this.book,
      number: number ?? this.number,
      grade: grade ?? this.grade,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [
        id,
        text,
        narrator,
        source,
        book,
        number,
        grade,
        isBookmarked,
        tags,
      ];
}
