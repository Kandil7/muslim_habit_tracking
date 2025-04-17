import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/bookmark.dart';
import '../repositories/quran_repository.dart';

/// Use case to get all bookmarks
class GetBookmarks implements UseCase<List<QuranBookmark>, NoParams> {
  final QuranRepository repository;

  GetBookmarks(this.repository);

  @override
  Future<Either<Failure, List<QuranBookmark>>> call(NoParams params) async {
    return await repository.getBookmarks();
  }
}
