import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/quran_bookmark.dart';
import '../repositories/quran_bookmark_repository.dart';

/// Parameters for updating a bookmark
class UpdateBookmarkParams {
  /// Bookmark to update
  final QuranBookmark bookmark;

  /// Constructor
  const UpdateBookmarkParams({required this.bookmark});
}

/// Use case for updating a bookmark
class UpdateBookmark implements UseCase<QuranBookmark, UpdateBookmarkParams> {
  /// Repository instance
  final QuranBookmarkRepository repository;

  /// Constructor
  const UpdateBookmark(this.repository);

  @override
  Future<Either<Failure, QuranBookmark>> call(UpdateBookmarkParams params) async {
    return await repository.updateBookmark(params.bookmark);
  }
}
