import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_habit_stats.dart';
import '../../domain/usecases/get_habit_stats_by_date_range.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

/// BLoC for the analytics feature
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetHabitStats getHabitStats;
  final GetHabitStatsByDateRange getHabitStatsByDateRange;
  
  AnalyticsBloc({
    required this.getHabitStats,
    required this.getHabitStatsByDateRange,
  }) : super(AnalyticsInitial()) {
    on<GetHabitStatsEvent>(_onGetHabitStats);
    on<GetHabitStatsByDateRangeEvent>(_onGetHabitStatsByDateRange);
  }
  
  /// Handle GetHabitStatsEvent
  Future<void> _onGetHabitStats(
    GetHabitStatsEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());
    
    final result = await getHabitStats(
      GetHabitStatsParams(habitId: event.habitId),
    );
    
    result.fold(
      (failure) => emit(AnalyticsError(message: failure.message)),
      (habitStats) => emit(HabitStatsLoaded(habitStats: habitStats)),
    );
  }
  
  /// Handle GetHabitStatsByDateRangeEvent
  Future<void> _onGetHabitStatsByDateRange(
    GetHabitStatsByDateRangeEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());
    
    final result = await getHabitStatsByDateRange(
      GetHabitStatsByDateRangeParams(
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );
    
    result.fold(
      (failure) => emit(AnalyticsError(message: failure.message)),
      (habitStats) => emit(HabitStatsByDateRangeLoaded(
        habitStats: habitStats,
        startDate: event.startDate,
        endDate: event.endDate,
      )),
    );
  }
}
