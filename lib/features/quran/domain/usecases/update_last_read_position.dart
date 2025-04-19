import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/quran_reading_history.dart';
import '../repositories/quran_repository.dart';

/// Use case to update the last read position in the Quran
class UpdateLastReadPosition implements UseCase<QuranReadingHistory, UpdateLastReadPositionParams> {
  final QuranRepository repository;

  UpdateLastReadPosition(this.repository);

  @override
  Future<Either<Failure, QuranReadingHistory>> call(UpdateLastReadPositionParams params) {
    return repository.updateLastReadPosition(params.history);
  }
}

/// Parameters for the UpdateLastReadPosition use case
class UpdateLastReadPositionParams extends Equatable {
  final QuranReadingHistory history;

  const UpdateLastReadPositionParams({required this.history});

  @override
  List<Object> get props => [history];
}
