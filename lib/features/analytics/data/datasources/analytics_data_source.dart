import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../habit_tracking/data/datasources/habit_local_data_source.dart';
import '../../../habit_tracking/data/models/habit_model.dart';
import '../../../habit_tracking/data/models/habit_log_model.dart';
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
}

/// Implementation of AnalyticsDataSource
class AnalyticsDataSourceImpl implements AnalyticsDataSource {
  final HabitLocalDataSource habitLocalDataSource;
  
  AnalyticsDataSourceImpl({
    required this.habitLocalDataSource,
  });
  
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
      final totalDays = DateTimeUtils.daysBetween(habit.createdAt, DateTime.now()) + 1;
      
      // Calculate completion rate
      final completionRate = totalDays > 0 ? (completionCount / totalDays) * 100 : 0.0;
      
      // Calculate current streak
      int currentStreak = 0;
      DateTime currentDate = DateTime.now();
      
      // Sort logs by date (descending)
      logs.sort((a, b) => b.date.compareTo(a.date));
      
      // Check if there's a log for today
      if (logs.isNotEmpty && DateTimeUtils.isSameDay(logs[0].date, currentDate)) {
        currentStreak = 1;
        
        // Check consecutive days
        for (int i = 1; i < logs.length; i++) {
          final previousDate = currentDate.subtract(Duration(days: i));
          final hasLogForPreviousDate = logs.any((log) => DateTimeUtils.isSameDay(log.date, previousDate));
          
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
      
      return HabitStatsModel(
        habitId: habitId,
        habitName: habit.name,
        completionCount: completionCount,
        totalDays: totalDays,
        completionRate: completionRate,
        currentStreak: currentStreak,
        longestStreak: longestStreak,
        weekdayCompletion: weekdayCompletion,
      );
    } catch (e) {
      throw CacheException(message: 'Failed to get habit stats');
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
        final completionRate = totalDays > 0 ? (completionCount / totalDays) * 100 : 0.0;
        
        // Calculate current streak within date range
        int currentStreak = 0;
        DateTime currentDate = endDate;
        
        // Sort logs by date (descending)
        logs.sort((a, b) => b.date.compareTo(a.date));
        
        // Check if there's a log for the end date
        if (logs.isNotEmpty && DateTimeUtils.isSameDay(logs[0].date, currentDate)) {
          currentStreak = 1;
          
          // Check consecutive days
          for (int i = 1; i < logs.length; i++) {
            final previousDate = currentDate.subtract(Duration(days: i));
            
            // Stop if we reach before the start date
            if (previousDate.isBefore(startDate)) {
              break;
            }
            
            final hasLogForPreviousDate = logs.any((log) => DateTimeUtils.isSameDay(log.date, previousDate));
            
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
        
        result.add(HabitStatsModel(
          habitId: habit.id,
          habitName: habit.name,
          completionCount: completionCount,
          totalDays: totalDays,
          completionRate: completionRate,
          currentStreak: currentStreak,
          longestStreak: longestStreak,
          weekdayCompletion: weekdayCompletion,
        ));
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
}
