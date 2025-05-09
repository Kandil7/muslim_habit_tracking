import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/export_analytics_data_usecase.dart';
import '../../domain/usecases/get_all_habit_stats.dart';
import '../../domain/usecases/get_habit_stats.dart';
import '../../domain/usecases/get_habit_stats_by_date_range.dart';
import '../../domain/usecases/get_least_consistent_habit.dart';
import '../../domain/usecases/get_most_consistent_habit.dart';
import '../../domain/usecases/get_overall_completion_rate.dart';
import '../../domain/usecases/set_habit_goal.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

/// BLoC for the Analytics feature
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetAllHabitStats getAllHabitStats;
  final GetHabitStats getHabitStats;
  final GetHabitStatsByDateRange getHabitStatsByDateRange;
  final GetOverallCompletionRate getOverallCompletionRate;
  final GetMostConsistentHabit getMostConsistentHabit;
  final GetLeastConsistentHabit getLeastConsistentHabit;
  final ExportAnalyticsData exportAnalyticsData;
  final SetHabitGoal setHabitGoal;

  AnalyticsBloc({
    required this.getAllHabitStats,
    required this.getHabitStats,
    required this.getHabitStatsByDateRange,
    required this.getOverallCompletionRate,
    required this.getMostConsistentHabit,
    required this.getLeastConsistentHabit,
    required this.exportAnalyticsData,
    required this.setHabitGoal,
  }) : super(AnalyticsInitial()) {
    on<GetAllHabitStatsEvent>(_onGetAllHabitStats);
    on<GetHabitStatsEvent>(_onGetHabitStats);
    on<GetHabitStatsByDateRangeEvent>(_onGetHabitStatsByDateRange);
    on<GetOverallCompletionRateEvent>(_onGetOverallCompletionRate);
    on<GetMostConsistentHabitEvent>(_onGetMostConsistentHabit);
    on<GetLeastConsistentHabitEvent>(_onGetLeastConsistentHabit);
    on<ExportAnalyticsDataEvent>(_onExportAnalyticsData);
    on<SetHabitGoalEvent>(_onSetHabitGoal);
  }

  /// Handle GetAllHabitStatsEvent
  Future<void> _onGetAllHabitStats(
    GetAllHabitStatsEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());

    final result = await getAllHabitStats(NoParams());

    result.fold(
      (failure) => emit(AnalyticsError(message: failure.message)),
      (habitStats) => emit(AllHabitStatsLoaded(habitStats: habitStats)),
    );
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
      (habitStats) => emit(HabitStatsByDateRangeLoaded(habitStats: habitStats)),
    );
  }

  /// Handle GetOverallCompletionRateEvent
  Future<void> _onGetOverallCompletionRate(
    GetOverallCompletionRateEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());

    final result = await getOverallCompletionRate(NoParams());

    result.fold(
      (failure) => emit(AnalyticsError(message: failure.message)),
      (completionRate) =>
          emit(OverallCompletionRateLoaded(completionRate: completionRate)),
    );
  }

  /// Handle GetMostConsistentHabitEvent
  Future<void> _onGetMostConsistentHabit(
    GetMostConsistentHabitEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());

    final result = await getMostConsistentHabit(NoParams());

    result.fold(
      (failure) => emit(AnalyticsError(message: failure.message)),
      (habitStats) => emit(MostConsistentHabitLoaded(habitStats: habitStats)),
    );
  }

  /// Handle GetLeastConsistentHabitEvent
  Future<void> _onGetLeastConsistentHabit(
    GetLeastConsistentHabitEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());

    final result = await getLeastConsistentHabit(NoParams());

    result.fold(
      (failure) => emit(AnalyticsError(message: failure.message)),
      (habitStats) => emit(LeastConsistentHabitLoaded(habitStats: habitStats)),
    );
  }

  /// Handle ExportAnalyticsDataEvent
  Future<void> _onExportAnalyticsData(
    ExportAnalyticsDataEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());

    final result = await exportAnalyticsData(
      ExportAnalyticsDataParams(format: event.format),
    );

    result.fold(
      (failure) => emit(AnalyticsError(message: failure.message)),
      (filePath) =>
          emit(AnalyticsDataExported(filePath: filePath, format: event.format)),
    );
  }

  /// Handle SetHabitGoalEvent
  Future<void> _onSetHabitGoal(
    SetHabitGoalEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());

    final result = await setHabitGoal(
      SetHabitGoalParams(
        habitId: event.habitId,
        targetStreak: event.targetStreak,
        targetCompletionRate: event.targetCompletionRate,
      ),
    );

    result.fold(
      (failure) => emit(AnalyticsError(message: failure.message)),
      (_) => emit(
        HabitGoalSet(
          habitId: event.habitId,
          targetStreak: event.targetStreak,
          targetCompletionRate: event.targetCompletionRate,
        ),
      ),
    );
  }
}
