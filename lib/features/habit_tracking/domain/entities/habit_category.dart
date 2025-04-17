import 'package:equatable/equatable.dart';

/// HabitCategory entity representing a category for habits
class HabitCategory extends Equatable {
  final String id;
  final String name;
  final String description;
  final String color;
  final String icon;
  final DateTime createdAt;
  
  const HabitCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
    required this.createdAt,
  });
  
  @override
  List<Object> get props => [
    id,
    name,
    description,
    color,
    icon,
    createdAt,
  ];
  
  /// Create a copy of this HabitCategory with the given fields replaced with the new values
  HabitCategory copyWith({
    String? id,
    String? name,
    String? description,
    String? color,
    String? icon,
    DateTime? createdAt,
  }) {
    return HabitCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
