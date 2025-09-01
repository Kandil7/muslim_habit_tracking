import 'package:muslim_habbit/features/skills_hub/domain/entities/programming_activity.dart';
import 'package:muslim_habbit/features/skills_hub/domain/repositories/programming_activity_repository.dart';

/// Use case to get today's programming activities
class GetTodaysActivities {
  final ProgrammingActivityRepository repository;

  GetTodaysActivities(this.repository);

  /// Get all programming activities for today
  Future<List<ProgrammingActivity>> call() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return await repository.getActivitiesForDateRange(startOfDay, endOfDay);
  }
}