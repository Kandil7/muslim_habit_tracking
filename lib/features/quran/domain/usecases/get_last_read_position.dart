import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/reading_history.dart';
import '../repositories/quran_repository.dart';

/// Use case to get the last read position
class GetLastReadPosition implements UseCase<QuranReadingHistory?, NoParams> {
  final QuranRepository repository;

  GetLastReadPosition(this.repository);

  @override
  Future<Either<Failure, QuranReadingHistory?>> call(NoParams params) async {
    return await repository.getLastReadPosition();
  }
}
