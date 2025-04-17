import 'package:equatable/equatable.dart';

import '../../domain/entities/bookmark.dart';
import '../../domain/entities/quran.dart';
import '../../domain/entities/reading_history.dart';

/// Base class for all Quran states
abstract class QuranState extends Equatable {
  const QuranState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class QuranInitial extends QuranState {
  const QuranInitial();
}

/// Loading state
class QuranLoading extends QuranState {
  const QuranLoading();
}

/// State when surahs are loaded
class SurahsLoaded extends QuranState {
  final List<Quran> surahs;

  const SurahsLoaded({required this.surahs});

  @override
  List<Object?> get props => [surahs];
}

/// State when a specific surah is loaded
class SurahLoaded extends QuranState {
  final Quran surah;

  const SurahLoaded({required this.surah});

  @override
  List<Object?> get props => [surah];
}

/// State when bookmarks are loaded
class BookmarksLoaded extends QuranState {
  final List<QuranBookmark> bookmarks;

  const BookmarksLoaded({required this.bookmarks});

  @override
  List<Object?> get props => [bookmarks];
}

/// State when a bookmark is added
class BookmarkAdded extends QuranState {
  final QuranBookmark bookmark;

  const BookmarkAdded({required this.bookmark});

  @override
  List<Object?> get props => [bookmark];
}

/// State when a bookmark is removed
class BookmarkRemoved extends QuranState {
  final String bookmarkId;

  const BookmarkRemoved({required this.bookmarkId});

  @override
  List<Object?> get props => [bookmarkId];
}

/// State when reading history is loaded
class ReadingHistoryLoaded extends QuranState {
  final List<QuranReadingHistory> history;

  const ReadingHistoryLoaded({required this.history});

  @override
  List<Object?> get props => [history];
}

/// State when reading history is added
class ReadingHistoryAdded extends QuranState {
  final QuranReadingHistory history;

  const ReadingHistoryAdded({required this.history});

  @override
  List<Object?> get props => [history];
}

/// State when reading history is cleared
class ReadingHistoryCleared extends QuranState {
  const ReadingHistoryCleared();
}

/// State when last read position is loaded
class LastReadPositionLoaded extends QuranState {
  final QuranReadingHistory? position;

  const LastReadPositionLoaded({required this.position});

  @override
  List<Object?> get props => [position];
}

/// State when last read position is updated
class LastReadPositionUpdated extends QuranState {
  final QuranReadingHistory history;

  const LastReadPositionUpdated({required this.history});

  @override
  List<Object?> get props => [history];
}

/// Error state
class QuranError extends QuranState {
  final String message;

  const QuranError({required this.message});

  @override
  List<Object?> get props => [message];
}
