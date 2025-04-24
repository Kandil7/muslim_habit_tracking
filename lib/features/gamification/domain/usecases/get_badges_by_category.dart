import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/badge.dart';
import '../repositories/badge_repository.dart';

/// Use case to get badges by category
class GetBadgesByCategory implements UseCase<List<Badge>, GetBadgesByCategoryParams> {
  final BadgeRepository repository;

  /// Creates a new GetBadgesByCategory use case
  GetBadgesByCategory(this.repository);

  @override
  Future<Either<Failure, List<Badge>>> call(GetBadgesByCategoryParams params) {
    return repository.getBadgesByCategory(params.category);
  }
}

/// Parameters for GetBadgesByCategory use case
class GetBadgesByCategoryParams extends Equatable {
  final String category;

  /// Creates new GetBadgesByCategoryParams
  const GetBadgesByCategoryParams({required this.category});

  @override
  List<Object> get props => [category];
}
