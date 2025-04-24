import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/badge.dart';
import '../repositories/badge_repository.dart';

/// Use case to get all badges
class GetAllBadges implements UseCase<List<Badge>, NoParams> {
  final BadgeRepository repository;

  /// Creates a new GetAllBadges use case
  GetAllBadges(this.repository);

  @override
  Future<Either<Failure, List<Badge>>> call(NoParams params) {
    return repository.getAllBadges();
  }
}
