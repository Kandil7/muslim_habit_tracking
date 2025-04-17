import 'package:flutter/material.dart';
import '../../../../core/theme/app_icons.dart';

/// Model representing a quick action
class QuickActionModel {
  final String id;
  final String label;
  final IconData icon;
  final bool enabled;
  
  QuickActionModel({
    required this.id,
    required this.label,
    required this.icon,
    this.enabled = true,
  });
  
  /// Create a copy of this QuickActionModel with the given fields replaced with the new values
  QuickActionModel copyWith({
    String? id,
    String? label,
    IconData? icon,
    bool? enabled,
  }) {
    return QuickActionModel(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      enabled: enabled ?? this.enabled,
    );
  }
  
  /// Create a QuickActionModel from a JSON map
  factory QuickActionModel.fromJson(Map<String, dynamic> json) {
    return QuickActionModel(
      id: json['id'],
      label: json['label'],
      icon: _getIconFromString(json['icon']),
      enabled: json['enabled'] ?? true,
    );
  }
  
  /// Convert this QuickActionModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'icon': _getStringFromIcon(icon),
      'enabled': enabled,
    };
  }
  
  /// Get the icon data from a string identifier
  static IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'habit':
        return AppIcons.habit;
      case 'prayer':
        return AppIcons.prayer;
      case 'quran':
        return Icons.menu_book;
      case 'dua':
        return AppIcons.dua;
      case 'analytics':
        return AppIcons.analytics;
      case 'settings':
        return AppIcons.settings;
      case 'qibla':
        return Icons.explore;
      case 'calendar':
        return Icons.calendar_today;
      default:
        return Icons.star;
    }
  }
  
  /// Get a string identifier from an icon
  static String _getStringFromIcon(IconData icon) {
    if (icon == AppIcons.habit) return 'habit';
    if (icon == AppIcons.prayer) return 'prayer';
    if (icon == Icons.menu_book) return 'quran';
    if (icon == AppIcons.dua) return 'dua';
    if (icon == AppIcons.analytics) return 'analytics';
    if (icon == AppIcons.settings) return 'settings';
    if (icon == Icons.explore) return 'qibla';
    if (icon == Icons.calendar_today) return 'calendar';
    return 'star';
  }
}
