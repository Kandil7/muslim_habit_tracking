import 'package:equatable/equatable.dart';

/// UnlockableContent entity representing content that can be unlocked
class UnlockableContent extends Equatable {
  /// Unique identifier for the content
  final String id;
  
  /// Name of the content
  final String name;
  
  /// Description of the content
  final String description;
  
  /// Type of content (e.g., quote, dua, wallpaper)
  final String contentType;
  
  /// Path to the content (asset path or URL)
  final String contentPath;
  
  /// Points required to unlock this content
  final int pointsRequired;
  
  /// Whether the content has been unlocked
  final bool isUnlocked;
  
  /// Date when the content was unlocked
  final DateTime? unlockedDate;
  
  /// Preview image path for locked content
  final String previewPath;

  /// Creates a new UnlockableContent
  const UnlockableContent({
    required this.id,
    required this.name,
    required this.description,
    required this.contentType,
    required this.contentPath,
    required this.pointsRequired,
    this.isUnlocked = false,
    this.unlockedDate,
    required this.previewPath,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    contentType,
    contentPath,
    pointsRequired,
    isUnlocked,
    unlockedDate,
    previewPath,
  ];

  /// Create a copy of this UnlockableContent with the given fields replaced with the new values
  UnlockableContent copyWith({
    String? id,
    String? name,
    String? description,
    String? contentType,
    String? contentPath,
    int? pointsRequired,
    bool? isUnlocked,
    DateTime? unlockedDate,
    bool clearUnlockedDate = false,
    String? previewPath,
  }) {
    return UnlockableContent(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      contentType: contentType ?? this.contentType,
      contentPath: contentPath ?? this.contentPath,
      pointsRequired: pointsRequired ?? this.pointsRequired,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedDate: clearUnlockedDate ? null : (unlockedDate ?? this.unlockedDate),
      previewPath: previewPath ?? this.previewPath,
    );
  }

  /// Unlock this content
  UnlockableContent unlock() {
    if (isUnlocked) return this;
    
    return copyWith(
      isUnlocked: true,
      unlockedDate: DateTime.now(),
    );
  }
}
