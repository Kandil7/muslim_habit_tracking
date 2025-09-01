import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'enhanced_dashboard_event.dart';
part 'enhanced_dashboard_state.dart';

/// BLoC for managing enhanced dashboard state
class EnhancedDashboardBloc extends Bloc<EnhancedDashboardEvent, EnhancedDashboardState> {
  EnhancedDashboardBloc() : super(EnhancedDashboardInitial()) {
    on<LoadDashboardDataEvent>(_onLoadDashboardData);
    on<UpdateUserNameEvent>(_onUpdateUserName);
    on<ToggleCardVisibilityEvent>(_onToggleCardVisibility);
    on<ReorderCardsEvent>(_onReorderCards);
  }

  /// Handle loading dashboard data
  Future<void> _onLoadDashboardData(
    LoadDashboardDataEvent event,
    Emitter<EnhancedDashboardState> emit,
  ) async {
    emit(EnhancedDashboardLoading());
    try {
      // Simulate loading data
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Create mock data - in a real app, this would come from repositories
      final todaysOverview = TodaysOverview(
        activities: [
          ScheduledActivity(
            id: '1',
            title: 'Fajr Prayer',
            time: '5:30 AM',
            category: 'Ibadah',
            isCompleted: true,
          ),
          ScheduledActivity(
            id: '2',
            title: 'Quran Reading',
            time: '6:00 AM',
            category: 'Ibadah',
            isCompleted: false,
          ),
          ScheduledActivity(
            id: '3',
            title: 'Programming Practice',
            time: '9:00 AM',
            category: 'Skills',
            isCompleted: false,
          ),
        ],
        completedTasks: 1,
        totalTasks: 3,
        nextPrayerTime: '1:15 PM',
        nextPrayerName: 'Dhuhr',
      );

      final taskProgress = TaskProgress(
        overallCompletion: 33.3,
        categoryCompletion: {
          'Ibadah': 50.0,
          'Skills': 25.0,
          'Self-Development': 0.0,
        },
        currentStreak: 5,
        longestStreak: 12,
      );

      final upcomingReminders = [
        UpcomingReminder(
          id: '1',
          title: 'Dhuhr Prayer',
          time: '1:15 PM',
          type: 'prayer',
          minutesUntil: 45,
        ),
        UpcomingReminder(
          id: '2',
          title: 'Quran Reading',
          time: '6:00 PM',
          type: 'quran',
          minutesUntil: 180,
        ),
      ];

      final motivationalSnippet = MotivationalSnippet(
        text: 'And whoever relies upon Allah - then He is sufficient for him.',
        source: 'Quran 65:3',
        type: 'ayah',
      );

      final quickActions = [
        QuickAction(
          id: 'planner',
          title: 'Daily Planner',
          icon: Icons.calendar_today,
          onTap: () {},
        ),
        QuickAction(
          id: 'ibadah',
          title: 'Ibadah Hub',
          icon: Icons.mosque,
          onTap: () {},
        ),
        QuickAction(
          id: 'skills',
          title: 'Skills Hub',
          icon: Icons.computer,
          onTap: () {},
        ),
        QuickAction(
          id: 'reflection',
          title: 'Reflection',
          icon: Icons.self_improvement,
          onTap: () {},
        ),
      ];

      emit(
        EnhancedDashboardLoaded(
          userName: 'Muslim Developer',
          todaysOverview: todaysOverview,
          taskProgress: taskProgress,
          upcomingReminders: upcomingReminders,
          motivationalSnippet: motivationalSnippet,
          quickActions: quickActions,
        ),
      );
    } catch (e) {
      emit(EnhancedDashboardError(e.toString()));
    }
  }

  /// Handle updating user name
  Future<void> _onUpdateUserName(
    UpdateUserNameEvent event,
    Emitter<EnhancedDashboardState> emit,
  ) async {
    if (state is EnhancedDashboardLoaded) {
      final currentState = state as EnhancedDashboardLoaded;
      emit(currentState.copyWith(userName: event.name));
    }
  }

  /// Handle toggling card visibility
  Future<void> _onToggleCardVisibility(
    ToggleCardVisibilityEvent event,
    Emitter<EnhancedDashboardState> emit,
  ) async {
    // Implementation would update card visibility in repository
  }

  /// Handle reordering cards
  Future<void> _onReorderCards(
    ReorderCardsEvent event,
    Emitter<EnhancedDashboardState> emit,
  ) async {
    // Implementation would update card order in repository
  }
}