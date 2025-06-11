import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../habit_tracking/data/datasources/habit_local_data_source.dart';
import '../models/habit_stats_model.dart';

/// Interface for analytics data source
abstract class AnalyticsDataSource {
  /// Get statistics for all habits
  Future<List<HabitStatsModel>> getAllHabitStats();

  /// Get statistics for a specific habit
  Future<HabitStatsModel> getHabitStats(String habitId);

  /// Get statistics for habits within a date range
  Future<List<HabitStatsModel>> getHabitStatsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Get overall completion rate for all habits
  Future<double> getOverallCompletionRate();

  /// Get the most consistent habit
  Future<HabitStatsModel> getMostConsistentHabit();

  /// Get the least consistent habit
  Future<HabitStatsModel> getLeastConsistentHabit();

  /// Export analytics data
  Future<String> exportAnalyticsData(String format);

  /// Set a goal for a habit
  Future<bool> setHabitGoal(
    String habitId,
    int? targetStreak,
    double? targetCompletionRate,
  );
}

/// Implementation of AnalyticsDataSource
class AnalyticsDataSourceImpl implements AnalyticsDataSource {
  final HabitLocalDataSource habitLocalDataSource;

  AnalyticsDataSourceImpl({required this.habitLocalDataSource});

  @override
  Future<List<HabitStatsModel>> getAllHabitStats() async {
    try {
      final habits = await habitLocalDataSource.getHabits();
      final List<HabitStatsModel> result = [];

      for (final habit in habits) {
        final stats = await getHabitStats(habit.id);
        result.add(stats);
      }

      return result;
    } catch (e) {
      throw CacheException(message: 'Failed to get all habit stats');
    }
  }

  @override
  Future<HabitStatsModel> getHabitStats(String habitId) async {
    try {
      final habit = await habitLocalDataSource.getHabitById(habitId);
      final logs = await habitLocalDataSource.getHabitLogs(habitId);

      // Calculate completion count
      final completionCount = logs.length;

      // Calculate total days (from habit creation to now)
      final totalDays =
          DateTimeUtils.daysBetween(habit.createdAt, DateTime.now()) + 1;

      // Calculate completion rate
      final completionRate =
          totalDays > 0 ? (completionCount / totalDays) * 100 : 0.0;

      // Calculate current streak
      int currentStreak = 0;
      DateTime currentDate = DateTime.now();

      // Sort logs by date (descending)
      logs.sort((a, b) => b.date.compareTo(a.date));

      // Check if there's a log for today
      if (logs.isNotEmpty &&
          DateTimeUtils.isSameDay(logs[0].date, currentDate)) {
        currentStreak = 1;

        // Check consecutive days
        for (int i = 1; i < logs.length; i++) {
          final previousDate = currentDate.subtract(Duration(days: i));
          final hasLogForPreviousDate = logs.any(
            (log) => DateTimeUtils.isSameDay(log.date, previousDate),
          );

          if (hasLogForPreviousDate) {
            currentStreak++;
          } else {
            break;
          }
        }
      }

      // Calculate longest streak
      int longestStreak = 0;
      int tempStreak = 0;

      // Sort logs by date (ascending)
      logs.sort((a, b) => a.date.compareTo(b.date));

      if (logs.isNotEmpty) {
        tempStreak = 1;

        for (int i = 1; i < logs.length; i++) {
          final previousDate = logs[i - 1].date;
          final currentDate = logs[i].date;

          if (DateTimeUtils.daysBetween(previousDate, currentDate) == 1) {
            tempStreak++;
          } else {
            if (tempStreak > longestStreak) {
              longestStreak = tempStreak;
            }
            tempStreak = 1;
          }
        }

        if (tempStreak > longestStreak) {
          longestStreak = tempStreak;
        }
      }

      // Calculate weekday completion
      final Map<String, int> weekdayCompletion = {
        'Monday': 0,
        'Tuesday': 0,
        'Wednesday': 0,
        'Thursday': 0,
        'Friday': 0,
        'Saturday': 0,
        'Sunday': 0,
      };

      for (final log in logs) {
        final weekday = DateTimeUtils.formatDayOfWeek(log.date);
        weekdayCompletion[weekday] = (weekdayCompletion[weekday] ?? 0) + 1;
      }

      // Calculate monthly completion rates
      final Map<String, double> monthlyCompletionRates = {};
      final Map<int, int> monthlyCompletionCounts = {};
      final Map<int, int> monthlyTotalDays = {};

      // Get the current month and year
      final now = DateTime.now();
      final currentYear = now.year;

      // Calculate for the last 12 months
      for (int i = 0; i < 12; i++) {
        final month = now.month - i;
        final year = currentYear - (month <= 0 ? 1 : 0);
        final adjustedMonth = month <= 0 ? month + 12 : month;

        final monthKey = '$year-${adjustedMonth.toString().padLeft(2, '0')}';
        monthlyCompletionCounts[adjustedMonth] = 0;

        // Calculate total days in this month (or partial month if it's the current month or habit creation month)
        DateTime monthStart = DateTime(year, adjustedMonth, 1);
        DateTime monthEnd = DateTime(
          year,
          adjustedMonth + 1,
          0,
        ); // Last day of month

        // Adjust start date if habit was created after month start
        if (habit.createdAt.isAfter(monthStart)) {
          monthStart = habit.createdAt;
        }

        // Adjust end date if it's the current month
        if (adjustedMonth == now.month && year == now.year) {
          monthEnd = now;
        }

        // Calculate days in this month (or partial month)
        final daysInMonth = DateTimeUtils.daysBetween(monthStart, monthEnd) + 1;
        monthlyTotalDays[adjustedMonth] = daysInMonth;

        // Count completions in this month
        for (final log in logs) {
          if (log.date.year == year && log.date.month == adjustedMonth) {
            monthlyCompletionCounts[adjustedMonth] =
                (monthlyCompletionCounts[adjustedMonth] ?? 0) + 1;
          }
        }

        // Calculate completion rate for this month
        final monthlyCompletionRate =
            daysInMonth > 0
                ? (monthlyCompletionCounts[adjustedMonth] ?? 0) /
                    daysInMonth *
                    100
                : 0.0;

        monthlyCompletionRates[monthKey] = monthlyCompletionRate;
      }

      // Calculate yearly completion rates
      final Map<String, double> yearlyCompletionRates = {};
      final Map<int, int> yearlyCompletionCounts = {};
      final Map<int, int> yearlyTotalDays = {};

      // Calculate for the last 3 years
      for (int i = 0; i < 3; i++) {
        final year = currentYear - i;
        final yearKey = year.toString();
        yearlyCompletionCounts[year] = 0;

        // Calculate total days in this year (or partial year if it's the current year or habit creation year)
        DateTime yearStart = DateTime(year, 1, 1);
        DateTime yearEnd = DateTime(year, 12, 31);

        // Adjust start date if habit was created after year start
        if (habit.createdAt.isAfter(yearStart)) {
          yearStart = habit.createdAt;
        }

        // Adjust end date if it's the current year
        if (year == now.year) {
          yearEnd = now;
        }

        // Calculate days in this year (or partial year)
        final daysInYear = DateTimeUtils.daysBetween(yearStart, yearEnd) + 1;
        yearlyTotalDays[year] = daysInYear;

        // Count completions in this year
        for (final log in logs) {
          if (log.date.year == year) {
            yearlyCompletionCounts[year] =
                (yearlyCompletionCounts[year] ?? 0) + 1;
          }
        }

        // Calculate completion rate for this year
        final yearlyCompletionRate =
            daysInYear > 0
                ? (yearlyCompletionCounts[year] ?? 0) / daysInYear * 100
                : 0.0;

        yearlyCompletionRates[yearKey] = yearlyCompletionRate;
      }

      // Check if habit has a goal and if it's reached
      bool hasReachedGoal = false;
      int? targetStreak = habit.targetStreak;
      double? targetCompletionRate = habit.targetCompletionRate;

      if (targetStreak != null && currentStreak >= targetStreak) {
        hasReachedGoal = true;
      } else if (targetCompletionRate != null &&
          completionRate >= targetCompletionRate) {
        hasReachedGoal = true;
      }

      return HabitStatsModel(
        habitId: habitId,
        habitName: habit.name,
        completionCount: completionCount,
        totalDays: totalDays,
        completionRate: completionRate,
        currentStreak: currentStreak,
        longestStreak: longestStreak,
        weekdayCompletion: weekdayCompletion,
        monthlyCompletionRates: monthlyCompletionRates,
        yearlyCompletionRates: yearlyCompletionRates,
        targetStreak: targetStreak,
        targetCompletionRate: targetCompletionRate,
        hasReachedGoal: hasReachedGoal,
      );
    } catch (e) {
      throw CacheException(message: 'Failed to get habit stats: $e');
    }
  }

  @override
  Future<List<HabitStatsModel>> getHabitStatsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final habits = await habitLocalDataSource.getHabits();
      final List<HabitStatsModel> result = [];

      for (final habit in habits) {
        final logs = await habitLocalDataSource.getHabitLogsByDateRange(
          habit.id,
          startDate,
          endDate,
        );

        // Calculate completion count within date range
        final completionCount = logs.length;

        // Calculate total days in the date range
        final totalDays = DateTimeUtils.daysBetween(startDate, endDate) + 1;

        // Calculate completion rate
        final completionRate =
            totalDays > 0 ? (completionCount / totalDays) * 100 : 0.0;

        // Calculate current streak within date range
        int currentStreak = 0;
        DateTime currentDate = endDate;

        // Sort logs by date (descending)
        logs.sort((a, b) => b.date.compareTo(a.date));

        // Check if there's a log for the end date
        if (logs.isNotEmpty &&
            DateTimeUtils.isSameDay(logs[0].date, currentDate)) {
          currentStreak = 1;

          // Check consecutive days
          for (int i = 1; i < logs.length; i++) {
            final previousDate = currentDate.subtract(Duration(days: i));

            // Stop if we reach before the start date
            if (previousDate.isBefore(startDate)) {
              break;
            }

            final hasLogForPreviousDate = logs.any(
              (log) => DateTimeUtils.isSameDay(log.date, previousDate),
            );

            if (hasLogForPreviousDate) {
              currentStreak++;
            } else {
              break;
            }
          }
        }

        // Calculate longest streak within date range
        int longestStreak = 0;
        int tempStreak = 0;

        // Sort logs by date (ascending)
        logs.sort((a, b) => a.date.compareTo(b.date));

        if (logs.isNotEmpty) {
          tempStreak = 1;

          for (int i = 1; i < logs.length; i++) {
            final previousDate = logs[i - 1].date;
            final currentDate = logs[i].date;

            if (DateTimeUtils.daysBetween(previousDate, currentDate) == 1) {
              tempStreak++;
            } else {
              if (tempStreak > longestStreak) {
                longestStreak = tempStreak;
              }
              tempStreak = 1;
            }
          }

          if (tempStreak > longestStreak) {
            longestStreak = tempStreak;
          }
        }

        // Calculate weekday completion within date range
        final Map<String, int> weekdayCompletion = {
          'Monday': 0,
          'Tuesday': 0,
          'Wednesday': 0,
          'Thursday': 0,
          'Friday': 0,
          'Saturday': 0,
          'Sunday': 0,
        };

        for (final log in logs) {
          final weekday = DateTimeUtils.formatDayOfWeek(log.date);
          weekdayCompletion[weekday] = (weekdayCompletion[weekday] ?? 0) + 1;
        }

        result.add(
          HabitStatsModel(
            habitId: habit.id,
            habitName: habit.name,
            completionCount: completionCount,
            totalDays: totalDays,
            completionRate: completionRate,
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            weekdayCompletion: weekdayCompletion,
          ),
        );
      }

      return result;
    } catch (e) {
      throw CacheException(message: 'Failed to get habit stats by date range');
    }
  }

  @override
  Future<double> getOverallCompletionRate() async {
    try {
      final habitStats = await getAllHabitStats();

      if (habitStats.isEmpty) {
        return 0.0;
      }

      final totalCompletionRate = habitStats.fold<double>(
        0.0,
        (sum, stats) => sum + stats.completionRate,
      );

      return totalCompletionRate / habitStats.length;
    } catch (e) {
      throw CacheException(message: 'Failed to get overall completion rate');
    }
  }

  @override
  Future<HabitStatsModel> getMostConsistentHabit() async {
    try {
      final habitStats = await getAllHabitStats();

      if (habitStats.isEmpty) {
        throw CacheException(message: 'No habits found');
      }

      // Sort by completion rate (descending)
      habitStats.sort((a, b) => b.completionRate.compareTo(a.completionRate));

      return habitStats.first;
    } catch (e) {
      throw CacheException(message: 'Failed to get most consistent habit');
    }
  }

  @override
  Future<HabitStatsModel> getLeastConsistentHabit() async {
    try {
      final habitStats = await getAllHabitStats();

      if (habitStats.isEmpty) {
        throw CacheException(message: 'No habits found');
      }

      // Sort by completion rate (ascending)
      habitStats.sort((a, b) => a.completionRate.compareTo(b.completionRate));

      return habitStats.first;
    } catch (e) {
      throw CacheException(message: 'Failed to get least consistent habit');
    }
  }

  @override
  Future<String> exportAnalyticsData(String format) async {
    try {
      final habitStats = await getAllHabitStats();

      if (habitStats.isEmpty) {
        throw CacheException(message: 'No habits found to export');
      }

      // Create a temporary file path
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/habit_analytics.$format';
      final file = File(path);

      if (format.toLowerCase() == 'csv') {
        // Create CSV header
        final csvData = StringBuffer();
        csvData.writeln(
          'Habit Name,Completion Rate (%),Current Streak,Longest Streak,Total Completions,Total Days',
        );

        // Add data for each habit
        for (final stats in habitStats) {
          csvData.writeln(
            '${stats.habitName},${stats.completionRate.toStringAsFixed(1)},${stats.currentStreak},${stats.longestStreak},${stats.completionCount},${stats.totalDays}',
          );
        }

        // Write to file
        await file.writeAsString(csvData.toString());
      } else {
        throw CacheException(message: 'Unsupported export format: $format');
      }

      return path;
    } catch (e) {
      throw CacheException(message: 'Failed to export analytics data: $e');
    }
  }

  @override
  Future<bool> setHabitGoal(
    String habitId,
    int? targetStreak,
    double? targetCompletionRate,
  ) async {
    try {
      // Get the habit
      final habit = await habitLocalDataSource.getHabitById(habitId);

      // Update the habit with the new goals
      final updatedHabit = habit.copyWith(
        targetStreak: targetStreak,
        targetCompletionRate: targetCompletionRate,
      );

      // Save the updated habit
      await habitLocalDataSource.updateHabit(updatedHabit);

      return true;
    } catch (e) {
      throw CacheException(message: 'Failed to set habit goal: $e');
    }
  }
}
