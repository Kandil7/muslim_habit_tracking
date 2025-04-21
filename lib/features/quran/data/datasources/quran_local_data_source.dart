import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/quran_bookmark_model.dart';
import '../models/quran_reading_history_model.dart';

/// Interface for local data source operations
abstract class QuranLocalDataSource {
  /// Get all bookmarks
  Future<List<QuranBookmarkModel>> getAllBookmarks();

  /// Add a bookmark
  Future<QuranBookmarkModel> addBookmark(QuranBookmarkModel bookmark);

  /// Update a bookmark
  Future<QuranBookmarkModel> updateBookmark(QuranBookmarkModel bookmark);

  /// Remove a bookmark
  Future<void> removeBookmark(int id);

  /// Get all reading history entries
  Future<List<QuranReadingHistoryModel>> getReadingHistory();

  /// Add a reading history entry
  Future<QuranReadingHistoryModel> addReadingHistory(
    QuranReadingHistoryModel history,
  );

  /// Clear all reading history
  Future<void> clearReadingHistory();

  /// Get the last read position
  Future<QuranReadingHistoryModel?> getLastReadPosition();

  /// Update the last read position
  Future<QuranReadingHistoryModel> updateLastReadPosition(
    QuranReadingHistoryModel history,
  );
}

/// Implementation of QuranLocalDataSource using Hive and SharedPreferences
class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  final Box _quranBox;
  final SharedPreferences _sharedPreferences;

  /// Constructor
  QuranLocalDataSourceImpl({
    required Box quranBox,
    required SharedPreferences sharedPreferences,
  })  : _quranBox = quranBox,
        _sharedPreferences = sharedPreferences;

  // Keys for SharedPreferences
  static const String _bookmarksKey = 'quran_bookmarks';
  static const String _readingHistoryKey = 'quran_reading_history';
  static const String _lastReadPositionKey = 'quran_last_read_position';

  @override
  Future<List<QuranBookmarkModel>> getAllBookmarks() async {
    try {
      final bookmarksJson = _sharedPreferences.getString(_bookmarksKey);
      if (bookmarksJson == null) {
        return [];
      }

      final List<dynamic> bookmarksList = json.decode(bookmarksJson);
      return bookmarksList
          .map((json) => QuranBookmarkModel.fromJson(json))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get bookmarks: $e');
    }
  }

  @override
  Future<QuranBookmarkModel> addBookmark(QuranBookmarkModel bookmark) async {
    try {
      final bookmarks = await getAllBookmarks();
      bookmarks.add(bookmark);

      await _sharedPreferences.setString(
        _bookmarksKey,
        json.encode(bookmarks.map((b) => b.toJson()).toList()),
      );

      return bookmark;
    } catch (e) {
      throw CacheException(message: 'Failed to add bookmark: $e');
    }
  }

  @override
  Future<QuranBookmarkModel> updateBookmark(QuranBookmarkModel bookmark) async {
    try {
      final bookmarks = await getAllBookmarks();
      final index = bookmarks.indexWhere((b) => b.id == bookmark.id);

      if (index == -1) {
        throw CacheException(message: 'Bookmark not found');
      }

      bookmarks[index] = bookmark;

      await _sharedPreferences.setString(
        _bookmarksKey,
        json.encode(bookmarks.map((b) => b.toJson()).toList()),
      );

      return bookmark;
    } catch (e) {
      throw CacheException(message: 'Failed to update bookmark: $e');
    }
  }

  @override
  Future<void> removeBookmark(int id) async {
    try {
      final bookmarks = await getAllBookmarks();
      bookmarks.removeWhere((b) => b.id == id);

      await _sharedPreferences.setString(
        _bookmarksKey,
        json.encode(bookmarks.map((b) => b.toJson()).toList()),
      );
    } catch (e) {
      throw CacheException(message: 'Failed to remove bookmark: $e');
    }
  }

  @override
  Future<List<QuranReadingHistoryModel>> getReadingHistory() async {
    try {
      final historyJson = _sharedPreferences.getString(_readingHistoryKey);
      if (historyJson == null) {
        return [];
      }

      final List<dynamic> historyList = json.decode(historyJson);
      return historyList
          .map((json) => QuranReadingHistoryModel.fromJson(json))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get reading history: $e');
    }
  }

  @override
  Future<QuranReadingHistoryModel> addReadingHistory(
    QuranReadingHistoryModel history,
  ) async {
    try {
      final historyList = await getReadingHistory();
      historyList.add(history);

      await _sharedPreferences.setString(
        _readingHistoryKey,
        json.encode(historyList.map((h) => h.toJson()).toList()),
      );

      return history;
    } catch (e) {
      throw CacheException(message: 'Failed to add reading history: $e');
    }
  }

  @override
  Future<void> clearReadingHistory() async {
    try {
      await _sharedPreferences.remove(_readingHistoryKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear reading history: $e');
    }
  }

  @override
  Future<QuranReadingHistoryModel?> getLastReadPosition() async {
    try {
      final lastReadJson = _sharedPreferences.getString(_lastReadPositionKey);
      if (lastReadJson == null) {
        return null;
      }

      return QuranReadingHistoryModel.fromJson(json.decode(lastReadJson));
    } catch (e) {
      throw CacheException(message: 'Failed to get last read position: $e');
    }
  }

  @override
  Future<QuranReadingHistoryModel> updateLastReadPosition(
    QuranReadingHistoryModel history,
  ) async {
    try {
      await _sharedPreferences.setString(
        _lastReadPositionKey,
        json.encode(history.toJson()),
      );

      // Also add to reading history
      await addReadingHistory(history);

      return history;
    } catch (e) {
      throw CacheException(message: 'Failed to update last read position: $e');
    }
  }
}
