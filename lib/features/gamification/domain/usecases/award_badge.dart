import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/badge.dart';
import '../repositories/badge_repository.dart';

/// Use case to award a badge
class AwardBadge implements UseCase<Badge, AwardBadgeParams> {
  final BadgeRepository repository;

  /// Creates a new AwardBadge use case
  AwardBadge(this.repository);

  @override
  Future<Either<Failure, Badge>> call(AwardBadgeParams params) {
    return repository.awardBadge(params.badgeId);
  }
}

/// Parameters for AwardBadge use case
class AwardBadgeParams extends Equatable {
  final String badgeId;

  /// Creates new AwardBadgeParams
  const AwardBadgeParams({required this.badgeId});

  @override
  List<Object> get props => [badgeId];
}
