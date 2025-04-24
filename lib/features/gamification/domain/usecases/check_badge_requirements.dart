import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/badge_repository.dart';

/// Use case to check if a badge should be awarded
class CheckBadgeRequirements implements UseCase<bool, CheckBadgeRequirementsParams> {
  final BadgeRepository repository;

  /// Creates a new CheckBadgeRequirements use case
  CheckBadgeRequirements(this.repository);

  @override
  Future<Either<Failure, bool>> call(CheckBadgeRequirementsParams params) {
    return repository.checkBadgeRequirements(params.badgeId, params.userStats);
  }
}

/// Parameters for CheckBadgeRequirements use case
class CheckBadgeRequirementsParams extends Equatable {
  final String badgeId;
  final Map<String, dynamic> userStats;

  /// Creates new CheckBadgeRequirementsParams
  const CheckBadgeRequirementsParams({
    required this.badgeId,
    required this.userStats,
  });

  @override
  List<Object> get props => [badgeId, userStats];
}
