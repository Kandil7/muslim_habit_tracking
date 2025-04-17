import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/hadith.dart';
import '../repositories/hadith_repository.dart';

/// Use case to get a hadith by its ID
class GetHadithById implements UseCase<Hadith, HadithParams> {
  final HadithRepository repository;

  /// Creates a new GetHadithById use case
  GetHadithById(this.repository);

  @override
  Future<Either<Failure, Hadith>> call(HadithParams params) {
    return repository.getHadithById(params.id);
  }
}

/// Parameters for the GetHadithById use case
class HadithParams extends Equatable {
  /// The ID of the hadith to retrieve
  final String id;

  /// Creates a new HadithParams instance
  const HadithParams({required this.id});

  @override
  List<Object?> get props => [id];
}
