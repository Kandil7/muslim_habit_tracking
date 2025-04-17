import 'package:hive/hive.dart';
import '../../domain/entities/hadith.dart';

/// Model class for Hadith with JSON serialization/deserialization
class HadithModel extends Hadith {
  /// Creates a new HadithModel instance
  const HadithModel({
    required String id,
    required String text,
    required String narrator,
    required String source,
    required String book,
    required String number,
    required String grade,
    bool isBookmarked = false,
    List<String> tags = const [],
  }) : super(
          id: id,
          text: text,
          narrator: narrator,
          source: source,
          book: book,
          number: number,
          grade: grade,
          isBookmarked: isBookmarked,
          tags: tags,
        );

  /// Creates a HadithModel from a JSON map
  factory HadithModel.fromJson(Map<String, dynamic> json) {
    return HadithModel(
      id: json['id'] as String,
      text: json['text'] as String,
      narrator: json['narrator'] as String,
      source: json['source'] as String,
      book: json['book'] as String,
      number: json['number'] as String,
      grade: json['grade'] as String,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
    );
  }

  /// Creates a HadithModel from a Hive object
  factory HadithModel.fromHiveObject(Map<dynamic, dynamic> hiveObject) {
    return HadithModel(
      id: hiveObject['id'] as String,
      text: hiveObject['text'] as String,
      narrator: hiveObject['narrator'] as String,
      source: hiveObject['source'] as String,
      book: hiveObject['book'] as String,
      number: hiveObject['number'] as String,
      grade: hiveObject['grade'] as String,
      isBookmarked: hiveObject['isBookmarked'] as bool? ?? false,
      tags: (hiveObject['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  /// Converts this HadithModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'narrator': narrator,
      'source': source,
      'book': book,
      'number': number,
      'grade': grade,
      'isBookmarked': isBookmarked,
      'tags': tags,
    };
  }

  /// Converts this HadithModel to a Hive object
  Map<String, dynamic> toHiveObject() {
    return {
      'id': id,
      'text': text,
      'narrator': narrator,
      'source': source,
      'book': book,
      'number': number,
      'grade': grade,
      'isBookmarked': isBookmarked,
      'tags': tags,
    };
  }

  /// Creates a copy of this HadithModel with the given fields replaced with the new values
  @override
  HadithModel copyWith({
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
    return HadithModel(
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
}
