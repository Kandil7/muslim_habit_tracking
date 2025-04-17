import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/reading_history.dart';
import '../repositories/quran_repository.dart';

/// Use case to update the last read position
class UpdateLastReadPosition implements UseCase<bool, LastReadPositionParams> {
  final QuranRepository repository;

  UpdateLastReadPosition(this.repository);

  @override
  Future<Either<Failure, bool>> call(LastReadPositionParams params) async {
    return await repository.updateLastReadPosition(params.history);
  }
}

/// Parameters for the UpdateLastReadPosition use case
class LastReadPositionParams extends Equatable {
  final QuranReadingHistory history;

  const LastReadPositionParams({required this.history});

  @override
  List<Object?> get props => [history];
}
