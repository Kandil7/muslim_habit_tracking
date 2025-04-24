import 'package:equatable/equatable.dart';

/// Badge entity representing an achievement badge
class Badge extends Equatable {
  /// Unique identifier for the badge
  final String id;
  
  /// Name of the badge
  final String name;
  
  /// Description of how to earn the badge
  final String description;
  
  /// Path to the badge icon asset
  final String iconPath;
  
  /// Category of the badge (e.g., prayer, quran, fasting)
  final String category;
  
  /// Level of the badge (e.g., bronze, silver, gold)
  final String level;
  
  /// Points awarded for earning this badge
  final int points;
  
  /// Whether the badge has been earned
  final bool isEarned;
  
  /// Date when the badge was earned
  final DateTime? earnedDate;
  
  /// Progress towards earning the badge (0-100)
  final int progress;
  
  /// Requirements to earn the badge (e.g., {"streak": 5} for a 5-day streak)
  final Map<String, dynamic> requirements;

  /// Creates a new Badge
  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.category,
    required this.level,
    required this.points,
    this.isEarned = false,
    this.earnedDate,
    this.progress = 0,
    required this.requirements,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    iconPath,
    category,
    level,
    points,
    isEarned,
    earnedDate,
    progress,
    requirements,
  ];

  /// Create a copy of this Badge with the given fields replaced with the new values
  Badge copyWith({
    String? id,
    String? name,
    String? description,
    String? iconPath,
    String? category,
    String? level,
    int? points,
    bool? isEarned,
    DateTime? earnedDate,
    bool clearEarnedDate = false,
    int? progress,
    Map<String, dynamic>? requirements,
  }) {
    return Badge(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      category: category ?? this.category,
      level: level ?? this.level,
      points: points ?? this.points,
      isEarned: isEarned ?? this.isEarned,
      earnedDate: clearEarnedDate ? null : (earnedDate ?? this.earnedDate),
      progress: progress ?? this.progress,
      requirements: requirements ?? this.requirements,
    );
  }
}
