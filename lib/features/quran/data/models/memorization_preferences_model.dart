import '../../domain/entities/memorization_preferences.dart';

/// Data model for MemorizationPreferences that extends the entity with serialization methods
class MemorizationPreferencesModel extends MemorizationPreferences {
  /// Constructor
  const MemorizationPreferencesModel({
    required super.reviewPeriod,
    required super.memorizationDirection,
    super.notificationsEnabled,
    super.notificationTime,
  }) : super();

  /// Factory method to create from entity
  factory MemorizationPreferencesModel.fromEntity(MemorizationPreferences entity) {
    return MemorizationPreferencesModel(
      reviewPeriod: entity.reviewPeriod,
      memorizationDirection: entity.memorizationDirection,
      notificationsEnabled: entity.notificationsEnabled,
      notificationTime: entity.notificationTime,
    );
  }

  /// Factory method to create from JSON
  factory MemorizationPreferencesModel.fromJson(Map<String, dynamic> json) {
    return MemorizationPreferencesModel(
      reviewPeriod: json['reviewPeriod'] as int,
      memorizationDirection:
          _directionFromString(json['memorizationDirection'] as String),
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      notificationTime: json['notificationTime'] == null
          ? null
          : TimeOfDay(
              hour: (json['notificationTime'] as Map<String, dynamic>)['hour'] as int,
              minute: (json['notificationTime'] as Map<String, dynamic>)['minute'] as int,
            ),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'reviewPeriod': reviewPeriod,
      'memorizationDirection': _directionToString(memorizationDirection),
      'notificationsEnabled': notificationsEnabled,
      'notificationTime': notificationTime == null
          ? null
          : {
              'hour': notificationTime!.hour,
              'minute': notificationTime!.minute,
            },
    };
  }

  /// Convert direction to string
  String _directionToString(MemorizationDirection direction) {
    switch (direction) {
      case MemorizationDirection.fromBaqarah:
        return 'fromBaqarah';
      case MemorizationDirection.fromNas:
        return 'fromNas';
    }
  }

  /// Convert string to direction
  static MemorizationDirection _directionFromString(String direction) {
    switch (direction) {
      case 'fromBaqarah':
        return MemorizationDirection.fromBaqarah;
      case 'fromNas':
        return MemorizationDirection.fromNas;
      default:
        return MemorizationDirection.fromBaqarah;
    }
  }
}