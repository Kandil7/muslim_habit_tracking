import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/memorization_item.dart';
import '../../domain/entities/memorization_preferences.dart';
import '../../domain/entities/review_schedule.dart';
import '../../domain/entities/streak_statistics.dart' as streak_entity;
import '../../domain/entities/progress_statistics.dart' as progress_entity;
import '../../domain/repositories/memorization_repository.dart' as domain;
import '../datasources/memorization_local_data_source.dart';
import '../models/memorization_item_model.dart';
import '../models/memorization_preferences_model.dart';

/// Implementation of MemorizationRepository
class MemorizationRepositoryImpl implements domain.MemorizationRepository {
  final MemorizationLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  MemorizationRepositoryImpl({
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<MemorizationItem>>> getMemorizationItems() async {
    try {
      final items = await localDataSource.getMemorizationItems();
      return Right(items);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, MemorizationItem>> getMemorizationItemById(
      String id) async {
    try {
      final item = await localDataSource.getMemorizationItemById(id);
      return Right(item);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, MemorizationItem>> createMemorizationItem(
      MemorizationItem item) async {
    try {
      final itemModel = MemorizationItemModel.fromEntity(item);
      final createdItem = await localDataSource.createMemorizationItem(itemModel);
      return Right(createdItem);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, MemorizationItem>> updateMemorizationItem(
      MemorizationItem item) async {
    try {
      final itemModel = MemorizationItemModel.fromEntity(item);
      final updatedItem = await localDataSource.updateMemorizationItem(itemModel);
      return Right(updatedItem);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMemorizationItem(String id) async {
    try {
      await localDataSource.deleteMemorizationItem(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ReviewSchedule>> getDailyReviewSchedule() async {
    try {
      final items = await localDataSource.getMemorizationItems();
      final preferences = await localDataSource.getPreferences();
      
      // Filter items that need to be reviewed today
      final today = DateTime.now();
      final todayItems = <MemorizationItem>[];
      
      for (final item in items) {
        // Always include in-progress items (they need daily review)
        if (item.status == MemorizationStatus.inProgress) {
          todayItems.add(item);
        }
        // For memorized items, check if they're due for review based on the cycle
        else if (item.status == MemorizationStatus.memorized) {
          if (item.isDueForReview(preferences.reviewPeriod)) {
            todayItems.add(item);
          }
        }
      }
      
      // Sort items: in-progress items first (oldest first), then memorized items
      todayItems.sort((a, b) {
        // If both are in-progress, sort by date added (oldest first)
        if (a.status == MemorizationStatus.inProgress && 
            b.status == MemorizationStatus.inProgress) {
          return a.dateAdded.compareTo(b.dateAdded);
        }
        
        // In-progress items come before memorized items
        if (a.status == MemorizationStatus.inProgress) return -1;
        if (b.status == MemorizationStatus.inProgress) return 1;
        
        // If both are memorized, sort by surah number based on direction
        if (a.status == MemorizationStatus.memorized && 
            b.status == MemorizationStatus.memorized) {
          if (preferences.memorizationDirection == MemorizationDirection.fromBaqarah) {
            return a.surahNumber.compareTo(b.surahNumber);
          } else {
            return b.surahNumber.compareTo(a.surahNumber);
          }
        }
        
        return 0;
      });
      
      return Right(ReviewSchedule(
        reviewPeriodDays: preferences.reviewPeriod,
        dailyItems: todayItems,
      ));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, MemorizationItem>> markItemAsReviewed(String itemId) async {
    try {
      final updatedItem = await localDataSource.markItemAsReviewed(itemId);
      return Right(updatedItem);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, MemorizationPreferences>> getPreferences() async {
    try {
      final preferences = await localDataSource.getPreferences();
      return Right(preferences);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, MemorizationPreferences>> updatePreferences(
      MemorizationPreferences preferences) async {
    try {
      final preferencesModel = MemorizationPreferencesModel.fromEntity(preferences);
      final updatedPreferences = await localDataSource.updatePreferences(preferencesModel);
      return Right(updatedPreferences);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, domain.MemorizationStatistics>> getMemorizationStatistics() async {
    try {
      final statistics = await localDataSource.getMemorizationStatistics();
      return Right(statistics);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, domain.DetailedMemorizationStatistics>> getDetailedStatistics() async {
    try {
      final detailedStats = await localDataSource.getDetailedStatistics();
      return Right(detailedStats);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<MemorizationItem>>> getItemsByStatus(MemorizationStatus status) async {
    try {
      final items = await localDataSource.getItemsByStatus(status);
      return Right(items);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, MemorizationItem>> archiveItem(String itemId) async {
    try {
      final item = await localDataSource.archiveItem(itemId);
      return Right(item);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, MemorizationItem>> unarchiveItem(String itemId) async {
    try {
      final item = await localDataSource.unarchiveItem(itemId);
      return Right(item);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<MemorizationItem>>> getOverdueItems() async {
    try {
      final items = await localDataSource.getOverdueItems();
      return Right(items);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, MemorizationItem>> resetItemProgress(String itemId) async {
    try {
      final item = await localDataSource.resetItemProgress(itemId);
      return Right(item);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<MemorizationItem>>> getItemsNeedingReview() async {
    try {
      final items = await localDataSource.getItemsNeedingReview();
      return Right(items);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<DateTime>>> getItemReviewHistory(String itemId) async {
    try {
      final reviewHistory = await localDataSource.getItemReviewHistory(itemId);
      return Right(reviewHistory);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<MemorizationItem>>> getItemsBySurah(int surahNumber) async {
    try {
      final items = await localDataSource.getItemsBySurah(surahNumber);
      return Right(items);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<MemorizationItem>>> getItemsByDateRange(DateTime start, DateTime end) async {
    try {
      final items = await localDataSource.getItemsByDateRange(start, end);
      return Right(items);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, domain.StreakStatistics>> getStreakStatistics() async {
    try {
      final streakStats = await localDataSource.getStreakStatistics();
      return Right(streakStats);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, domain.ProgressStatistics>> getProgressStatistics(DateTime start, DateTime end) async {
    try {
      final progressStats = await localDataSource.getProgressStatistics(start, end);
      return Right(progressStats);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}