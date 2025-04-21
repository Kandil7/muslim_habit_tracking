import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/quran_bookmark.dart';
import '../repositories/quran_bookmark_repository.dart';

/// Parameters for adding a bookmark
class AddBookmarkParams {
  /// Bookmark to add
  final QuranBookmark bookmark;

  /// Constructor
  const AddBookmarkParams({required this.bookmark});
}

/// Use case for adding a bookmark
class AddBookmark implements UseCase<QuranBookmark, AddBookmarkParams> {
  /// Repository instance
  final QuranBookmarkRepository repository;

  /// Constructor
  const AddBookmark(this.repository);

  @override
  Future<Either<Failure, QuranBookmark>> call(AddBookmarkParams params) async {
    return await repository.addBookmark(params.bookmark);
  }
}
