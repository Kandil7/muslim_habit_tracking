import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/hadith.dart';

/// Repository interface for Hadith feature
abstract class HadithRepository {
  /// Get a list of all hadiths
  Future<Either<Failure, List<Hadith>>> getAllHadiths();

  /// Get a hadith by its ID
  Future<Either<Failure, Hadith>> getHadithById(String id);

  /// Get the hadith of the day
  Future<Either<Failure, Hadith>> getHadithOfTheDay();

  /// Get hadiths by source (e.g., Bukhari, Muslim)
  Future<Either<Failure, List<Hadith>>> getHadithsBySource(String source);

  /// Get hadiths by tag or category
  Future<Either<Failure, List<Hadith>>> getHadithsByTag(String tag);

  /// Get bookmarked hadiths
  Future<Either<Failure, List<Hadith>>> getBookmarkedHadiths();

  /// Toggle bookmark status for a hadith
  Future<Either<Failure, Hadith>> toggleHadithBookmark(String id);
}
