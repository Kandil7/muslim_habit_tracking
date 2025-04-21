import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/quran_bookmark.dart';
import '../repositories/quran_bookmark_repository.dart';

/// Use case for getting all bookmarks
class GetAllBookmarks implements UseCase<List<QuranBookmark>, NoParams> {
  /// Repository instance
  final QuranBookmarkRepository repository;

  /// Constructor
  const GetAllBookmarks(this.repository);

  @override
  Future<Either<Failure, List<QuranBookmark>>> call(NoParams params) async {
    return await repository.getAllBookmarks();
  }
}
