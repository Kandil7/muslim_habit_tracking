import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/quran_bookmark_model.dart';
import '../models/quran_reading_history_model.dart';

/// Interface for the local data source for Quran feature
abstract class QuranLocalDataSource {
  /// Get all bookmarks
  Future<List<QuranBookmarkModel>> getAllBookmarks();

  /// Add a bookmark
  Future<QuranBookmarkModel> addBookmark(QuranBookmarkModel bookmark);

  /// Update a bookmark
  Future<QuranBookmarkModel> updateBookmark(QuranBookmarkModel bookmark);

  /// Delete a bookmark
  Future<void> deleteBookmark(int id);

  /// Get all reading history entries
  Future<List<QuranReadingHistoryModel>> getReadingHistory();

  /// Add a reading history entry
  Future<QuranReadingHistoryModel> addReadingHistory(
    QuranReadingHistoryModel history,
  );

  /// Clear reading history
  Future<void> clearReadingHistory();

  /// Get the last read position
  Future<QuranReadingHistoryModel?> getLastReadPosition();

  /// Update the last read position
  Future<QuranReadingHistoryModel> updateLastReadPosition(
    QuranReadingHistoryModel history,
  );
}

/// Implementation of the local data source for Quran feature using Hive
class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  final Box quranBox;
  final Uuid uuid;

  // Keys for different sections in the Hive box
  static const String _bookmarksKey = 'bookmarks';
  static const String _historyKey = 'history';
  static const String _lastPositionKey = 'last_position';

  QuranLocalDataSourceImpl({required this.quranBox, required this.uuid});

  @override
  Future<List<QuranBookmarkModel>> getAllBookmarks() async {
    try {
      final bookmarksJson = quranBox.get(_bookmarksKey);
      if (bookmarksJson == null) {
        return [];
      }

      final List<dynamic> bookmarksList = json.decode(bookmarksJson);
      return bookmarksList
          .map((bookmark) => QuranBookmarkModel.fromJson(bookmark))
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get bookmarks from local storage: $e',
      );
    }
  }

  @override
  Future<QuranBookmarkModel> addBookmark(QuranBookmarkModel bookmark) async {
    try {
      final bookmarks = await getAllBookmarks();

      // Check if a bookmark for this page already exists
      final existingBookmarkIndex = bookmarks.indexWhere(
        (b) => b.page == bookmark.page,
      );

      // If a bookmark for this page already exists, remove it
      if (existingBookmarkIndex != -1) {
        bookmarks.removeAt(existingBookmarkIndex);
      }

      // Create new bookmark with a unique ID
      final newBookmark = QuranBookmarkModel(
        id: DateTime.now().millisecondsSinceEpoch,
        surahName: bookmark.surahName,
        ayahNumber: bookmark.ayahNumber,
        ayahId: bookmark.ayahId,
        page: bookmark.page,
        colorCode: bookmark.colorCode,
        name: bookmark.name,
      );

      // Add to list and save
      bookmarks.add(newBookmark);
      await quranBox.put(
        _bookmarksKey,
        json.encode(bookmarks.map((b) => b.toJson()).toList()),
      );

      return newBookmark;
    } catch (e) {
      throw CacheException(
        message: 'Failed to add bookmark to local storage: $e',
      );
    }
  }

  @override
  Future<QuranBookmarkModel> updateBookmark(QuranBookmarkModel bookmark) async {
    try {
      final bookmarks = await getAllBookmarks();

      // Find the bookmark to update
      final bookmarkIndex = bookmarks.indexWhere((b) => b.id == bookmark.id);

      if (bookmarkIndex == -1) {
        throw CacheException(message: 'Bookmark not found');
      }

      // Update the bookmark
      bookmarks[bookmarkIndex] = bookmark;

      // Save the updated list
      await quranBox.put(
        _bookmarksKey,
        json.encode(bookmarks.map((b) => b.toJson()).toList()),
      );

      return bookmark;
    } catch (e) {
      throw CacheException(
        message: 'Failed to update bookmark in local storage: $e',
      );
    }
  }

  @override
  Future<void> deleteBookmark(int id) async {
    try {
      final bookmarks = await getAllBookmarks();

      // Remove the bookmark
      bookmarks.removeWhere((b) => b.id == id);

      // Save the updated list
      await quranBox.put(
        _bookmarksKey,
        json.encode(bookmarks.map((b) => b.toJson()).toList()),
      );
    } catch (e) {
      throw CacheException(
        message: 'Failed to delete bookmark from local storage: $e',
      );
    }
  }

  @override
  Future<List<QuranReadingHistoryModel>> getReadingHistory() async {
    try {
      final historyJson = quranBox.get(_historyKey);
      if (historyJson == null) {
        return [];
      }

      final List<dynamic> historyList = json.decode(historyJson);
      return historyList
          .map((history) => QuranReadingHistoryModel.fromJson(history))
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get reading history from local storage: $e',
      );
    }
  }

  @override
  Future<QuranReadingHistoryModel> addReadingHistory(
    QuranReadingHistoryModel history,
  ) async {
    try {
      final historyEntries = await getReadingHistory();

      // Create new history entry with a unique ID
      final newHistory = QuranReadingHistoryModel(
        id: DateTime.now().millisecondsSinceEpoch,
        surahNumber: history.surahNumber,
        surahName: history.surahName,
        ayahNumber: history.ayahNumber,
        pageNumber: history.pageNumber,
        timestamp: DateTime.now(),
        durationSeconds: history.durationSeconds,
      );

      // Add to list and save
      historyEntries.add(newHistory);

      // Keep only the last 100 entries
      if (historyEntries.length > 100) {
        historyEntries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        historyEntries.removeRange(100, historyEntries.length);
      }

      await quranBox.put(
        _historyKey,
        json.encode(historyEntries.map((h) => h.toJson()).toList()),
      );

      return newHistory;
    } catch (e) {
      throw CacheException(
        message: 'Failed to add reading history to local storage: $e',
      );
    }
  }

  @override
  Future<void> clearReadingHistory() async {
    try {
      await quranBox.delete(_historyKey);
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear reading history from local storage: $e',
      );
    }
  }

  @override
  Future<QuranReadingHistoryModel?> getLastReadPosition() async {
    try {
      final lastPositionJson = quranBox.get(_lastPositionKey);
      if (lastPositionJson == null) {
        return null;
      }

      return QuranReadingHistoryModel.fromJson(json.decode(lastPositionJson));
    } catch (e) {
      throw CacheException(
        message: 'Failed to get last read position from local storage: $e',
      );
    }
  }

  @override
  Future<QuranReadingHistoryModel> updateLastReadPosition(
    QuranReadingHistoryModel history,
  ) async {
    try {
      // Create new history entry with a unique ID
      final newHistory = QuranReadingHistoryModel(
        id: DateTime.now().millisecondsSinceEpoch,
        surahNumber: history.surahNumber,
        surahName: history.surahName,
        ayahNumber: history.ayahNumber,
        pageNumber: history.pageNumber,
        timestamp: DateTime.now(),
        durationSeconds: history.durationSeconds,
      );

      // Save the last position
      await quranBox.put(_lastPositionKey, json.encode(newHistory.toJson()));

      // Also add to reading history
      await addReadingHistory(newHistory);

      return newHistory;
    } catch (e) {
      throw CacheException(
        message: 'Failed to update last read position in local storage: $e',
      );
    }
  }
}
