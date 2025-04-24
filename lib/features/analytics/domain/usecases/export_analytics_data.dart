import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:muslim_habbit/features/analytics/domain/entities/habit_stats.dart';

/// Use case for exporting analytics data
class ExportAnalyticsData {
  /// Export analytics data as CSV
  Future<String> exportToCsv(List<HabitStats> habitStats) async {
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/habit_analytics.csv';
    final file = File(path);
    
    // Create CSV header
    final csvData = StringBuffer();
    csvData.writeln('Habit Name,Completion Rate (%),Current Streak,Longest Streak,Total Completions,Total Days');
    
    // Add data for each habit
    for (final stats in habitStats) {
      csvData.writeln(
        '${stats.habitName},${stats.completionRate.toStringAsFixed(1)},${stats.currentStreak},${stats.longestStreak},${stats.completionCount},${stats.totalDays}'
      );
    }
    
    // Write to file
    await file.writeAsString(csvData.toString());
    
    return path;
  }
  
  /// Share analytics data as CSV
  Future<void> shareAnalyticsData(List<HabitStats> habitStats) async {
    final path = await exportToCsv(habitStats);
    final file = XFile(path);
    
    await Share.shareXFiles(
      [file],
      subject: 'Habit Analytics Data',
      text: 'Here is your habit analytics data',
    );
  }
}
