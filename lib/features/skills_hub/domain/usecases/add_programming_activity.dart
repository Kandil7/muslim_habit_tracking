import 'package:muslim_habbit/features/skills_hub/domain/entities/programming_activity.dart';
import 'package:muslim_habbit/features/skills_hub/domain/repositories/programming_activity_repository.dart';

/// Use case to add a new programming activity
class AddProgrammingActivity {
  final ProgrammingActivityRepository repository;

  AddProgrammingActivity(this.repository);

  /// Add a new programming activity
  Future<ProgrammingActivity> call(ProgrammingActivity activity) async {
    return await repository.addActivity(activity);
  }
}