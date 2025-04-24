import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/badge.dart';
import '../repositories/badge_repository.dart';

/// Use case to get earned badges
class GetEarnedBadges implements UseCase<List<Badge>, NoParams> {
  final BadgeRepository repository;

  /// Creates a new GetEarnedBadges use case
  GetEarnedBadges(this.repository);

  @override
  Future<Either<Failure, List<Badge>>> call(NoParams params) {
    return repository.getEarnedBadges();
  }
}
