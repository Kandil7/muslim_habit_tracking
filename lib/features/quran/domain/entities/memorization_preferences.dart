import 'package:equatable/equatable.dart';

/// Direction of memorization
enum MemorizationDirection {
  /// Memorizing from Surah Al-Baqarah (2) to Surah An-Nas (114)
  fromBaqarah,

  /// Memorizing from Surah An-Nas (114) to Surah Al-Baqarah (2)
  fromNas
}

/// Entity representing user preferences for memorization
class MemorizationPreferences extends Equatable {
  /// User-selected review period in days (5, 6, or 7)
  final int reviewPeriod;

  /// Direction of memorization
  final MemorizationDirection memorizationDirection;

  /// Whether to show notifications for reviews
  final bool notificationsEnabled;

  /// Time for daily review notifications
  final TimeOfDay? notificationTime;

  /// Whether to show overdue item warnings
  final bool showOverdueWarnings;

  /// Constructor
  const MemorizationPreferences({
    required this.reviewPeriod,
    required this.memorizationDirection,
    this.notificationsEnabled = true,
    this.notificationTime,
    this.showOverdueWarnings = true,
  });

  @override
  List<Object?> get props => [
        reviewPeriod,
        memorizationDirection,
        notificationsEnabled,
        notificationTime,
        showOverdueWarnings,
      ];

  /// Creates a copy of this preferences with specified fields replaced
  MemorizationPreferences copyWith({
    int? reviewPeriod,
    MemorizationDirection? memorizationDirection,
    bool? notificationsEnabled,
    TimeOfDay? notificationTime,
    bool? showOverdueWarnings,
  }) {
    return MemorizationPreferences(
      reviewPeriod: reviewPeriod ?? this.reviewPeriod,
      memorizationDirection: memorizationDirection ?? this.memorizationDirection,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationTime: notificationTime ?? this.notificationTime,
      showOverdueWarnings: showOverdueWarnings ?? this.showOverdueWarnings,
    );
  }
}

/// Simple class to represent time of day
class TimeOfDay extends Equatable {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});

  @override
  List<Object?> get props => [hour, minute];

  /// Creates a copy of this time with specified fields replaced
  TimeOfDay copyWith({int? hour, int? minute}) {
    return TimeOfDay(
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }

  /// Returns a formatted string representation of the time
  String get formattedTime {
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }

  /// Creates a TimeOfDay from a DateTime
  factory TimeOfDay.fromDateTime(DateTime dateTime) {
    return TimeOfDay(
      hour: dateTime.hour,
      minute: dateTime.minute,
    );
  }
}