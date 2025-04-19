import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/quran_bookmark.dart';
import '../repositories/quran_repository.dart';

/// Use case to get all Quran bookmarks
class GetAllBookmarks implements UseCase<List<QuranBookmark>, NoParams> {
  final QuranRepository repository;

  GetAllBookmarks(this.repository);

  @override
  Future<Either<Failure, List<QuranBookmark>>> call(NoParams params) {
    return repository.getAllBookmarks();
  }
}
