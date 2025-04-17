import 'dart:convert';

import '../../domain/entities/habit_category.dart';

/// Model class for HabitCategory entity
class HabitCategoryModel extends HabitCategory {
  const HabitCategoryModel({
    required super.id,
    required super.name,
    required super.description,
    required super.color,
    required super.icon,
    required super.createdAt,
  });
  
  /// Create a HabitCategoryModel from a JSON map
  factory HabitCategoryModel.fromJson(Map<String, dynamic> json) {
    return HabitCategoryModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      color: json['color'],
      icon: json['icon'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
  
  /// Convert this HabitCategoryModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color,
      'icon': icon,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  /// Create a HabitCategoryModel from a HabitCategory entity
  factory HabitCategoryModel.fromEntity(HabitCategory category) {
    return HabitCategoryModel(
      id: category.id,
      name: category.name,
      description: category.description,
      color: category.color,
      icon: category.icon,
      createdAt: category.createdAt,
    );
  }
  
  /// Create a copy of this HabitCategoryModel with the given fields replaced with the new values
  @override
  HabitCategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? color,
    String? icon,
    DateTime? createdAt,
  }) {
    return HabitCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
