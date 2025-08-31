import '../../domain/entities/memorization_item.dart';

/// Data model for MemorizationItem that extends the entity with serialization methods
class MemorizationItemModel extends MemorizationItem {
  /// Constructor
  const MemorizationItemModel({
    required super.id,
    required super.surahNumber,
    required super.surahName,
    required super.startPage,
    required super.endPage,
    required super.dateAdded,
    required super.status,
    required super.consecutiveReviewDays,
    required super.lastReviewed,
    required super.reviewHistory,
  }) : super();

  /// Factory method to create from entity
  factory MemorizationItemModel.fromEntity(MemorizationItem entity) {
    return MemorizationItemModel(
      id: entity.id,
      surahNumber: entity.surahNumber,
      surahName: entity.surahName,
      startPage: entity.startPage,
      endPage: entity.endPage,
      dateAdded: entity.dateAdded,
      status: entity.status,
      consecutiveReviewDays: entity.consecutiveReviewDays,
      lastReviewed: entity.lastReviewed,
      reviewHistory: entity.reviewHistory,
    );
  }

  /// Factory method to create from JSON
  factory MemorizationItemModel.fromJson(Map<String, dynamic> json) {
    return MemorizationItemModel(
      id: json['id'] as String,
      surahNumber: json['surahNumber'] as int,
      surahName: json['surahName'] as String,
      startPage: json['startPage'] as int,
      endPage: json['endPage'] as int,
      dateAdded: DateTime.parse(json['dateAdded'] as String),
      status: _statusFromString(json['status'] as String),
      consecutiveReviewDays: json['consecutiveReviewDays'] as int,
      lastReviewed: json['lastReviewed'] == null
          ? null
          : DateTime.parse(json['lastReviewed'] as String),
      reviewHistory: (json['reviewHistory'] as List<dynamic>)
          .map((date) => DateTime.parse(date as String))
          .toList(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'surahNumber': surahNumber,
      'surahName': surahName,
      'startPage': startPage,
      'endPage': endPage,
      'dateAdded': dateAdded.toIso8601String(),
      'status': _statusToString(status),
      'consecutiveReviewDays': consecutiveReviewDays,
      'lastReviewed': lastReviewed?.toIso8601String(),
      'reviewHistory': reviewHistory.map((date) => date.toIso8601String()).toList(),
    };
  }

  /// Convert status to string
  String _statusToString(MemorizationStatus status) {
    switch (status) {
      case MemorizationStatus.newStatus:
        return 'new';
      case MemorizationStatus.inProgress:
        return 'inProgress';
      case MemorizationStatus.memorized:
        return 'memorized';
      case MemorizationStatus.archived:
        return 'archived';
    }
  }

  /// Convert string to status
  static MemorizationStatus _statusFromString(String status) {
    switch (status) {
      case 'new':
        return MemorizationStatus.newStatus;
      case 'inProgress':
        return MemorizationStatus.inProgress;
      case 'memorized':
        return MemorizationStatus.memorized;
      case 'archived':
        return MemorizationStatus.archived;
      default:
        return MemorizationStatus.newStatus;
    }
  }
}