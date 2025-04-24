import 'package:equatable/equatable.dart';

/// Model for motivational quotes and Islamic teachings
class MotivationalQuote extends Equatable {
  /// Unique identifier for the quote
  final String id;
  
  /// The quote text
  final String text;
  
  /// The quote text in Arabic (optional)
  final String? arabicText;
  
  /// The source of the quote (e.g., Quran, Hadith, Scholar)
  final String source;
  
  /// The reference (e.g., Surah number, Hadith number)
  final String reference;
  
  /// Tags for categorizing quotes
  final List<String> tags;
  
  /// Creates a new MotivationalQuote
  const MotivationalQuote({
    required this.id,
    required this.text,
    this.arabicText,
    required this.source,
    required this.reference,
    this.tags = const [],
  });
  
  @override
  List<Object?> get props => [id, text, arabicText, source, reference, tags];
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'arabicText': arabicText,
      'source': source,
      'reference': reference,
      'tags': tags,
    };
  }
  
  /// Create from JSON
  factory MotivationalQuote.fromJson(Map<String, dynamic> json) {
    return MotivationalQuote(
      id: json['id'],
      text: json['text'],
      arabicText: json['arabicText'],
      source: json['source'],
      reference: json['reference'],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}
