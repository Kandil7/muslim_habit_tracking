import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/unlockable_content.dart';
import '../repositories/unlockable_content_repository.dart';

/// Use case to unlock content
class UnlockContent implements UseCase<UnlockableContent, UnlockContentParams> {
  final UnlockableContentRepository repository;

  /// Creates a new UnlockContent use case
  UnlockContent(this.repository);

  @override
  Future<Either<Failure, UnlockableContent>> call(UnlockContentParams params) {
    return repository.unlockContent(params.contentId);
  }
}

/// Parameters for UnlockContent use case
class UnlockContentParams extends Equatable {
  final String contentId;

  /// Creates new UnlockContentParams
  const UnlockContentParams({required this.contentId});

  @override
  List<Object> get props => [contentId];
}
