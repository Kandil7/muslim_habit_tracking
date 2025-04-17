import 'package:flutter/material.dart';

/// Model representing a dashboard card
class DashboardCardModel {
  final String id;
  final String title;
  final IconData icon;
  final bool isVisible;
  final int order;
  
  DashboardCardModel({
    required this.id,
    required this.title,
    required this.icon,
    this.isVisible = true,
    required this.order,
  });
  
  /// Create a copy of this DashboardCardModel with the given fields replaced with the new values
  DashboardCardModel copyWith({
    String? id,
    String? title,
    IconData? icon,
    bool? isVisible,
    int? order,
  }) {
    return DashboardCardModel(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      isVisible: isVisible ?? this.isVisible,
      order: order ?? this.order,
    );
  }
  
  /// Create a DashboardCardModel from a JSON map
  factory DashboardCardModel.fromJson(Map<String, dynamic> json) {
    return DashboardCardModel(
      id: json['id'],
      title: json['title'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      isVisible: json['isVisible'] ?? true,
      order: json['order'],
    );
  }
  
  /// Convert this DashboardCardModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon.codePoint,
      'isVisible': isVisible,
      'order': order,
    };
  }
}
