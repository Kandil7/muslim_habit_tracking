import 'package:intl/intl.dart';

/// Utility class for date and time operations
class DateTimeUtils {
  /// List of days of the week
  static const List<String> daysOfWeek = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  /// Get today's date with time set to midnight
  static DateTime get today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Get the start of the current week (Monday)
  static DateTime get startOfWeek {
    final now = DateTime.now();
    final weekday = now.weekday;
    return DateTime(now.year, now.month, now.day - weekday + 1);
  }

  /// Get the end of the current week (Sunday)
  static DateTime get endOfWeek {
    final now = DateTime.now();
    final weekday = now.weekday;
    return DateTime(now.year, now.month, now.day + (7 - weekday));
  }

  /// Get the start of the current month
  static DateTime get startOfMonth {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  /// Get the end of the current month
  static DateTime get endOfMonth {
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0);
  }
  /// Format a DateTime to a readable string (e.g., "Monday, January 1, 2023")
  static String formatDate(DateTime date) {
    return DateFormat.yMMMMd().format(date);
  }

  /// Format a DateTime to a short date string (e.g., "Jan 1, 2023")
  static String formatShortDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  /// Format a DateTime to a time string (e.g., "12:30 PM")
  static String formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }

  /// Format a DateTime to a day of week string (e.g., "Monday")
  static String formatDayOfWeek(DateTime date) {
    return DateFormat.EEEE().format(date);
  }




  /// Check if two dates are the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  /// Get the difference in days between two dates
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  /// Convert minutes to a readable duration string (e.g., "1h 30m")
  static String minutesToDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0) {
      return '${hours}h ${remainingMinutes}m';
    } else {
      return '${remainingMinutes}m';
    }
  }
}
