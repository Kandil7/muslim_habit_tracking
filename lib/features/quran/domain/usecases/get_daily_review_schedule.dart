import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/review_schedule.dart';
import '../repositories/memorization_repository.dart';

/// Use case to get the daily review schedule
class GetDailyReviewSchedule {
  final MemorizationRepository repository;

  GetDailyReviewSchedule(this.repository);

  /// Get the daily review schedule
  Future<Either<Failure, ReviewSchedule>> call() async {
    return await repository.getDailyReviewSchedule();
  }
}