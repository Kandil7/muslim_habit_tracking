import 'package:equatable/equatable.dart';

/// Entity representing a learning resource
class Resource extends Equatable {
  final String id;
  final String title;
  final String url;
  final ResourceType type;
  final String? description;
  final int rating; // 1-5 stars
  final List<String> tags;
  final bool isFavorite;
  final bool isOfflineAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Resource({
    required this.id,
    required this.title,
    required this.url,
    required this.type,
    this.description,
    required this.rating,
    required this.tags,
    required this.isFavorite,
    required this.isOfflineAvailable,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        url,
        type,
        description,
        rating,
        tags,
        isFavorite,
        isOfflineAvailable,
        createdAt,
        updatedAt,
      ];

  Resource copyWith({
    String? id,
    String? title,
    String? url,
    ResourceType? type,
    String? description,
    int? rating,
    List<String>? tags,
    bool? isFavorite,
    bool? isOfflineAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Resource(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      type: type ?? this.type,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      isOfflineAvailable: isOfflineAvailable ?? this.isOfflineAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Enum for resource types
enum ResourceType {
  article,
  tutorial,
  documentation,
  video,
  book,
  course,
}