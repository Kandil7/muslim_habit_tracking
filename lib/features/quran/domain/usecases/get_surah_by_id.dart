import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/quran.dart';
import '../repositories/quran_repository.dart';

/// Use case to get a surah by its ID
class GetSurahById implements UseCase<Quran, SurahParams> {
  final QuranRepository repository;

  GetSurahById(this.repository);

  @override
  Future<Either<Failure, Quran>> call(SurahParams params) async {
    return await repository.getSurahById(params.id);
  }
}

/// Parameters for the GetSurahById use case
class SurahParams extends Equatable {
  final int id;

  const SurahParams({required this.id});

  @override
  List<Object?> get props => [id];
}
