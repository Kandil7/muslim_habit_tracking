import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../models/bookmark_model.dart';
import '../models/quran_model.dart';
import '../models/reading_history_model.dart';

/// Interface for Quran local data source
abstract class QuranLocalDataSource {
  /// Get all surahs
  Future<List<QuranModel>> getAllSurahs();
  
  /// Get surah by ID
  Future<QuranModel> getSurahById(int id);
  
  /// Get bookmarks
  Future<List<QuranBookmarkModel>> getBookmarks();
  
  /// Add bookmark
  Future<QuranBookmarkModel> addBookmark(QuranBookmarkModel bookmark);
  
  /// Remove bookmark
  Future<bool> removeBookmark(String bookmarkId);
  
  /// Get reading history
  Future<List<QuranReadingHistoryModel>> getReadingHistory();
  
  /// Add reading history
  Future<QuranReadingHistoryModel> addReadingHistory(QuranReadingHistoryModel history);
  
  /// Clear reading history
  Future<bool> clearReadingHistory();
  
  /// Get last read position
  Future<QuranReadingHistoryModel?> getLastReadPosition();
  
  /// Update last read position
  Future<bool> updateLastReadPosition(QuranReadingHistoryModel history);
  
  /// Initialize with sample data if needed
  Future<void> initializeWithSampleData();
}

/// Implementation of QuranLocalDataSource
class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  final Box quranBox;
  final Uuid uuid;
  
  QuranLocalDataSourceImpl({
    required this.quranBox,
    required this.uuid,
  });
  
  @override
  Future<List<QuranModel>> getAllSurahs() async {
    try {
      final List<QuranModel> surahs = [];
      
      // Convert the Constants.quranList to QuranModel objects
      for (int i = 0; i < Constants.quranList.length; i++) {
        final surah = Constants.quranList[i];
        surahs.add(
          QuranModel(
            id: i + 1,
            name: surah['enName'],
            arabicName: surah['arName'],
            englishName: surah['enName'],
            revelationType: surah['enType'],
            numberOfAyahs: surah['verses'],
            startPage: surah['start'],
            isBookmarked: false,
          ),
        );
      }
      
      return surahs;
    } catch (e) {
      throw CacheException(message: 'Failed to get surahs: ${e.toString()}');
    }
  }
  
  @override
  Future<QuranModel> getSurahById(int id) async {
    try {
      if (id < 1 || id > Constants.quranList.length) {
        throw CacheException(message: 'Surah ID out of range');
      }
      
      final surah = Constants.quranList[id - 1];
      return QuranModel(
        id: id,
        name: surah['enName'],
        arabicName: surah['arName'],
        englishName: surah['enName'],
        revelationType: surah['enType'],
        numberOfAyahs: surah['verses'],
        startPage: surah['start'],
        isBookmarked: false,
      );
    } catch (e) {
      throw CacheException(message: 'Failed to get surah: ${e.toString()}');
    }
  }
  
  @override
  Future<List<QuranBookmarkModel>> getBookmarks() async {
    try {
      final bookmarksJson = quranBox.get('bookmarks');
      if (bookmarksJson == null) {
        return [];
      }
      
      final List<dynamic> bookmarksList = jsonDecode(bookmarksJson);
      return bookmarksList
          .map((bookmark) => QuranBookmarkModel.fromJson(bookmark))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get bookmarks: ${e.toString()}');
    }
  }
  
  @override
  Future<QuranBookmarkModel> addBookmark(QuranBookmarkModel bookmark) async {
    try {
      final bookmarks = await getBookmarks();
      
      // Create a new bookmark with a UUID if not provided
      final newBookmark = bookmark.id.isEmpty
          ? QuranBookmarkModel(
              id: uuid.v4(),
              surahId: bookmark.surahId,
              ayahNumber: bookmark.ayahNumber,
              page: bookmark.page,
              surahName: bookmark.surahName,
              arabicSurahName: bookmark.arabicSurahName,
              timestamp: bookmark.timestamp,
              note: bookmark.note,
            )
          : bookmark;
      
      bookmarks.add(newBookmark);
      
      // Save the updated bookmarks list
      await quranBox.put(
        'bookmarks',
        jsonEncode(bookmarks.map((b) => b.toJson()).toList()),
      );
      
      return newBookmark;
    } catch (e) {
      throw CacheException(message: 'Failed to add bookmark: ${e.toString()}');
    }
  }
  
  @override
  Future<bool> removeBookmark(String bookmarkId) async {
    try {
      final bookmarks = await getBookmarks();
      final filteredBookmarks = bookmarks.where((b) => b.id != bookmarkId).toList();
      
      if (bookmarks.length == filteredBookmarks.length) {
        // Bookmark not found
        return false;
      }
      
      // Save the updated bookmarks list
      await quranBox.put(
        'bookmarks',
        jsonEncode(filteredBookmarks.map((b) => b.toJson()).toList()),
      );
      
      return true;
    } catch (e) {
      throw CacheException(message: 'Failed to remove bookmark: ${e.toString()}');
    }
  }
  
  @override
  Future<List<QuranReadingHistoryModel>> getReadingHistory() async {
    try {
      final historyJson = quranBox.get('reading_history');
      if (historyJson == null) {
        return [];
      }
      
      final List<dynamic> historyList = jsonDecode(historyJson);
      return historyList
          .map((history) => QuranReadingHistoryModel.fromJson(history))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get reading history: ${e.toString()}');
    }
  }
  
  @override
  Future<QuranReadingHistoryModel> addReadingHistory(QuranReadingHistoryModel history) async {
    try {
      final readingHistory = await getReadingHistory();
      
      // Create a new history entry with a UUID if not provided
      final newHistory = history.id.isEmpty
          ? QuranReadingHistoryModel(
              id: uuid.v4(),
              surahId: history.surahId,
              ayahNumber: history.ayahNumber,
              page: history.page,
              surahName: history.surahName,
              arabicSurahName: history.arabicSurahName,
              timestamp: history.timestamp,
            )
          : history;
      
      // Add to the beginning of the list (most recent first)
      readingHistory.insert(0, newHistory);
      
      // Limit the history to the most recent 50 entries
      final limitedHistory = readingHistory.take(50).toList();
      
      // Save the updated reading history
      await quranBox.put(
        'reading_history',
        jsonEncode(limitedHistory.map((h) => h.toJson()).toList()),
      );
      
      return newHistory;
    } catch (e) {
      throw CacheException(message: 'Failed to add reading history: ${e.toString()}');
    }
  }
  
  @override
  Future<bool> clearReadingHistory() async {
    try {
      await quranBox.put('reading_history', jsonEncode([]));
      return true;
    } catch (e) {
      throw CacheException(message: 'Failed to clear reading history: ${e.toString()}');
    }
  }
  
  @override
  Future<QuranReadingHistoryModel?> getLastReadPosition() async {
    try {
      final lastPositionJson = quranBox.get('last_read_position');
      if (lastPositionJson == null) {
        return null;
      }
      
      return QuranReadingHistoryModel.fromJson(jsonDecode(lastPositionJson));
    } catch (e) {
      throw CacheException(message: 'Failed to get last read position: ${e.toString()}');
    }
  }
  
  @override
  Future<bool> updateLastReadPosition(QuranReadingHistoryModel history) async {
    try {
      // Create a new history entry with a UUID if not provided
      final newHistory = history.id.isEmpty
          ? QuranReadingHistoryModel(
              id: uuid.v4(),
              surahId: history.surahId,
              ayahNumber: history.ayahNumber,
              page: history.page,
              surahName: history.surahName,
              arabicSurahName: history.arabicSurahName,
              timestamp: history.timestamp,
            )
          : history;
      
      // Save the last read position
      await quranBox.put(
        'last_read_position',
        jsonEncode(newHistory.toJson()),
      );
      
      // Also add to reading history
      await addReadingHistory(newHistory);
      
      return true;
    } catch (e) {
      throw CacheException(message: 'Failed to update last read position: ${e.toString()}');
    }
  }
  
  @override
  Future<void> initializeWithSampleData() async {
    // No need to initialize with sample data as we're using Constants.quranList
  }
}
