import 'package:muslim_habbit/features/self_development_hub/domain/entities/habit.dart';
import 'package:muslim_habbit/features/self_development_hub/domain/repositories/habit_repository.dart';

/// Use case to get active habits
class GetActiveHabits {
  final HabitRepository repository;

  GetActiveHabits(this.repository);

  /// Get all active habits
  Future<List<Habit>> call() async {
    return await repository.getActiveHabits();
  }
}