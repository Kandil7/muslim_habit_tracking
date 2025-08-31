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

  /// Whether to show motivational quotes in notifications
  final bool showMotivationalQuotes;

  /// Whether to enable haptic feedback for reviews
  final bool enableHapticFeedback;

  /// Constructor
  const MemorizationPreferences({
    required this.reviewPeriod,
    required this.memorizationDirection,
    this.notificationsEnabled = true,
    this.notificationTime,
    this.showOverdueWarnings = true,
    this.showMotivationalQuotes = true,
    this.enableHapticFeedback = true,
  });

  @override
  List<Object?> get props => [
        reviewPeriod,
        memorizationDirection,
        notificationsEnabled,
        notificationTime,
        showOverdueWarnings,
        showMotivationalQuotes,
        enableHapticFeedback,
      ];

  /// Creates a copy of this preferences with specified fields replaced
  MemorizationPreferences copyWith({
    int? reviewPeriod,
    MemorizationDirection? memorizationDirection,
    bool? notificationsEnabled,
    TimeOfDay? notificationTime,
    bool? showOverdueWarnings,
    bool? showMotivationalQuotes,
    bool? enableHapticFeedback,
  }) {
    return MemorizationPreferences(
      reviewPeriod: reviewPeriod ?? this.reviewPeriod,
      memorizationDirection: memorizationDirection ?? this.memorizationDirection,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationTime: notificationTime ?? this.notificationTime,
      showOverdueWarnings: showOverdueWarnings ?? this.showOverdueWarnings,
      showMotivationalQuotes: showMotivationalQuotes ?? this.showMotivationalQuotes,
      enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
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

  /// Converts TimeOfDay to DateTime for today
  DateTime toDateTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  /// Checks if this time is before the given time
  bool isBefore(TimeOfDay other) {
    if (hour < other.hour) return true;
    if (hour > other.hour) return false;
    return minute < other.minute;
  }

  /// Checks if this time is after the given time
  bool isAfter(TimeOfDay other) {
    if (hour > other.hour) return true;
    if (hour < other.hour) return false;
    return minute > other.minute;
  }
}