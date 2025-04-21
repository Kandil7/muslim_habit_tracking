import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_log.dart';
import '../../domain/usecases/create_habit.dart';
import '../../domain/usecases/create_habit_log.dart';
import '../../domain/usecases/delete_habit.dart';
import '../../domain/usecases/get_habit_logs_by_date_range.dart';
import '../../domain/usecases/get_habits.dart';
import '../../domain/usecases/update_habit.dart';
import '../../domain/utils/streak_calculator.dart';
import 'habit_event.dart';
import 'habit_state.dart';

/// BLoC for the habit feature
class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final GetHabits getHabits;
  final CreateHabit createHabit;
  final UpdateHabit updateHabit;
  final DeleteHabit deleteHabit;
  final GetHabitLogsByDateRange getHabitLogsByDateRange;
  final CreateHabitLog createHabitLog;

  HabitBloc({
    required this.getHabits,
    required this.createHabit,
    required this.updateHabit,
    required this.deleteHabit,
    required this.getHabitLogsByDateRange,
    required this.createHabitLog,
  }) : super(HabitInitial()) {
    on<GetHabitsEvent>(_onGetHabits);
    on<CreateHabitEvent>(_onCreateHabit);
    on<UpdateHabitEvent>(_onUpdateHabit);
    on<DeleteHabitEvent>(_onDeleteHabit);
    on<GetHabitLogsByDateRangeEvent>(_onGetHabitLogsByDateRange);
    on<CreateHabitLogEvent>(_onCreateHabitLog);
    on<UpdateStreakEvent>(_onUpdateStreak);
    on<CheckStreaksEvent>(_onCheckStreaks);
  }

  /// Handle GetHabitsEvent
  Future<void> _onGetHabits(
    GetHabitsEvent event,
    Emitter<HabitState> emit,
  ) async {
    emit(HabitLoading());

    final result = await getHabits();

    result.fold(
      (failure) => emit(HabitError(message: failure.toString())),
      (habits) => emit(HabitsLoaded(habits: habits)),
    );
  }

  /// Handle CreateHabitEvent
  Future<void> _onCreateHabit(
    CreateHabitEvent event,
    Emitter<HabitState> emit,
  ) async {
    emit(HabitLoading());

    final result = await createHabit(CreateHabitParams(habit: event.habit));

    result.fold(
      (failure) => emit(HabitError(message: failure.toString())),
      (habit) => emit(HabitCreated(habit: habit)),
    );
  }

  /// Handle UpdateHabitEvent
  Future<void> _onUpdateHabit(
    UpdateHabitEvent event,
    Emitter<HabitState> emit,
  ) async {
    emit(HabitLoading());

    final result = await updateHabit(UpdateHabitParams(habit: event.habit));

    result.fold(
      (failure) => emit(HabitError(message: failure.toString())),
      (habit) => emit(HabitUpdated(habit: habit)),
    );
  }

  /// Handle DeleteHabitEvent
  Future<void> _onDeleteHabit(
    DeleteHabitEvent event,
    Emitter<HabitState> emit,
  ) async {
    emit(HabitLoading());

    final result = await deleteHabit(DeleteHabitParams(id: event.id));

    result.fold(
      (failure) => emit(HabitError(message: failure.toString())),
      (_) => emit(HabitDeleted()),
    );
  }

  /// Handle GetHabitLogsByDateRangeEvent
  Future<void> _onGetHabitLogsByDateRange(
    GetHabitLogsByDateRangeEvent event,
    Emitter<HabitState> emit,
  ) async {
    emit(HabitLoading());

    final result = await getHabitLogsByDateRange(
      GetHabitLogsByDateRangeParams(
        habitId: event.habitId,
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );

    result.fold(
      (failure) => emit(HabitError(message: failure.toString())),
      (habitLogs) => emit(HabitLogsLoaded(habitLogs: habitLogs)),
    );
  }

  /// Handle CreateHabitLogEvent
  Future<void> _onCreateHabitLog(
    CreateHabitLogEvent event,
    Emitter<HabitState> emit,
  ) async {
    emit(HabitLoading());

    final result = await createHabitLog(
      CreateHabitLogParams(habitLog: event.habitLog),
    );

    result.fold((failure) => emit(HabitError(message: failure.toString())), (
      habitLog,
    ) {
      // After creating a log, update the streak information
      add(UpdateStreakEvent(habitId: habitLog.habitId, logDate: habitLog.date));
      emit(HabitLogCreated(habitLog: habitLog));
    });
  }

  /// Handle UpdateStreakEvent
  Future<void> _onUpdateStreak(
    UpdateStreakEvent event,
    Emitter<HabitState> emit,
  ) async {
    // Get the habit
    final habitResult = await getHabits();

    await habitResult.fold(
      (failure) async {
        emit(HabitError(message: failure.toString()));
      },
      (habits) async {
        // Find the habit by ID
        final habit = habits.firstWhere(
          (h) => h.id == event.habitId,
          orElse: () => throw Exception('Habit not found'),
        );

        // Get all logs for this habit
        final logsResult = await getHabitLogsByDateRange(
          GetHabitLogsByDateRangeParams(
            habitId: event.habitId,
            startDate: DateTime(2000), // Far in the past
            endDate: DateTime.now().add(
              const Duration(days: 1),
            ), // Include today
          ),
        );

        await logsResult.fold(
          (failure) async {
            emit(HabitError(message: failure.toString()));
          },
          (logs) async {
            // Update streak information
            final updatedHabit = StreakCalculator.updateStreakInfo(
              habit,
              logs,
              event.logDate,
            );

            // Save the updated habit
            final updateResult = await updateHabit(
              UpdateHabitParams(habit: updatedHabit),
            );

            updateResult.fold(
              (failure) => emit(HabitError(message: failure.toString())),
              (updatedHabit) => emit(HabitUpdated(habit: updatedHabit)),
            );
          },
        );
      },
    );
  }

  /// Handle CheckStreaksEvent
  Future<void> _onCheckStreaks(
    CheckStreaksEvent event,
    Emitter<HabitState> emit,
  ) async {
    // Get all habits
    final habitsResult = await getHabits();

    await habitsResult.fold(
      (failure) async {
        emit(HabitError(message: failure.toString()));
      },
      (habits) async {
        // Check each habit for broken streaks
        for (final habit in habits) {
          if (StreakCalculator.isStreakBroken(habit)) {
            // Reset the streak
            final updatedHabit = StreakCalculator.resetBrokenStreak(habit);

            // Save the updated habit
            await updateHabit(UpdateHabitParams(habit: updatedHabit));
          }
        }

        // Reload habits after updates
        add(GetHabitsEvent());
      },
    );
  }
}
