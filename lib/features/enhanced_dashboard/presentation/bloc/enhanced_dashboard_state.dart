part of 'enhanced_dashboard_bloc.dart';

/// Base state class for enhanced dashboard
abstract class EnhancedDashboardState {}

/// Initial state
class EnhancedDashboardInitial extends EnhancedDashboardState {}

/// Loading state
class EnhancedDashboardLoading extends EnhancedDashboardState {}

/// Loaded state with dashboard data
class EnhancedDashboardLoaded extends EnhancedDashboardState {
  final String userName;
  final TodaysOverview todaysOverview;
  final TaskProgress taskProgress;
  final List<UpcomingReminder> upcomingReminders;
  final MotivationalSnippet motivationalSnippet;
  final List<QuickAction> quickActions;

  EnhancedDashboardLoaded({
    required this.userName,
    required this.todaysOverview,
    required this.taskProgress,
    required this.upcomingReminders,
    required this.motivationalSnippet,
    required this.quickActions,
  });

  EnhancedDashboardLoaded copyWith({
    String? userName,
    TodaysOverview? todaysOverview,
    TaskProgress? taskProgress,
    List<UpcomingReminder>? upcomingReminders,
    MotivationalSnippet? motivationalSnippet,
    List<QuickAction>? quickActions,
  }) {
    return EnhancedDashboardLoaded(
      userName: userName ?? this.userName,
      todaysOverview: todaysOverview ?? this.todaysOverview,
      taskProgress: taskProgress ?? this.taskProgress,
      upcomingReminders: upcomingReminders ?? this.upcomingReminders,
      motivationalSnippet: motivationalSnippet ?? this.motivationalSnippet,
      quickActions: quickActions ?? this.quickActions,
    );
  }
}

/// Error state
class EnhancedDashboardError extends EnhancedDashboardState {
  final String message;

  EnhancedDashboardError(this.message);
}

/// Data models for dashboard
class TodaysOverview {
  final List<ScheduledActivity> activities;
  final int completedTasks;
  final int totalTasks;
  final String nextPrayerTime;
  final String nextPrayerName;

  TodaysOverview({
    required this.activities,
    required this.completedTasks,
    required this.totalTasks,
    required this.nextPrayerTime,
    required this.nextPrayerName,
  });
}

class ScheduledActivity {
  final String id;
  final String title;
  final String time;
  final String category;
  final bool isCompleted;

  ScheduledActivity({
    required this.id,
    required this.title,
    required this.time,
    required this.category,
    required this.isCompleted,
  });
}

class TaskProgress {
  final double overallCompletion;
  final Map<String, double> categoryCompletion;
  final int currentStreak;
  final int longestStreak;

  TaskProgress({
    required this.overallCompletion,
    required this.categoryCompletion,
    required this.currentStreak,
    required this.longestStreak,
  });
}

class UpcomingReminder {
  final String id;
  final String title;
  final String time;
  final String type;
  final int minutesUntil;

  UpcomingReminder({
    required this.id,
    required this.title,
    required this.time,
    required this.type,
    required this.minutesUntil,
  });
}

class MotivationalSnippet {
  final String text;
  final String source;
  final String type; // ayah, hadith, quote

  MotivationalSnippet({
    required this.text,
    required this.source,
    required this.type,
  });
}

class QuickAction {
  final String id;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  QuickAction({
    required this.id,
    required this.title,
    required this.icon,
    required this.onTap,
  });
}