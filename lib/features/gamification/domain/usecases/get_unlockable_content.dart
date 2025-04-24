import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/unlockable_content.dart';
import '../repositories/unlockable_content_repository.dart';

/// Use case to get all unlockable content
class GetUnlockableContent implements UseCase<List<UnlockableContent>, NoParams> {
  final UnlockableContentRepository repository;

  /// Creates a new GetUnlockableContent use case
  GetUnlockableContent(this.repository);

  @override
  Future<Either<Failure, List<UnlockableContent>>> call(NoParams params) {
    return repository.getAllContent();
  }
}
