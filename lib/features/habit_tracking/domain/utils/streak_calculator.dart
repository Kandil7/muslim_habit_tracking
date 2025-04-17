import '../../../../core/utils/date_utils.dart';
import '../entities/habit.dart';
import '../entities/habit_log.dart';

/// Utility class for calculating habit streaks
class StreakCalculator {
  /// Calculate the current streak for a habit based on its logs
  static int calculateCurrentStreak(List<HabitLog> logs, DateTime? lastCompletedDate) {
    if (logs.isEmpty) {
      return 0;
    }

    // Sort logs by date (newest first)
    logs.sort((a, b) => b.date.compareTo(a.date));

    int streak = 0;
    DateTime currentDate = DateTime.now();
    
    // Check if there's a log for today
    bool completedToday = logs.any((log) => DateTimeUtils.isSameDay(log.date, currentDate));
    
    // If we have a lastCompletedDate and it's today, consider it completed today
    if (!completedToday && lastCompletedDate != null && DateTimeUtils.isSameDay(lastCompletedDate, currentDate)) {
      completedToday = true;
    }

    if (completedToday) {
      streak = 1;

      // Check consecutive days
      for (int i = 1; i < 365; i++) {
        final previousDate = currentDate.subtract(Duration(days: i));
        final hasLogForPreviousDate = logs.any((log) => DateTimeUtils.isSameDay(log.date, previousDate));

        if (hasLogForPreviousDate) {
          streak++;
        } else {
          break;
        }
      }
    }

    return streak;
  }

  /// Calculate the longest streak for a habit based on its logs
  static int calculateLongestStreak(List<HabitLog> logs) {
    if (logs.isEmpty) {
      return 0;
    }

    // Sort logs by date (ascending)
    logs.sort((a, b) => a.date.compareTo(b.date));

    int longestStreak = 0;
    int currentStreak = 1;
    
    for (int i = 1; i < logs.length; i++) {
      final previousDate = logs[i - 1].date;
      final currentDate = logs[i].date;
      
      if (DateTimeUtils.daysBetween(previousDate, currentDate) == 1) {
        currentStreak++;
      } else {
        if (currentStreak > longestStreak) {
          longestStreak = currentStreak;
        }
        currentStreak = 1;
      }
    }
    
    // Check if the final streak is the longest
    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
    }
    
    return longestStreak;
  }

  /// Update streak information for a habit when a new log is added
  static Habit updateStreakInfo(Habit habit, List<HabitLog> logs, DateTime logDate) {
    // Check if this log is for today
    final isToday = DateTimeUtils.isSameDay(logDate, DateTime.now());
    
    // Calculate current streak
    final currentStreak = calculateCurrentStreak(logs, habit.lastCompletedDate);
    
    // Calculate longest streak
    final longestStreak = calculateLongestStreak(logs);
    
    // Update the habit with new streak information
    return habit.copyWith(
      currentStreak: currentStreak,
      longestStreak: longestStreak > habit.longestStreak ? longestStreak : habit.longestStreak,
      lastCompletedDate: isToday ? logDate : habit.lastCompletedDate,
    );
  }
  
  /// Check if a habit's streak is broken (missed a day)
  static bool isStreakBroken(Habit habit) {
    if (habit.currentStreak == 0 || habit.lastCompletedDate == null) {
      return false; // No streak to break
    }
    
    final today = DateTimeUtils.today;
    final yesterday = today.subtract(const Duration(days: 1));
    
    // If the last completed date is before yesterday, the streak is broken
    return habit.lastCompletedDate!.isBefore(yesterday) && 
           !DateTimeUtils.isSameDay(habit.lastCompletedDate!, yesterday);
  }
  
  /// Reset the current streak if it's broken
  static Habit resetBrokenStreak(Habit habit) {
    if (isStreakBroken(habit)) {
      return habit.copyWith(
        currentStreak: 0,
        // Don't clear lastCompletedDate as we still want to know when it was last completed
      );
    }
    return habit;
  }
}
